/**
 *  ZWindow.cpp
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

#include "ZWindow.h"

#include <string>
#include <algorithm>
#include <cctype>

ZWindow::ZWindow() :
	m_fZoomScale(0),
	m_eRenderMode(ZRenderModeFlat)
{
	//setup gl
	glEnable(GL_DEPTH_TEST);
	//glEnable(GL_NORMALIZE);
	
	/*
	GLfloat ambientProperties[] = {0.15f,0.15f,0.15f,1.0f};
	GLfloat difuseProperties[] = {0.5f,0.5f,0.5f,1.0f};
	GLfloat specularProperties[] = {0.8f,0.8f,0.8f,1.0f};
    GLfloat positionProperties[] = {0.0f, 0.0f, -10.0f, 0.0f};
    */
	
    glEnable(GL_LIGHTING);
    //glLightfv(GL_LIGHT0, GL_AMBIENT, ambientProperties);
    //glLightfv(GL_LIGHT0, GL_DIFFUSE, difuseProperties);
	//glLightfv(GL_LIGHT0, GL_SPECULAR, specularProperties);
    //glLightfv(GL_LIGHT0, GL_POSITION, positionProperties);
	glEnable(GL_LIGHT0);
    
	glEnable(GL_COLOR_MATERIAL);
	//glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
    //glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specularProperties);
	//glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, difuseProperties);
	//glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, ambientProperties);
	
	//glEnable(GL_POLYGON_OFFSET_FILL);
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

bool ZWindow::canOpenFileType(const char* sType)
{
	std::string str(sType);
	std::transform(str.begin(), str.end(), str.begin(), toupper);
	
	return str == "STL" || str == "OBJ" ;
}

void ZWindow::loadFile(const char* sPath)
{
	m_oModel.loadFile(sPath);
	m_oModel.renderMode(m_eRenderMode);
	
	const vcg::Box3<ZMesh::ScalarType>& oBBox = m_oModel.m_oMesh.bbox;
	m_fZoomScale = oBBox.DimZ();
	
	m_oModel.m_oColor.X() = 1.0f;
	m_oModel.m_oColor.Y() = 0.5f;
	m_oModel.m_oColor.Z() = 0.0f;
	
	m_oCamera.m_oEye.X() = 0;
	m_oCamera.m_oEye.Y() = 0;
	m_oCamera.m_oEye.Z() = m_fZoomScale * 3;
	m_oCamera.m_oCenter.X() = 0;
	m_oCamera.m_oCenter.Y() = 0;
	m_oCamera.m_oCenter.Z() = 0;
	m_oCamera.m_oUp.X() = 0;
	m_oCamera.m_oUp.Y() = 1;
	m_oCamera.m_oUp.Z() = 0;
}

void ZWindow::saveFile(const char* sPath)
{
	m_oModel.saveFile(sPath);
}

void ZWindow::renderMode(ZRenderMode eRenderMode)
{
	m_oModel.renderMode(eRenderMode);
}

void ZWindow::reshape(vcg::Point2<int> oViewport)
{
	m_oCamera.applyViewport(oViewport);
	m_oCamera.applyProjection();
}

void ZWindow::render()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	
	m_oCamera.applyLook();
	m_oModel.render();
}

void ZWindow::eventMove(float x, float y)
{
	m_oModel.m_oRot.X() += x;
	m_oModel.m_oRot.Y() += y;
}

void ZWindow::eventZoom(float distance)
{
	m_oModel.m_oPos.Z() += distance * m_fZoomScale / 250.0f;
}
