/**
 *  ZCamera.cpp
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

#include "ZCamera.h"

ZCamera::ZCamera() :
	m_oShot(vcg::Camera<float>()),
	m_fNearDist(1.0),
	m_fFarDist(1000.0),
	m_oEye(0,0,1),
	m_oCenter(0,0,0),
	m_oUp(0,1,0)
{
}

void ZCamera::applyViewport(vcg::Point2<int> oViewport) {
	const float fFieldOfView = 45.0, fRatio = (float)oViewport.X()/oViewport.Y();
	
	m_oShot.Intrinsics.SetPerspective(fFieldOfView, fRatio, m_fNearDist, oViewport);
	
	glViewport(0, 0, oViewport.X(),oViewport.Y());
}

void ZCamera::applyProjection() {
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	float sx,dx,bt,tp,nr;
	m_oShot.Intrinsics.GetFrustum(sx,dx,bt,tp,nr);
	
	if(m_oShot.Intrinsics.cameraType == vcg::Camera<float>::PERSPECTIVE) {
		float ratio = m_fNearDist/nr;
		sx *= ratio;
		dx *= ratio;
		bt *= ratio;
		tp *= ratio;
	}
	
	assert(glGetError()==0);
	
	switch(m_oShot.Intrinsics.cameraType) 
	{
		case vcg::Camera<float>::PERSPECTIVE: zglFrustum(sx,dx,bt,tp,m_fNearDist,m_fFarDist); break;
		case vcg::Camera<float>::ORTHO:       zglOrtho(sx,dx,bt,tp,m_fNearDist,m_fFarDist); break;
	}
	
	assert(glGetError()==0);
	
	glMatrixMode(GL_MODELVIEW);
}

void ZCamera::applyLook()
{
	//implementation of gluLookAt() with vcg
	m_oShot.SetViewPoint(m_oEye);
	m_oShot.LookAt(m_oCenter, m_oUp);
	
	glMultMatrixf(m_oShot.Extrinsics.Rot().V());
    glTranslatef(-m_oEye.X(), -m_oEye.Y(), -m_oEye.Z());
}
