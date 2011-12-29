/**
 *  ZMeshAppDelegate.mm
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

#import "ZMeshAppDelegate.h"

@implementation ZMeshAppDelegate
@synthesize saveFile;
@synthesize window;
@synthesize viewController;
@synthesize renderModeBoxMenuItem;
@synthesize renderModePointsMenuItem;
@synthesize renderModeWireMenuItem;
@synthesize renderModeFlatMenuItem;
@synthesize renderModeSmoothMenuItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.viewController = [[[ZMeshGLViewController alloc] init] autorelease];
	[self.window setContentView:self.viewController.view];
	
	[viewController startAnimation];
}

- (IBAction)openFile:(NSMenuItem*)sender
{
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	
	[openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"stl", @"obj", nil]];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setAllowsMultipleSelection:NO];
	
	if ([openPanel runModal] == NSOKButton)
	{
		NSURL* aFilePath = nil;
		NSArray* files = [openPanel URLs];
		for(int i = 0; i < [files count]; i++ )
		{
			aFilePath = [files objectAtIndex:i];
		}
		
		if(aFilePath)
		{
			NSArray* parts = [[aFilePath path] componentsSeparatedByString:@"."];
			NSString* aFileType = [parts objectAtIndex:[parts count]-1];
			
			[viewController openMeshType:aFileType andData:[NSData dataWithContentsOfURL:aFilePath]];
		}
	}
}

- (void)saveFile:(NSMenuItem*)sender
{
    if (self.saveFile == NULL)
    {
        [self saveAsFile:sender];
        return;
    }
	
	[viewController saveMeshToPath:[self.saveFile path]];
}

- (void)saveAsFile:(NSMenuItem*)sender
{
	NSSavePanel* savePanel = [NSSavePanel savePanel];
	
	[savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"stl", @"obj", nil]];
	if([savePanel runModal] == NSOKButton)
	{
		self.saveFile = [savePanel URL];
		if (self.saveFile == NULL) return;
		
		[self saveFile:sender];
	}
}

- (IBAction)renderMode:(NSMenuItem*)sender
{
	[renderModeBoxMenuItem setState:NSOffState];
	[renderModePointsMenuItem setState:NSOffState];
	[renderModeWireMenuItem setState:NSOffState];
	[renderModeFlatMenuItem setState:NSOffState];
	[renderModeSmoothMenuItem setState:NSOffState];
	
	if(sender == renderModeBoxMenuItem) {
		[viewController renderMeshMode:@"Box"];
		[renderModeBoxMenuItem setState:NSOnState];
	} else if(sender == renderModePointsMenuItem) {
		[viewController renderMeshMode:@"Points"];
		[renderModePointsMenuItem setState:NSOnState];
	} else if(sender == renderModeWireMenuItem) {
		[viewController renderMeshMode:@"Wire"];
		[renderModeWireMenuItem setState:NSOnState];
	} else if(sender == renderModeFlatMenuItem) {
		[viewController renderMeshMode:@"Flat"];
		[renderModeFlatMenuItem setState:NSOnState];
	} else if(sender == renderModeSmoothMenuItem) {
		[viewController renderMeshMode:@"Smooth"];
		[renderModeSmoothMenuItem setState:NSOnState];
	}
}

- (void)dealloc
{
	[self setSaveFile:nil];
    [self setWindow:nil];
	[self setViewController:nil];
	[self setRenderModeBoxMenuItem:nil];
	[self setRenderModePointsMenuItem:nil];
	[self setRenderModeWireMenuItem:nil];
	[self setRenderModeFlatMenuItem:nil];
	[self setRenderModeSmoothMenuItem:nil];
    
    [super dealloc];
}

@end
