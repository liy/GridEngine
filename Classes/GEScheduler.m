//
//  GEScheduler.m
//  GridEngine
//
//  Created by Liy on 10-3-3.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEScheduler.h"

@implementation GETimer

@synthesize target;
@synthesize selector;
@synthesize interval;
@synthesize timeScale;

- (id)initTarget:(id)aTarget sel:(SEL)aSel interval:(float)aInterval{
	if (self = [super init]) {
		target = aTarget;
		selector = aSel;
		interval = aInterval;
		
		timeScale = 1.0;
		elapsed = 0.0;
		
		impMethod = (GEIMP)[target methodForSelector:selector];
	}
	return self;
}

- (void)fire:(float)delta{
	elapsed+=delta;
	if (elapsed>=interval) {
		NSLog(@"fire elapsed: %f", elapsed);
		impMethod(target, selector, elapsed);
		elapsed = 0.0;
	}
}

@end


@implementation GEScheduler

static GEScheduler* instance;

+ (GEScheduler*)sharedScheduler{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [GEScheduler alloc];
		}
	}
	
	return instance;
}

- (id)init{
	if (self = [super init]) {
		timers = [[NSMutableArray arrayWithCapacity:10] retain];
		timersDic = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

- (void)addTarget:(id)aTarget sel:(SEL)aSelector interval:(float)aInterval{
	//create timer
	GETimer* timer = [[GETimer alloc] initTarget:aTarget sel:aSelector interval:aInterval];
	//add dictionary.
	NSString* key = NSStringFromSelector(aSelector);
	[timersDic setObject:timer forKey:key];
	
	[timers addObject:timer];
}

- (GETimer*)getTimer:(SEL)aSelector{
	NSString* key = NSStringFromSelector(aSelector);
	return [timersDic objectForKey:key];
}

- (void)remove:(SEL)aSelector{
	NSString* key = NSStringFromSelector(aSelector);
	GETimer* timer = [timersDic objectForKey:key];
	[timers removeObject:timer];
	[timersDic removeObjectForKey:key];
}

- (void)tick:(float)dt{
	for(GETimer* timer in timers){
		if(timer.timeScale != 1.0)
			dt *= timer.timeScale;
		[timer fire:dt];
	}
}

@end
