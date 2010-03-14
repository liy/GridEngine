//
//  Animation.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GETextureNode.h"

@class GEFrame;

enum {
	//indicate animation is playing forward
	ani_forward = 1,
	//indicate animation is playing backward
	ani_backword = -1
};

/**
 * Animate a sequence of texture or sub-texture(defined by rect property).
 */
@interface GEAnimation:GETextureNode {
	//Contains all the frames
	NSMutableArray* frames;
	//Current frame index.
	uint currentFrameIndex;
	//The frame index which animation starts from. Every time animation start playing, this variable is set to the currentFrameIndex.
	//In the case of that, animation is set to repeat, but not pingpong. Once animation exceeded the frame index bound
	//The currentFrameIndex will be set to the startFrameIndex, so it will goes around. Backward animation will also work.
	//uint startFrameIndex;
	//Is it allowed back and forward animate when animation play to the end of the frames.
	BOOL pingpong;
	//Is it allowed to repeat the animation.
	BOOL repeat;
	//which direction this animation is going.
	int direction;
	//A default seconds of delay for each frame if we do not provide delay when adding frames.
	float defaultDelay;
	//Show how many seconds has past for the current frame. If it has gone past delay time of the current frame
	//we need to jump to next frame.
	float frameTimer;
	//A help variable to decide whether this is the first time animation play to the end of the frames, initial value is always YES. 
	BOOL firstRound;
	//Used internally to indicate is animation updating.
	BOOL stopped;
}

@property (nonatomic)BOOL pingpong;
@property (nonatomic)BOOL repeat;
@property (nonatomic)int direction;
@property (nonatomic)float defaultDelay;
@property (nonatomic, readonly)BOOL stopped;

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

/**
 *
 */
- (void)addFrame:(CGRect)aRect texture:(Texture2D*)tex withDelay:(float)aDelay;

/**
 * Get the Frame specified by frame index. 
 * @return Only return a reference, without increase retain count.
 */
- (GEFrame*)getFrame:(uint)frameIndex;

/**
 * Get displaying frame, without increase retian count.
 */
- (GEFrame*)getCurrentFrame;

/**
 * Stop the animation, and reset it to the initial state. frame index will be reset to 0, frame timer is set to 0 as well.
 */
- (void)reset;

/**
 * Stop the animation, the frame image will still BE RENDERING. The frame timer for current frame will be reset to 0. 
 * So next time resume the animation the current frame will still run for a full time delay. The frame index will NOT be reset to 0 as well.
 */
- (void)stop;

/**
 * Resume the Animation.
 */
- (void)play;

/**
 * Goto and start play from a specific frame. The frame timer will be set to 0. If the index is out of bounds nothing will happen.
 * Note that frame index is 0 based.
 */
- (void)gotoAndPlay:(uint)index;

/**
 * Goto and stop at a specific frame. Note that frame index is 0 based.
 */
- (void)gotoAndStop:(uint)index;

@end