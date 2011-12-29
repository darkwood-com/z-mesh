/**
 *  ZMeshAppDelegate.h
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

#import <Cocoa/Cocoa.h>

#import "ZMeshGLViewController.h"

@interface ZMeshAppDelegate : NSObject <NSApplicationDelegate> {
	NSURL* saveFile; //last saved file
	
    NSWindow* window;
    ZMeshGLViewController* viewController;
	
	NSMenuItem* renderModeBoxMenuItem;
	NSMenuItem* renderModePointsMenuItem;
	NSMenuItem* renderModeWireMenuItem;
	NSMenuItem* renderModeFlatMenuItem;
	NSMenuItem* renderModeSmoothMenuItem;
}

@property (nonatomic, retain) NSURL* saveFile;
@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet ZMeshGLViewController *viewController;

@property (nonatomic, retain) IBOutlet NSMenuItem* renderModeBoxMenuItem;
@property (nonatomic, retain) IBOutlet NSMenuItem* renderModePointsMenuItem;
@property (nonatomic, retain) IBOutlet NSMenuItem* renderModeWireMenuItem;
@property (nonatomic, retain) IBOutlet NSMenuItem* renderModeFlatMenuItem;
@property (nonatomic, retain) IBOutlet NSMenuItem* renderModeSmoothMenuItem;

- (IBAction)openFile:(NSMenuItem*)sender;
- (IBAction)saveFile:(NSMenuItem*)sender;
- (IBAction)saveAsFile:(NSMenuItem*)sender;
- (IBAction)renderMode:(NSMenuItem*)sender;

@end
