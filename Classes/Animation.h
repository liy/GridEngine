//
//  Animation.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graphic.h"
#import "TextureManager.h"

enum {
	ani_forward = 1,
	ani_backword = -1
};

@class Texture2D;

@interface Animation:LeafNode {
	//Specify the area and position to draw from the texture.
	CGRect rect;
	
	Texture2D* texRef;
	
	TextureManager* texManager;
	
	//1 texel will represents how many actual pixels in the picture width. will be 1/textureWidth
	//since texture u & v range from 0-1, so if we draw the texture use u v, we need to
	//translate normal texture size and position into 0-1 range.
	float texWidthRatio;
	//1/textureHeight
	float texHeightRatio;
	
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

@property (nonatomic, assign)CGRect rect;
@property (nonatomic, assign)Texture2D* texRef;
@property (nonatomic)BOOL pingpong;
@property (nonatomic)BOOL repeat;
@property (nonatomic)BOOL running;
@property (nonatomic)int direction;
@property (nonatomic)float defaultDelay;

/**
 * Create a Animation object using the image file name.
 * @param aName The image's file name.
 */
- (id)initWithFile:(NSString*)aName;

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