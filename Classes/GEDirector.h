//
//  Director.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GERenderer.h"
#import "GEScheduler.h"
#import "GECommon.h"

@interface GEDirector : NSObject {
	//contains all scenes
	NSMutableDictionary* scenes;
	
	//renderer
	GERenderer* renderer;
	
	//scene currently being rendered
	GEScene* currentScene;
	
	//store the last time finished drawing the screen.
	CFTimeInterval lastTime;
	
	//main rendering and other selector triger timer
	NSTimer* mainTimer;
	
	//one frame for how many second.
	NSTimeInterval renderInterval;
	
	//is it rendering?
	BOOL rendering;
	
	//delta time which means how many second has past since last screen draw.
	float delta;
	
	//Manage all the selectors ready to trigger
	GEScheduler* scheduler;
	
	Color4b bgColor;
}

@property (nonatomic, readonly)GERenderer* renderer;
@property (nonatomic, assign)GEScene* currentScene;
@property (nonatomic, readonly)float delta;
@property (nonatomic, readonly)BOOL rendering;
@property (nonatomic, assign)Color4b bgColor;


+ (GEDirector*)sharedDirector;

- (void)addScene:(GEScene*)aScene;

- (GEScene*)removeScene:(NSString*)aSceneName;

- (GEScene*)getScene:(NSString*)aSceneName;

- (void)startAnimation;

- (void)stopAnimation;

- (void)pause;

- (void)resume;

- (void)mainLoop;

- (void)setFrameRate:(uint)frameRate;

@end
