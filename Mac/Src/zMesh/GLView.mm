/**
 *  GLView.mm
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

#import "GLView.h"

@implementation GLView
@synthesize context;
@synthesize pixelFormat;

- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)aShareContext
{
    if (self = [super initWithFrame:frameRect])
	{
		NSOpenGLPixelFormatAttribute attribs[] =
		{
			kCGLPFAAccelerated,
			kCGLPFANoRecovery,
			kCGLPFADoubleBuffer,
			kCGLPFAColorSize, 24,
			kCGLPFADepthSize, 16,
			0
		};
		
		self.pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
		
		if (!self.pixelFormat)
			NSLog(@"No OpenGL pixel format");
		
		self.context = [[NSOpenGLContext alloc] initWithFormat:self.pixelFormat shareContext:aShareContext];
		
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(reshape) 
                                                     name:NSViewGlobalFrameDidChangeNotification
                                                   object:self];
    }
    
    return self;
}

- (void)dealloc
{
    [self setContext:nil];
    [self setPixelFormat:nil];
	
    [super dealloc];
}

- (void)lockFocus
{
    [super lockFocus];
    
	if ([context view] != self)
	{
        [context setView:self];
    }
	
    [context makeCurrentContext];
}

- (void) reshape
{
	[context update];
	[self.delegate reshape];
}

#pragma mark -
#pragma mark Mouse-handling methods

- (void)mouseDown:(NSEvent *)event
{
	lastMovementPosition = [event locationInWindow];
	lastMovementPosition = [self convertPoint:lastMovementPosition fromView:self];
}

- (void)mouseDragged:(NSEvent *)event
{
	NSPoint currentMovementPosition = [event locationInWindow];
	
	if ([event modifierFlags] & NSAlternateKeyMask)
	{
		[self.delegate zoom:(currentMovementPosition.y - lastMovementPosition.y)];
	}
	else
	{
		[self.delegate moveX:(lastMovementPosition.y - currentMovementPosition.y) moveY:(currentMovementPosition.x - lastMovementPosition.x)];
	}
	lastMovementPosition = currentMovementPosition;
}

@end
