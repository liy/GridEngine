//
//  Animation.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextureNode.h"

enum {
	ani_forward = 1,
	ani_backword = -1
};

@interface Animation:TextureNode {
	NSMutableArray* frames;
	
	uint currentFrameIndex;
	
	BOOL pingpong;
	
	BOOL repeat;
	
	BOOL running;
	
	int direction;
	
	float defaultDelay;
	
	float frameTimer;
	
	BOOL firstRound;
}


@property (nonatomic)BOOL pingpong;
@property (nonatomic)BOOL repeat;
@property (nonatomic)BOOL running;
@property (nonatomic)int direction;
@property (nonatomic)float defaultDelay;

/**
 * Use default texture with default duration
 *
 */
- (void)addFrame:(CGRect)aRect;

/**
 * Use default duration
 *
 */
- (void)addFrame:(CGRect)aRect named:(NSString*)aName;

/**
 * Use default Texture2D(the Texture2D when initialize this Animation object) for this frame.
 * @param aRect The area of Texture2D to draw.
 * @param aDelay how long this frame will last.
 */
- (void)addFrame:(CGRect)aRect withDelay:(float)aDelay;

/**
 * Use specific Texture2D(the Texture2D when initialize this Animation object) for this frame.
 * @param aRect The area of Texture2D to draw.
 * @param aName The image name.
 * @param aDelay how long this frame will last.
 */
- (void)addFrame:(CGRect)aRect named:(NSString*)aName withDelay:(float)aDelay;

@end