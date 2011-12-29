/**
 *  ZMeshApple.h
 *  zMesh
 *
 *  Created by Mathieu LEDRU on 28/03/10.
 *
 *  GPL License:
 *  Copyright (c) 2009, Mathieu LEDRU
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

#if defined(D_MAC)

#import <Cocoa/Cocoa.h>

#define ZMeshApplication NSApplication
#define ZMeshApplicationDelegate NSApplicationDelegate
#define ZMeshNotification NSNotification
#define ZMeshWindow NSWindow
#define ZMeshView NSView
#define ZMeshControl NSControl
#define ZMeshViewController NSViewController
#define ZMeshImageView NSImageView
#define ZMeshRect NSRect
#define ZMeshMakeRect NSMakeRect
#define ZMeshPoint NSPoint
#define ZMeshMakePoint NSMakePoint
#define ZMeshSize NSSize

#endif

#if defined(D_IPHONE) || defined(D_IPAD)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ZMeshApplication UIApplication
#define ZMeshApplicationDelegate UIApplicationDelegate
#define ZMeshNotification UINotification
#define ZMeshWindow UIWindow
#define ZMeshView UIView
#define ZMeshControl UIControl
#define ZMeshViewController UIViewController
#define ZMeshImageView UIImageView
#define ZMeshRect CGRect
#define ZMeshMakeRect CGRectMake
#define ZMeshPoint CGPoint
#define ZMeshMakePoint CGPointMake
#define ZMeshSize CGSize

#endif

#define ZMeshFloat CGFloat
#define ZMeshString NSString
#define ZMeshMutableArray NSMutableArray
#define ZMeshValue NSValue
#define ZMeshData NSData
