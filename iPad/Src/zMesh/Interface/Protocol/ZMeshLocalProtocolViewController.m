/**
 *  ZMeshLocalProtocolViewController.h
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

#import "ZMeshLocalProtocolViewController.h"

#import "ZMeshLocalProtocolCell.h"

@implementation ZMeshLocalProtocolViewController
@synthesize directoryContent;
@synthesize tableView;

- (id) init
{
	self = [super init];
    if (self)
	{
        self.directoryContent = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[ZMeshLocalProtocolViewController directoryPath]
																												   error:nil]];
    }
    return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"protocol.local.title", @"");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																							target:self
																							action:@selector(doEditTable:)] autorelease];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (void) dealloc
{
	[self setDirectoryContent:nil];
	[self setTableView:nil];
	
	[super dealloc];
}

+ (NSString*) directoryPath
{
	NSString* directory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ZMeshFiles"];
	
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:directory];
	if (!exists)
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	return directory;
}

- (NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directoryContent count];
}

- (UITableViewCell*) tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"ZMeshLocalProtocolCell";
    
	ZMeshLocalProtocolCell* cell = (ZMeshLocalProtocolCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ZMeshLocalProtocolCell" owner:nil options:nil];
		for (id nib in nibObjects) {
			if ([nib isKindOfClass:[ZMeshLocalProtocolCell class]]) {
				cell = (ZMeshLocalProtocolCell*)nib;
			}
		}
    }
    
	cell.title.text = [self.directoryContent objectAtIndex:indexPath.row];
	
	NSString* aFilePath = [[ZMeshLocalProtocolViewController directoryPath] stringByAppendingPathComponent:[self.directoryContent objectAtIndex:indexPath.row]];
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
	NSString* aFilePath = [[ZMeshLocalProtocolViewController directoryPath] stringByAppendingPathComponent:[self.directoryContent objectAtIndex:indexPath.row]];
	NSArray* parts = [aFilePath componentsSeparatedByString:@"."];
	NSString* aFileType = [parts objectAtIndex:[parts count]-1];
	
	[self.delegate openMeshType:aFileType andData:[NSData dataWithContentsOfFile:aFilePath]];
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSString* aFilePath = [[ZMeshLocalProtocolViewController directoryPath] stringByAppendingPathComponent:[self.directoryContent objectAtIndex:indexPath.row]];
		[[NSFileManager defaultManager] removeItemAtPath:aFilePath error:nil];
		[self.directoryContent removeObjectAtIndex:indexPath.row];
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

