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
#import "ZMeshGLViewController.h"
#import "ZMeshLocalProtocolViewController.h"

@implementation ZMeshRotateViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

@implementation ZMeshAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	//copy sample files at first app launch
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	int launchCount = [defaults integerForKey:@"launchCount" ] + 1;
	[defaults setInteger:launchCount forKey:@"launchCount"];
	[defaults synchronize];
	
	if(launchCount == 1 || true)
	{
		NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error;
        NSString* documentFolderPath = [ZMeshLocalProtocolViewController directoryPath];
        NSString* resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Models"];
		
		NSArray* files = [fileManager contentsOfDirectoryAtPath:resourceFolderPath error:nil];
		for (NSString* file in files) {
			NSString* fileFrom = [resourceFolderPath stringByAppendingPathComponent:file];
			NSString* fileTo = [documentFolderPath stringByAppendingPathComponent:file];
			
			[fileManager copyItemAtPath:fileFrom toPath:fileTo error:&error];
		}
	}
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	self.window = [[UIWindow alloc] initWithFrame:screenBounds];
	
	UIViewController* rootViewController = [[[ZMeshGLViewController alloc] init] autorelease];
	self.viewController = [[[ZMeshRotateViewController alloc] initWithRootViewController:rootViewController] autorelease];
	[self.viewController setNavigationBarHidden:YES animated:NO];
	[self.viewController setToolbarHidden:NO animated:NO];

	self.window.rootViewController = self.viewController;
	
	[self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //[self.meshViewController stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[self.meshViewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[self.meshViewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [self setViewController:nil];
    [self setWindow:nil];
    
    [super dealloc];
}

@end
