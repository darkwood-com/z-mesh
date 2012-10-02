/**
 *  ZMeshSaveViewController.m
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

#import "ZMeshCGLDelegate.h"

@class DBRestClient;

@interface ZMeshSaveViewController : UIViewController<UITextFieldDelegate> {
	id<ZMeshCGLDelegate> delegate;
	
	UITextField* filePathText;
	
	DBRestClient* restClient;
	int saveCount; //manage files that are waiting for saving
}

@property (assign, nonatomic) id<ZMeshCGLDelegate> delegate;
@property (assign, nonatomic) IBOutlet UITextField* filePathText;
@property (assign, nonatomic) IBOutlet UISwitch* isLocalSave;
@property (assign, nonatomic) IBOutlet UISwitch* isDropBoxSave;

- (IBAction) dropboxSave:(id)sender;
- (IBAction) saveOBJ:(id)sender;
- (IBAction) saveSTL:(id)sender;
- (IBAction) cancel:(id)sender;
- (void) update;

@end
