/**
 *  ZMeshDropBoxProtocolViewController.h
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

#import "ZMeshDropBoxProtocolViewController.h"

#import <DropboxSDK/DropboxSDK.h>
#import "ZMeshDropBoxProtocolCell.h"

@interface ZMeshDropBoxProtocolViewController () <DBRestClientDelegate>
- (DBRestClient *)restClient;
@end

@implementation ZMeshDropBoxProtocolViewController
@synthesize directoryContent;
@synthesize tableView;
@synthesize linkButton;
@synthesize progressView;

- (id) init
{
	self = [super init];
    if (self)
	{
        self.directoryContent = [NSMutableArray array];
    }
	
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"protocol.dropbox.title", @"");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																							target:self
																							action:@selector(doEditTable:)] autorelease];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	[self update];
}

- (void) dealloc
{
	[self setDirectoryContent:nil];
	[self setTableView:nil];
	
	[[self restClient] cancelAllRequests];
	
	[super dealloc];
}

- (NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directoryContent count];
}

- (UITableViewCell*) tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"ZMeshDropBoxProtocolCell";
    
	ZMeshDropBoxProtocolCell* cell = (ZMeshDropBoxProtocolCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ZMeshDropBoxProtocolCell" owner:nil options:nil];
		for (id nib in nibObjects) {
			if ([nib isKindOfClass:[ZMeshDropBoxProtocolCell class]]) {
				cell = (ZMeshDropBoxProtocolCell*)nib;
			}
		}
    }
    
	cell.title.text = [self.directoryContent objectAtIndex:indexPath.row];
	
	NSString* aFilePath = [self.directoryContent objectAtIndex:indexPath.row];
	NSArray* parts = [aFilePath componentsSeparatedByString:@"."];
	NSString* aFileType = [[parts objectAtIndex:[parts count]-1] uppercaseString];
	
	if([aFileType isEqualToString:@"STL"]) {
		cell.picto.image = [UIImage imageNamed:@"stl.png"];
	} else if([aFileType isEqualToString:@"OBJ"]) {
		cell.picto.image = [UIImage imageNamed:@"obj.png"];
	}
	
    return cell;
}

- (void) tableView:(UITableView*)aTableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
	BOOL isLinked = [[DBSession sharedSession] isLinked];
	if(isLinked && [self.restClient requestCount] == 0)
	{
		NSString* aFilePath = [NSString stringWithFormat:@"/%@", [self.directoryContent objectAtIndex:indexPath.row]];
		NSString* tmpDirectory = NSTemporaryDirectory();
		NSString* tmpFile = [tmpDirectory stringByAppendingPathComponent:aFilePath];
		[self.restClient loadFile:aFilePath intoPath:tmpFile];
		
		progressView.hidden = NO;
		progressView.progress = 0.0f;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 38;
}

- (void) doEditTable:(id)sender
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							target:self
																							action:@selector(cancelEditTable:)] autorelease];
	[self.tableView setEditing:YES animated:YES];
}

- (void) cancelEditTable:(id)sender
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																							target:self
																							action:@selector(doEditTable:)] autorelease];
    [self.tableView setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL isLinked = [[DBSession sharedSession] isLinked];
    if (isLinked && editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSString* aFilePath = [NSString stringWithFormat:@"/%@", [self.directoryContent objectAtIndex:indexPath.row]];
		[self.restClient deletePath:aFilePath];
    }
}

- (IBAction)didPressLinkButton;
{
	if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
    } else {
        [[DBSession sharedSession] unlinkAll];
		[self update];
    }
}

- (void) update
{
	BOOL isLinked = [[DBSession sharedSession] isLinked];
	
	self.directoryContent = [NSMutableArray array];
	
	NSString* title = isLinked ? NSLocalizedString(@"protocol.dropbox.logout", @"") : NSLocalizedString(@"protocol.dropbox.login", @"");
    [linkButton setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = isLinked;

	if(isLinked)
	{
		[[self restClient] loadMetadata:@"/"];
	}
	else
	{
		[self.tableView reloadData];
	}
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

#pragma mark -
#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
	if (metadata.isDirectory && [metadata.path isEqualToString:@"/"])
	{
		self.directoryContent = [NSMutableArray array];
		for (DBMetadata* file in metadata.contents)
		{
			if(!file.isDirectory)
			{
				[self.directoryContent addObject:file.filename];
			}
		}
		
		[self.tableView reloadData];
    }
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
{
	NSArray* parts = [localPath componentsSeparatedByString:@"."];
	NSString* aFileType = [parts objectAtIndex:[parts count]-1];
	
	[self.delegate openMeshType:aFileType andData:[NSData dataWithContentsOfFile:localPath]];

	progressView.hidden = YES;
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
	progressView.progress = progress;
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
	progressView.hidden = YES;
}

- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path
{
	[self update];
}

@end

