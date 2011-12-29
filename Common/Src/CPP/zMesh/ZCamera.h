/**
 *  ZCamera.h
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


#ifndef IS_ZCAMERA_H
#define IS_ZCAMERA_H

#import <vcg/space/point3.h>
#import <vcg/math/shot.h>

#import "ZOpenGL.h"

class ZCamera {
	protected:
	vcg::Shot<float> m_oShot;
	
	float m_fNearDist;
	float m_fFarDist;
	
	public:
	vcg::Point3<float> m_oEye;
	vcg::Point3<float> m_oCenter;
	vcg::Point3<float> m_oUp;
	
	ZCamera();
	
	void applyViewport(vcg::Point2<int> oViewport);
	void applyProjection();
	void applyLook();
};

#endif
