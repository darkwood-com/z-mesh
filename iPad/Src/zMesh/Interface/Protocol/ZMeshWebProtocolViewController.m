/**
 *  ZMeshWebProtocolViewController.h
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

#import "ZMeshWebProtocolViewController.h"

@implementation ZMeshWebProtocolViewController
@synthesize request;
@synthesize urlText;
@synthesize webView;

@synthesize backButton;
@synthesize forwardButton;

@synthesize loadLabel;
@synthesize fileProgressIndicator;
@synthesize spinnerIndicator;

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"protocol.web.title", @"");
}

- (void)dealloc
{
	[self setRequest:nil];
	[self setUrlText:nil];
	[self setWebView:nil];
	[self setBackButton:nil];
	[self setForwardButton:nil];
	[self setLoadLabel:nil];
	[self setFileProgressIndicator:nil];
	[self setSpinnerIndicator:nil];
	
	[super dealloc];
}

- (BOOL) startUpload:(NSURL*)anUrl
{
	if([self.delegate canOpenMeshType:[self fileTypeFromURL:anUrl]])
	{
		self.fileProgressIndicator.hidden = NO;
		
		self.request = [ASIFormDataRequest requestWithURL:anUrl];
		[self.request setDidFailSelector:@selector(uploadFailed:)];
		[self.request setDidFinishSelector:@selector(uploadFinished:)];
		[self.request setDownloadProgressDelegate:fileProgressIndicator];
		[self.request setDelegate:self];
		
		[self.request setTimeOutSeconds:120];
		[self.request startAsynchronous];
		
		return YES;
	}
	
	return NO;
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

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
	[aTextField resignFirstResponder];
	
	NSString* url = self.urlText.text;
	if(![url hasPrefix:@"http://"])
	{
		url = [NSString stringWithFormat:@"%@%@", @"http://", url];
	}
	
	NSURLRequest* aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self.webView loadRequest:aRequest];
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)sender
{
	self.loadLabel.hidden = NO;
	self.spinnerIndicator.hidden = NO;
	[self.spinnerIndicator startAnimating];
	
	self.backButton.enabled = webView.canGoBack;
	self.forwardButton.enabled = webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)sender
{
	self.loadLabel.hidden = YES;
	self.spinnerIndicator.hidden = YES;
	[self.spinnerIndicator stopAnimating];
	
	self.backButton.enabled = webView.canGoBack;
	self.forwardButton.enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
	[self webViewDidFinishLoad:aWebView];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType
{
	NSURL* url = [aRequest mainDocumentURL];
	[self.urlText setText:[url absoluteString]];
	
	return ![self startUpload:url];
}

@end

