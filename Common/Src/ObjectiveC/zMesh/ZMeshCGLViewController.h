/**
 *  ZMeshCGLViewController.h
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

#import "ZMeshApple.h"

#import "ZMeshCGLDelegate.h"
#import "ZMeshCGLView.h"

#import "ZWindow.h"

@interface ZMeshCGLViewController : ZMeshViewController<ZMeshCGLDelegate,ZMeshCGLViewDelegate>
{
    BOOL animating;
    NSTimeInterval animationFrameInterval;

    NSTimer *animationTimer;
	
	ZWindow* renderWindow;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSTimeInterval animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

- (void)drawFrame;

@end
