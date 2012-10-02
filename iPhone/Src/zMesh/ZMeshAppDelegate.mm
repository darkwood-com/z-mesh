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

#import <DropboxSDK/DropboxSDK.h>

#import "ZMeshAppDelegate.h"
#import "ZMeshGLViewController.h"
#import "ZMeshLocalProtocolViewController.h"
#import "ZMeshDropBoxProtocolViewController.h"
#import "ZMeshDropbBoxConf.h"
#import "ZMeshSaveViewController.h"

@implementation ZMeshRotateViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

@interface ZMeshAppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>
@end

@implementation ZMeshAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc
{
    [self setViewController:nil];
    [self setWindow:nil];
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	DBSession* session = [[DBSession alloc] initWithAppKey:DropbBoxAppKey appSecret:DropbBoxAppSecret root:kDBRootAppFolder];
	session.delegate = self;
	[DBSession setSharedSession:session];
	[session release];
	[DBRequest setNetworkRequestDelegate:self];
	
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if ([[DBSession sharedSession] handleOpenURL:url])
	{
		UIViewController* top = [viewController topViewController];
		if([top isKindOfClass:[ZMeshDropBoxProtocolViewController class]])
		{
			[(ZMeshDropBoxProtocolViewController*)top update];
		}
		
		if([[top modalViewController] isKindOfClass:[ZMeshSaveViewController class]])
		{
			[(ZMeshSaveViewController*)[top modalViewController] update];
		}
		
		return YES;
	}
	
	return NO;
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId
{
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted
{
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped
{
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

@end
