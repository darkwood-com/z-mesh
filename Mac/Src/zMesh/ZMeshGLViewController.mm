/**
 *  ZMeshGLViewController.mm
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

#import "ZMeshGLViewController.h"

@implementation ZMeshGLViewController

- (void)loadView
{
	GLView* aView = [[[GLView alloc] initWithFrame:NSMakeRect(0, 0, 200, 200) shareContext:nil] autorelease];
	//[aView setAutoresizingMask:NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin];
	
	[aView setDelegate:self];
	
	[NSOpenGLContext clearCurrentContext];
	[aView.context makeCurrentContext];
	
	self.view = aView;
	
	[super loadView];
	
	[self openMeshType:@"stl" andData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cube" ofType:@"stl"]]];
}

- (void)dealloc
{
	[context release];
	
    [super dealloc];
}

- (void)drawFrame
{
	//[[(GLView *)self.view context] makeCurrentContext];
	
	[super drawFrame];
	
	[[(GLView *)self.view context] flushBuffer];
}

@end
