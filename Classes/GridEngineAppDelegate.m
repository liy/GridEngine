//
//  GridEngineAppDelegate.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright Bangboo 2010. All rights reserved.
//

#import "GridEngineAppDelegate.h"
#import "EAGLView.h"

@implementation GridEngineAppDelegate

@synthesize window;
@synthesize glView;

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	[glView startAnimation];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) dealloc
{
	[window release];
	[glView release];
	
	[super dealloc];
}

@end
