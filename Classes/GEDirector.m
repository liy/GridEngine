//
//  Director.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEDirector.h"
#import "GEAnimation.h"

@implementation GEDirector

@synthesize renderer;
@synthesize currentScene;
@synthesize delta;
@synthesize rendering;
@synthesize bgColor;

static GEDirector* instance;

+ (GEDirector*)sharedDirector{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [GEDirector alloc];
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
		[[GETexManager sharedTextureManager] init];
		
		//renderer to render the whole sence.
		renderer = [[GERenderer alloc] init];
		
		//sprite batch
		spriteBatch = [[GESpriteBatch sharedSpriteBatch] init];
		
		scenes = [[NSMutableDictionary alloc] initWithCapacity:2];
	}
	return self;
}

- (void)dealloc{
	[mainTimer invalidate];
	[mainTimer release];
	
	[renderer release];
	[currentScene release];
	[scenes release];
	
	[super dealloc];
}

- (void)addScene:(GEScene*)aScene{
	[scenes setObject:aScene forKey:aScene.name];
}

- (GEScene*)removeScene:(NSString*)aSceneName{
	GEScene* scene = [scenes objectForKey:aSceneName];
	[scenes removeObjectForKey:aSceneName];
	return [scene autorelease];
}

- (GEScene*)getScene:(NSString*)aSceneName{
	GEScene* scene = [scenes objectForKey:aSceneName];
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
	//this line of code delay the loop for a little bit ensures the user interaction touch event can be properly handled.
	while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
	
	[self calculateDeltaTime];
	
	//Fire upate method before drawing. Tick method will trigger other selectors you added which will
	//process all the game logic.
	[scheduler tick:delta];
	
	//begin to render and bind frame buffer
	[renderer begin];
	
	//traverse and draw the nodes.
	[currentScene traverse];
	
	//Once finished traversing all the nodes, we need to flush remaining batched node.
	[spriteBatch flush];
	
	//swap frame buffer and display
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

@end
