//
//  GEScheduler.h
//  GridEngine
//
//  Created by Liy on 10-3-3.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (*GEIMP)(id, SEL, float);

@interface GETimer : NSObject
{
	id target;
	SEL selector;
	
	float interval;
	float elapsed;
	float timeScale;
	
	GEIMP impMethod;
}

@property (nonatomic, readonly)id target;
@property (nonatomic, readonly)SEL selector;
@property (nonatomic, readonly)float interval;
@property (nonatomic, readwrite)float timeScale;

- (id)initTarget:(id)aTarget sel:(SEL)aSel interval:(float)aInterval;

- (void)fire:(float)delta;

@end


@interface GEScheduler : NSObject {
	NSMutableArray* timers;
	NSMutableDictionary* timersDic;
}

+ (GEScheduler*)sharedScheduler;

- (void)addTarget:(id)aTarget sel:(SEL)aSelector interval:(float)aInterval;

- (GETimer*)getTimer:(SEL)aSelector;

- (void)remove:(SEL)aSelector;

- (void)tick:(float)delta;

@end
