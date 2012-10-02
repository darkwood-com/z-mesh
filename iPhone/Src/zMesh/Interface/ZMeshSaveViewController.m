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

#import <DropboxSDK/DropboxSDK.h>

#import "ZMeshSaveViewController.h"
#import "ZMeshLocalProtocolViewController.h"

@interface ZMeshSaveViewController () <DBRestClientDelegate>
- (void) saveFile:(NSString*)aFile extension:(NSString*)extension;
- (void) saveFileEnded;
- (DBRestClient *)restClient;
@end

@implementation ZMeshSaveViewController
@synthesize delegate;
@synthesize filePathText;
@synthesize isLocalSave;
@synthesize isDropBoxSave;

- (id)init
{
    self = [super init];
    if (self)
	{
        saveCount = 0;
    }
	
    return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self update];
}

- (void)dealloc
{
	[self setDelegate:nil];
	[self setFilePathText:nil];
	
	[super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
	[aTextField resignFirstResponder];
	
	return YES;
}

- (IBAction) dropboxSave:(id)sender
{
	BOOL isLinked = [[DBSession sharedSession] isLinked];
	
	if(isDropBoxSave.on && !isLinked)
	{
		[[DBSession sharedSession] linkFromController:self];
	}
}

- (void) saveFile:(NSString*)aFile extension:(NSString*)extension
{
	if([aFile isEqualToString:@""]) aFile = @"mesh";
	aFile = [aFile stringByAppendingPathExtension:extension];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error;
	
	NSString* tmpDirectory = NSTemporaryDirectory();
	NSString* tmpPath = [tmpDirectory stringByAppendingPathComponent:aFile];
	[self.delegate saveMeshToPath:tmpPath];
	
	if(isLocalSave.on)
	{
		NSString* localPath = [[ZMeshLocalProtocolViewController directoryPath] stringByAppendingPathComponent:aFile];
		[fileManager copyItemAtPath:tmpPath toPath:localPath error:&error];
	}
	
	BOOL isLinked = [[DBSession sharedSession] isLinked];
	
	if(isDropBoxSave.on && isLinked)
	{
		saveCount++;
		[self.restClient uploadFile:aFile toPath:@"/" withParentRev:nil fromPath:tmpPath];
	}
	
	[self saveFileEnded];
}

- (void) saveFileEnded
{
	if(saveCount == 0) [self dismissModalViewControllerAnimated:YES];
}

- (void) saveOBJ:(id)sender
{
	[self saveFile:self.filePathText.text extension:@"obj"];
}

- (void) saveSTL:(id)sender
{
	[self saveFile:self.filePathText.text extension:@"stl"];
}

- (void) cancel:(id)sender
{
	[self saveFileEnded];
}

- (void) update
{
	BOOL isLinked = [[DBSession sharedSession] isLinked];
	
	isDropBoxSave.on = isLinked;
}

- (DBRestClient *)restClient
{
	if (!restClient)
	{
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
	saveCount--;
	[self saveFileEnded];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
	saveCount--;
	[self saveFileEnded];
}

@end
