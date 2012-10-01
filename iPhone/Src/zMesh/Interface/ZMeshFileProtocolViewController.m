/**
 *  ZMeshFileProtocolViewController.h
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

#import "ZMeshFileProtocolViewController.h"

#import "ZMeshHTTPProtocolViewController.h"
#import "ZMeshWebProtocolViewController.h"
#import "ZMeshLocalProtocolViewController.h"
#import "ZMeshDropBoxProtocolViewController.h"
#import "ZMeshFileProtocolCell.h"

@implementation ZMeshFileProtocolViewController
@synthesize delegate;
@synthesize tableView;

- (void) viewDidLoad
{
	self.navigationItem.title = NSLocalizedString(@"protocol.file.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
	[self setTableView:nil];
	[self setDelegate:nil];
	
	[super dealloc];
}

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell*) tableView:(UITableView*) aTableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	static NSString* MyIdentifier = @"ZMeshFileProtocolCell";
    ZMeshFileProtocolCell* cell = (ZMeshFileProtocolCell*) [aTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ZMeshFileProtocolCell" owner:nil options:nil];
		for (id nib in nibObjects) {
			if ([nib isKindOfClass:[ZMeshFileProtocolCell class]]) {
				cell = (ZMeshFileProtocolCell*)nib;
			}
		}
    }
	
	switch ([indexPath row])
	{
		case 0:
			cell.title.text = NSLocalizedString(@"protocol.local.title", @"");
			cell.subtitle.text = NSLocalizedString(@"protocol.local.subtitle", @"");
			cell.picto.image = [UIImage imageNamed:@"folder.png"];
		break;
		case 1:
			cell.title.text = NSLocalizedString(@"protocol.http.title", @"");
			cell.subtitle.text = NSLocalizedString(@"protocol.http.subtitle", @"");
			cell.picto.image = [UIImage imageNamed:@"http.png"];
		break;
		case 2:
			cell.title.text = NSLocalizedString(@"protocol.web.title", @"");
			cell.subtitle.text = NSLocalizedString(@"protocol.web.subtitle", @"");
			cell.picto.image = [UIImage imageNamed:@"web.png"];
		break;
		case 3:
			cell.title.text = NSLocalizedString(@"protocol.dropbox.title", @"");
			cell.subtitle.text = NSLocalizedString(@"protocol.dropbox.subtitle", @"");
			cell.picto.image = [UIImage imageNamed:@"dropbox.png"];
		break;
		case 4:
			cell.title.text = NSLocalizedString(@"protocol.ftp.title", @"");
			cell.subtitle.text = NSLocalizedString(@"protocol.ftp.subtitle", @"");
		break;
	}
    
	return cell;
}

- (void) tableView:(UITableView*) aTableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ZMeshGenericProtocolViewController* protocolController = nil;
	
	switch ([indexPath row])
	{
		case 0: protocolController = [[[ZMeshLocalProtocolViewController alloc] init] autorelease]; break;
		case 1: protocolController = [[[ZMeshHTTPProtocolViewController alloc] init] autorelease]; break;
		case 2: protocolController = [[[ZMeshWebProtocolViewController alloc] init] autorelease]; break;
		case 3: protocolController = [[[ZMeshDropBoxProtocolViewController alloc] init] autorelease]; break;
		case 4: break;
	}
	
	protocolController.delegate = self.delegate;
	
	[self.navigationController pushViewController:protocolController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 76;
}

@end

