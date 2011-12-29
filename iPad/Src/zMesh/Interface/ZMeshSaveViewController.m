/**
 *  ZMeshSaveViewController.h
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

#import "ZMeshSaveViewController.h"

@implementation ZMeshSaveViewController
@synthesize delegate;
@synthesize filePathText;

- (void)dealloc
{
	[self setDelegate:nil];
	[self setFilePathText:nil];
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
	[aTextField resignFirstResponder];
	
	return YES;
}

- (void) saveOBJ:(id)sender
{
	[self.delegate saveMeshToPath:[self.filePathText.text stringByAppendingPathExtension:@"obj"]];
}

- (void) saveSTL:(id)sender
{
	[self.delegate saveMeshToPath:[self.filePathText.text stringByAppendingPathExtension:@"stl"]];
}

- (void) cancel:(id)sender
{
	[self.delegate saveMeshToPath:nil];
}

@end
