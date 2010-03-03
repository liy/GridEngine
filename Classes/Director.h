//
//  Director.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"
#import "GEScheduler.h"

@interface Director : NSObject {
	//contains all scenes
	NSMutableDictionary* scenes;
	
	//renderer
	Renderer* renderer;
	
	//scene currently being rendered
	Scene* currentScene;
	
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
}

@property (nonatomic, readonly)Renderer* renderer;
@property (nonatomic, assign)Scene* currentScene;
@property (nonatomic, readonly)float delta;
@property (nonatomic, readonly)BOOL rendering;


+ (Director*)sharedDirector;

- (void)addScene:(Scene*)aScene;

- (Scene*)removeScene:(NSString*)aSceneName;

- (Scene*)getScene:(NSString*)aSceneName;

- (void)startAnimation;

- (void)stopAnimation;

- (void)pause;

- (void)resume;

- (void)mainLoop;

- (void)setFrameRate:(uint)frameRate;

@end
