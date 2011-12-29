/**
 *  ZObject.h
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


#ifndef IS_ZOBJECT_H
#define IS_ZOBJECT_H

#import <vector>

#import <vcg/simplex/vertex/base.h>
#import <vcg/simplex/face/base.h>
#import <vcg/complex/trimesh/base.h>

#import <vcg/simplex/vertex/component_ocf.h>
#import <vcg/simplex/edge/base.h>
#import <vcg/simplex/face/component_ocf.h>

#import "ZOpenGL.h"

class ZFace;
class ZVertex;

struct ZUsedTypes : public vcg::UsedTypes< vcg::Use<ZVertex>::AsVertexType, vcg::Use<ZFace>::AsFaceType > {};

class ZVertex  : public vcg::Vertex< ZUsedTypes, vcg::vertex::Coord3f, vcg::vertex::BitFlags, vcg::vertex::Normal3f, vcg::vertex::Mark, vcg::vertex::Color4b > {};
class ZFace    : public vcg::Face  < ZUsedTypes, vcg::face::VertexRef, vcg::face::FFAdj, vcg::face::Mark, vcg::face::BitFlags, vcg::face::Normal3f > {};

class ZMesh : public vcg::tri::TriMesh< std::vector<ZVertex>, std::vector<ZFace> > {};

enum ZRenderMode {
	ZRenderModeNone,
	ZRenderModeBox,
	ZRenderModePoints,
	ZRenderModeWire,
	ZRenderModeFlat,
	ZRenderModeSmooth,
};

class ZObject {
	protected:
	ZRenderMode m_eRenderMode;
	
	GLfloat* m_fVertexes;
	GLfloat* m_fNormals;
	
	public :
	ZMesh m_oMesh;
	vcg::Point3<float> m_oPos;
	vcg::Point3<float> m_oRot;
	vcg::Color4<float> m_oColor;
	
	ZObject();
	virtual ~ZObject();
	
	int loadFile(const char* sPath);
	int saveFile(const char* sPath);
	
	void renderMode(ZRenderMode eRenderMode);
	
	void render();
};

#endif
