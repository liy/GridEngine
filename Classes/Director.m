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
@synthesize bgColor;

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
		//The default background colour will be black.
		bgColor = Color4bMake(0, 0, 0, 255);
		
		scheduler = [[GEScheduler sharedScheduler] init];
		
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
	mainTimer = [NSTimer scheduledTimerWithTimeInterval:renderInterval target:self selector:@selector(mainLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation{
	[mainTimer invalidate];
	mainTimer = nil;
	rendering = NO;
}

- (void)pause{
	[self stopAnimation];
}

- (void)resume{
	[self startAnimation];
}

- (void)calculateDeltaTime{
	CFTimeInterval now = CFAbsoluteTimeGetCurrent();
	delta = now - lastTime;
	//update last time
	lastTime = now;
}

- (void)mainLoop{
	while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
	
	[self calculateDeltaTime];
	
	//Fire upate method before drawing.
	[scheduler tick:delta];
	
	
	[renderer begin];
	[currentScene traverse];
	[renderer end];
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

- (void)setBgColor:(Color4b)aColor{
	bgColor = aColor;
	renderer.clearColor = Color4fMake((GLfloat)bgColor.r/255.0f, (GLfloat)bgColor.g/255.0f, (GLfloat)bgColor.b/255.0f, (GLfloat)bgColor.a/255.0f);
}

- (void)dealloc{
	[instance release];
	[renderer release];
	[currentScene release];
	[scenes release];
	
	[super dealloc];
}

@end
