/**
 *  ZMeshGenericProtocolViewController.h
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

#import "ZMeshGenericProtocolViewController.h"

@implementation ZMeshGenericProtocolViewController
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	
    [super viewWillAppear:animated];
}

- (void)dealloc
{
	[self setDelegate:nil];
	
	[super dealloc];
}

- (NSString*) fileTypeFromURL:(NSURL*) url
{
	NSArray* parts = [[url absoluteString] componentsSeparatedByString:@"."];
	NSString* aFilePath = [parts objectAtIndex:[parts count]-1];
	
	return aFilePath;
}

@end

