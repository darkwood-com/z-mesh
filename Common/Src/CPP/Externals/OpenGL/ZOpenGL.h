/**
 *  ZOpenGL.mm
 *  ZMesh
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

#ifndef IS_ZOPENGL_H
#define IS_ZOPENGL_H

#if defined (D_MAC)
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>

#define zglFrustum(sx,dx,bt,tp,near,far) glFrustum(sx,dx,bt,tp,near,far)
#define zglOrtho(sx,dx,bt,tp,near,far) glOrtho(sx,dx,bt,tp,near,far)

#elif defined (D_IPHONE) || defined(D_IPAD)
#import <OpenGLES/ES1/gl.h>

#define zglFrustum(sx,dx,bt,tp,near,far) glFrustumf(sx,dx,bt,tp,near,far)
#define zglOrtho(sx,dx,bt,tp,near,far) glOrthof(sx,dx,bt,tp,near,far)

#elif defined (D_WIN)
#include <windows.h>

#include <GL/gl.h>
#else
#error //no plateform defined!!!
#endif

#endif
