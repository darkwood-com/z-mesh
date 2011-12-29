/**
 *  ZObject.cpp
 *  zMesh
 *
 *  Created by Mathieu LEDRU on 14/11/10.
 *
 *  GPL License:
 *  Copyright (c) 2010, Mathieu LEDRU
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *  
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "ZObject.h"

#import <wrap/io_trimesh/import.h>
#import <wrap/io_trimesh/export.h>

#import <vcg/complex/trimesh/update/bounding.h>
#import <vcg/complex/trimesh/update/flag.h>
#import <vcg/complex/trimesh/update/normal.h>
#import <vcg/complex/trimesh/update/curvature.h>

#import <vcg/complex/trimesh/smooth.h>

ZObject::ZObject() :
m_eRenderMode(ZRenderModeNone),
m_fVertexes(NULL),
m_fNormals(NULL)
{
	m_oPos.SetZero();
	m_oRot.SetZero();
}

ZObject::~ZObject()
{
	if(m_fVertexes) {delete m_fVertexes, m_fVertexes = NULL;}
	if(m_fNormals ) {delete m_fNormals,  m_fNormals  = NULL;}
}

int ZObject::loadFile(const char* sPath)
{
	m_oMesh.Clear();
	
	int iErr;
	int iLoadmask;
	
	//load mesh model
	if(vcg::tri::io::Importer<ZMesh>::FileExtension(sPath,"stl"))
	{
		iErr = vcg::tri::io::ImporterSTL<ZMesh>::Open(m_oMesh, sPath, iLoadmask);
	}
	else if(vcg::tri::io::Importer<ZMesh>::FileExtension(sPath,"obj"))
	{
		iErr = vcg::tri::io::ImporterOBJ<ZMesh>::Open(m_oMesh, sPath, iLoadmask);
	}
	
	vcg::tri::UpdateBounding<ZMesh>::Box(m_oMesh);
	
	vcg::tri::Clean<ZMesh>::RemoveDuplicateVertex(m_oMesh);
	
	vcg::tri::UpdateNormals<ZMesh>::PerVertexNormalizedPerFace(m_oMesh);
	vcg::tri::UpdateNormals<ZMesh>::PerFaceNormalized(m_oMesh);
	
	return iErr;
}

int ZObject::saveFile(const char* sPath)
{
	int iErr;
	int iSavemask = 0;
	
	//load mesh model
	if(vcg::tri::io::Exporter<ZMesh>::FileExtension(sPath,"stl"))
	{
		iErr = vcg::tri::io::ExporterSTL<ZMesh>::Save(m_oMesh, sPath, iSavemask);
	}
	else if(vcg::tri::io::Exporter<ZMesh>::FileExtension(sPath,"obj"))
	{
		iErr = vcg::tri::io::ExporterOBJ<ZMesh>::Save(m_oMesh, sPath, iSavemask);
	}
	
	return iErr;
}

void ZObject::renderMode(ZRenderMode eRenderMode)
{
	m_eRenderMode = eRenderMode;
	
	if(m_fVertexes) {delete m_fVertexes, m_fVertexes = NULL;}
	if(m_fNormals ) {delete m_fNormals,  m_fNormals  = NULL;}
	
	
	int iPos = 0;
	switch (m_eRenderMode)
	{
        case ZRenderModeNone:
            
            break;
		case ZRenderModeBox: {
			m_fVertexes = new GLfloat[12 * 2 * 3];
			
			vcg::Box3<ZMesh::ScalarType> b = m_oMesh.bbox;
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];

			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];

			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.min[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.max[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.min[2];
			m_fVertexes[iPos++] = b.min[0],m_fVertexes[iPos++] = b.max[1],m_fVertexes[iPos++] = b.max[2];
			break;
		} case ZRenderModeWire: {
			m_fVertexes = new GLfloat[m_oMesh.fn * 9 * 2];
			
			for(ZMesh::FaceIterator fi = m_oMesh.face.begin(); fi != m_oMesh.face.end(); ++fi)
			{
				for (int i = 0; i < 3; i++)
				{
					m_fVertexes[iPos + 0 + i * 6] = fi->P(i)[0];
					m_fVertexes[iPos + 1 + i * 6] = fi->P(i)[1];
					m_fVertexes[iPos + 2 + i * 6] = fi->P(i)[2];
					
					m_fVertexes[iPos + 3 + i * 6] = fi->P((i + 1) % 3)[0];
					m_fVertexes[iPos + 4 + i * 6] = fi->P((i + 1) % 3)[1];
					m_fVertexes[iPos + 5 + i * 6] = fi->P((i + 1) % 3)[2];
				}
				
				iPos += 3 * 6;
			}
			break;
		} case ZRenderModePoints: {
			m_fVertexes = new GLfloat[m_oMesh.fn * 9];
			
			for(ZMesh::FaceIterator fi = m_oMesh.face.begin(); fi != m_oMesh.face.end(); ++fi)
			{
				for (int i = 0; i < 3; i++)
				{
					m_fVertexes[iPos + 0 + i * 3] = fi->P(i)[0];
					m_fVertexes[iPos + 1 + i * 3] = fi->P(i)[1];
					m_fVertexes[iPos + 2 + i * 3] = fi->P(i)[2];
				}
				
				iPos += 9;
			}
			break;
		} case ZRenderModeFlat: {
			m_fVertexes = new GLfloat[m_oMesh.fn * 9];
			m_fNormals = new GLfloat[m_oMesh.fn * 9];
			
			for(ZMesh::FaceIterator fi = m_oMesh.face.begin(); fi != m_oMesh.face.end(); ++fi)
			{
				for (int i = 0; i < 3; i++)
				{
					m_fVertexes[iPos + 0 + i * 3] = fi->P(i)[0];
					m_fVertexes[iPos + 1 + i * 3] = fi->P(i)[1];
					m_fVertexes[iPos + 2 + i * 3] = fi->P(i)[2];
					
					m_fNormals[iPos + 0 + i * 3] = fi->N()[0];
					m_fNormals[iPos + 1 + i * 3] = fi->N()[1];
					m_fNormals[iPos + 2 + i * 3] = fi->N()[2];
				}
				
				iPos += 9;
			}
			break;
		} case ZRenderModeSmooth: {
			m_fVertexes = new GLfloat[m_oMesh.fn * 9];
			m_fNormals = new GLfloat[m_oMesh.fn * 9];
			
			for(ZMesh::FaceIterator fi = m_oMesh.face.begin(); fi != m_oMesh.face.end(); ++fi)
			{
				for (int i = 0; i < 3; i++)
				{
					m_fVertexes[iPos + 0 + i * 3] = fi->P(i)[0];
					m_fVertexes[iPos + 1 + i * 3] = fi->P(i)[1];
					m_fVertexes[iPos + 2 + i * 3] = fi->P(i)[2];
					
					m_fNormals[iPos + 0 + i * 3] = fi->V(i)->N()[0];
					m_fNormals[iPos + 1 + i * 3] = fi->V(i)->N()[1];
					m_fNormals[iPos + 2 + i * 3] = fi->V(i)->N()[2];
				}
				
				iPos += 9;
			}
			break;
		}
	}
}

void ZObject::render()
{
	// Save the current transformation by pushing it on the stack
	glPushMatrix();
	
	glColor4f(m_oColor.X(), m_oColor.Y(), m_oColor.Z(), 1.0);

	// Translate to the current position
	glTranslatef(m_oPos.X(), m_oPos.Y(), m_oPos.Z());
	
	// Rotate to the current rotation
	glRotatef(m_oRot.X(), 1.0, 0.0, 0.0);
	glRotatef(m_oRot.Y(), 0.0, 1.0, 0.0);
	glRotatef(m_oRot.Z(), 0.0, 0.0, 1.0);
	
	vcg::Box3<ZMesh::ScalarType>& oBBox = m_oMesh.bbox;
	vcg::Point3<float> center = -(oBBox.min + oBBox.max) / 2;
	
	glTranslatef(center.X(), center.Y(), center.Z());

	switch (m_eRenderMode)
	{
		case ZRenderModeNone: {
			break;
		} case ZRenderModeBox: {
			glDisable(GL_LIGHTING);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glVertexPointer(3, GL_FLOAT, 0, m_fVertexes);
			glDrawArrays(GL_LINES, 0, 12 * 2);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glEnable(GL_LIGHTING);
			break;
		} case ZRenderModeWire: {
			glDisable(GL_LIGHTING);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glVertexPointer(3, GL_FLOAT, 0, m_fVertexes);
			glDrawArrays(GL_LINES, 0, m_oMesh.fn * 3 * 2);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glEnable(GL_LIGHTING);
			break;
		} case ZRenderModePoints:  {
			glDisable(GL_LIGHTING);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glVertexPointer(3, GL_FLOAT, 0, m_fVertexes);
			glDrawArrays(GL_POINTS, 0, m_oMesh.fn * 3);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glEnable(GL_LIGHTING);
			break;
		} case ZRenderModeFlat:
		  case ZRenderModeSmooth: {
			glEnableClientState(GL_NORMAL_ARRAY);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glNormalPointer(GL_FLOAT, 0, m_fNormals);
			glVertexPointer(3, GL_FLOAT, 0, m_fVertexes);
			glDrawArrays(GL_TRIANGLES, 0, m_oMesh.fn * 3);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glDisableClientState(GL_NORMAL_ARRAY);
			break;
		}
	}
	
	glPopMatrix();
}
