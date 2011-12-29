/**
 *  ZMeshCGLViewController.mm
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

#import "ZMeshCGLViewController.h"

@implementation ZMeshCGLViewController
@synthesize animating;

- (void)loadView
{
    animating = FALSE;
    animationFrameInterval = 1/30.0f; //FPS
    animationTimer = nil;
	
	renderWindow = new ZWindow();
	
	ZMeshRect rect = self.view.bounds; 
	vcg::Point2<int> oViewport(rect.size.width, rect.size.height);
	renderWindow->reshape(oViewport);
}

- (void)dealloc
{
	delete renderWindow;
	
    [super dealloc];
}

- (NSTimeInterval)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSTimeInterval)frameInterval
{
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(animationFrameInterval) target:self selector:@selector(drawFrame) userInfo:nil repeats:TRUE];
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
		[animationTimer invalidate];
		animationTimer = nil;
        
        animating = FALSE;
    }
}

- (void)drawFrame
{
	renderWindow->render();
}

#pragma mark ZMeshCGLViewDelegate

- (void)reshape
{
	ZMeshRect rect = self.view.bounds;
	
	vcg::Point2<int> oViewport(rect.size.width, rect.size.height);
	renderWindow->reshape(oViewport);
	
	[self drawFrame];
}

- (void)moveX:(float)x moveY:(float)y
{
	renderWindow->eventMove(x, y);
}

- (void)zoom:(float)distance
{
	renderWindow->eventZoom(distance);
}

#pragma mark ZMeshCGLDelegate

- (BOOL)canOpenMeshType:(NSString*)aType
{
	return renderWindow->canOpenFileType([aType UTF8String]);
}

- (void)openMeshType:(NSString*)aType andData:(NSData*)aData
{
	static NSInteger fileNB = 0;
	
	//we store mesh data into a temporary file
	NSString* tempFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ZMeshCache"];
	
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:tempFile];
	if (!exists)
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:tempFile withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	tempFile = [tempFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", fileNB++]];
	tempFile = [tempFile stringByAppendingPathExtension:aType];

	[aData writeToFile:tempFile atomically:YES];
	
	renderWindow->loadFile([tempFile UTF8String]);
}

- (void)saveMeshToPath:(NSString*)aPath
{
	renderWindow->saveFile([aPath UTF8String]);
}

- (void)renderMeshMode:(NSString*)aMode
{
	if([aMode isEqualToString:@"None"])
	{
		renderWindow->renderMode(ZRenderModeNone);
	}
	else if ([aMode isEqualToString:@"Box"])
	{
		renderWindow->renderMode(ZRenderModeBox);
	}
	else if ([aMode isEqualToString:@"Points"])
	{
		renderWindow->renderMode(ZRenderModePoints);
	}
	else if ([aMode isEqualToString:@"Wire"])
	{
		renderWindow->renderMode(ZRenderModeWire);
	}
	else if ([aMode isEqualToString:@"Flat"])
	{
		renderWindow->renderMode(ZRenderModeFlat);
	}
	else if ([aMode isEqualToString:@"Smooth"])
	{
		renderWindow->renderMode(ZRenderModeSmooth);
	}
}

@end
