/**
 *  ZMeshWebProtocolViewController.m
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

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

#import "ZMeshGenericProtocolViewController.h"

@interface ZMeshWebProtocolViewController : ZMeshGenericProtocolViewController<UIWebViewDelegate,UITextFieldDelegate> {
	ASIFormDataRequest* request;
	
	UITextField* urlText;
	UIWebView* webView;
	
	UIBarButtonItem* backButton;
	UIBarButtonItem* forwardButton;

	UILabel* loadLabel;
	UIProgressView* fileProgressIndicator;
	UIActivityIndicatorView* spinnerIndicator;
}

@property (retain, nonatomic) ASIHTTPRequest* request;

@property (retain, nonatomic) IBOutlet UITextField* urlText;
@property (retain, nonatomic) IBOutlet UIWebView* webView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* backButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* forwardButton;
@property (retain, nonatomic) IBOutlet UILabel* loadLabel;
@property (retain, nonatomic) IBOutlet UIProgressView* fileProgressIndicator;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* spinnerIndicator;

@end
