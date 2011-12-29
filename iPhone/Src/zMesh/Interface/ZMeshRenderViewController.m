/**
 *  ZMeshRenderViewController.h
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

#import "ZMeshRenderViewController.h"

@implementation ZMeshRenderViewController
@synthesize delegate;

- (void)dealloc
{
	[self setDelegate:nil];
	
	[super dealloc];
}

- (IBAction) renderBox:(id)sender
{
	[self.delegate renderMeshMode:@"Box"];
}

- (IBAction) renderPoints:(id)sender
{
	[self.delegate renderMeshMode:@"Points"];
}

- (IBAction) renderWire:(id)sender
{
	[self.delegate renderMeshMode:@"Wire"];
}

- (IBAction) renderFlat:(id)sender
{
	[self.delegate renderMeshMode:@"Flat"];
}

- (IBAction) renderSmooth:(id)sender
{
	[self.delegate renderMeshMode:@"Smooth"];
}

- (void) cancel:(id)sender
{
	[self.delegate renderMeshMode:nil];
}

@end
