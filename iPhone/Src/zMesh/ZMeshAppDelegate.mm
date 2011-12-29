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

@implementation ZMeshAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	self.window = [[UIWindow alloc] initWithFrame:screenBounds];
	
	ZMeshGLViewController* rootViewController = [[[ZMeshGLViewController alloc] init] autorelease];
	
	self.viewController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
	[self.viewController setNavigationBarHidden:YES animated:NO];
	[self.viewController setToolbarHidden:NO animated:NO];

	[self.window addSubview:self.viewController.view];
	
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
