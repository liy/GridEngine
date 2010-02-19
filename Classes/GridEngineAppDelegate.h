//
//  GridEngineAppDelegate.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright Bangboo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface GridEngineAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

