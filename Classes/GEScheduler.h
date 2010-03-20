//  Snipped from cocos2d for iPhone.
//  http://www.cocos2d-iphone.org
//  
//  Made some changes as well.
//  
//  GEScheduler.h
//  GridEngine
//  
//  Created by Liy on 10-3-3.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>

//C type of a method implementation pointer, add an extra delta float param
typedef void (*GE_IMP)(id, SEL, float);

/**
 * A Timer object contains all the stored selectors' information.
 * The scheduler will loop through all the timer to check whether to trigger the selector depends on interval and the elapsed time.
 */
@interface GETimer : NSObject
{
	//Target represents the selector function owner.
	id target;
	//The function to trigger.
	SEL selector;
	//How many seconds to trigger the selector function
	float interval;
	//How many second has past
	float elapsed;
	//timeScale will multiply the delta passed in. If it is less than 1
	//the actual delta time will be reduced so the actual selector trigger interval gets longer. 
	//If it is larger than 1, the selector will be triggered faster
	//We can use this to simulate a slow or fast motion.
	float timeScale;
	
	//A method implementation pointer. Trigger selector call and pass the delta value.
	GE_IMP impMethod;
}

@property (nonatomic, readonly)id target;
@property (nonatomic, readonly)SEL selector;
@property (nonatomic, readwrite)float interval;
@property (nonatomic, readwrite)float timeScale;

/**
 * Create a timer object contains selector information.
 */
- (id)initTarget:(id)aTarget sel:(SEL)aSel interval:(float)aInterval;

/**
 * Check whether to fire the selector. If the elapsed time has exceeded the interval time
 * trigger the selector and pass the elasped time through IMP.
 */
- (void)fire:(float)delta;

@end


/**
 * A scheduler manages all the selectors.
 * Snipped from cocos2d iphone
 */
@interface GEScheduler : NSObject {
	NSMutableArray* timers;
	NSMutableDictionary* timersDic;
}
/**
 * Singleton class.
 */
+ (GEScheduler*)sharedScheduler;

/**
 * Add a selector.
 */
- (void)addTarget:(id)aTarget sel:(SEL)aSelector interval:(float)aInterval;

/**
 * Get the GETimer object for a specific selector. You can then change the interval or timeScale of the GETimer for the selector.
 */
- (GETimer*)getTimer:(SEL)aSelector;

/**
 * Remove the selector from the scheduler.
 */
- (void)remove:(SEL)aSelector;

- (void)tick:(float)delta;

@end
