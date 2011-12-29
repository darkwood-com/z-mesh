/**
 *  ZMeshHTTPProtocolViewController.h
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

#import "ZMeshHTTPProtocolViewController.h"

@implementation ZMeshHTTPProtocolViewController
@synthesize request;
@synthesize urlText;
@synthesize okButton;
@synthesize fileProgressIndicator;

- (void) viewDidLoad
{
	self.navigationItem.title = NSLocalizedString(@"protocol.http.title", @"");
}

- (void)dealloc
{
	[self setRequest:nil];;
	[self setUrlText:nil];
	[self setOkButton:nil];
	[self setFileProgressIndicator:nil];
	
	[super dealloc];
}

- (void) startUpload:(id)sender
{
	NSURL* url = [NSURL URLWithString:self.urlText.text];
	
	if([self.delegate canOpenMeshType:[self fileTypeFromURL:url]])
	{
		self.request = [ASIFormDataRequest requestWithURL:url];
		[self.request setDidFailSelector:@selector(uploadFailed:)];
		[self.request setDidFinishSelector:@selector(uploadFinished:)];
		[self.request setDownloadProgressDelegate:fileProgressIndicator];
		[self.request setDelegate:self];
		
		[self.request setTimeOutSeconds:120];
		[self.request startAsynchronous];
	}
}

- (void)uploadFinished:(ASIHTTPRequest*)aRequest
{
	NSString* aFileType = [self fileTypeFromURL:[aRequest originalURL]];
	
	[self.delegate openMeshType:aFileType andData:[aRequest responseData]];
}

- (void)uploadFailed:(ASIHTTPRequest*)aRequest
{
	NSLog(@"%@", [[aRequest error] localizedDescription]);
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
	[aTextField resignFirstResponder];
	
	return YES;
}

@end

