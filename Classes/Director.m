//
//  Director.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Director.h"
#import "Animation.h"

@implementation Director

@synthesize renderer;
@synthesize currentScene;
@synthesize delta;
@synthesize rendering;

static Director* instance;

+ (Director*)sharedDirector{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [Director alloc];
		}
	}
	
	return instance;
}

- (id)init{
	if (self = [super init]) {
		renderInterval = 1.0/60.0;
		
		delta = 0.0;
		
		//initialize resource manager
		[[TextureManager sharedTextureManager] init];
		
		//renderer to render the whole sence.
		renderer = [[Renderer alloc] init];
		
		scenes = [[NSMutableDictionary alloc] initWithCapacity:2];
	}
	return self;
}

- (void)addScene:(Scene*)aScene{
	[scenes setObject:aScene forKey:aScene.name];
}

- (Scene*)removeScene:(NSString*)aSceneName{
	Scene* scene = [scenes objectForKey:aSceneName];
	[scenes removeObjectForKey:aSceneName];
	return [scene autorelease];
}

- (Scene*)getScene:(NSString*)aSceneName{
	Scene* scene = [scenes objectForKey:aSceneName];
	return scene;
}

- (void)startAnimation{
	lastTime = CFAbsoluteTimeGetCurrent();
	rendering = YES;
	renderTimer = [NSTimer scheduledTimerWithTimeInterval:renderInterval target:self selector:@selector(mainLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation{
	[renderTimer invalidate];
	renderTimer = nil;
	rendering = NO;
}

- (void)pause{
	[self stopAnimation];
}

- (void)resume{
	[self startAnimation];
}

- (void)mainLoop{
	while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
	
	CFTimeInterval now = CFAbsoluteTimeGetCurrent();
	delta = now - lastTime;
	
	//fire update selector
	/*
	 */
	
	[renderer begin];
	[currentScene visit];
	[renderer end];
	
	//update last time
	lastTime = now;
}

- (void)setFrameRate:(uint)frameRate{
	if (rendering) {
		[self pause];
		renderInterval = 1/frameRate;
		[self resume];
	}
	else {
		renderInterval = 1/frameRate;
	}

}

- (void)dealloc{
	[instance release];
	[renderer release];
	[currentScene release];
	[scenes release];
	
	[super dealloc];
}

@end
