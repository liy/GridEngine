//
//  Animation.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionNode.h"
#import "TextureManager.h"

@class Texture2D;

@interface Animation : CollectionNode {
	Texture2D* texRef;
	TextureManager* texManager;
	NSMutableArray* frames;
}

@property (nonatomic, assign)Texture2D* texRef;

/**
 * Create a Animation object using the image file name.
 * @param aName The image's file name.
 */
- (id)initWithName:(NSString*)aName;

/**
 * Use default Texture2D(the Texture2D when initialize this Animation object) for this frame.
 * @param aRect The area of Texture2D to draw.
 * @param duration how long this frame will last.
 */
- (void)addFrame:(CGRect)aRect withDuration:(float)duration;

/**
 * Use specific Texture2D(the Texture2D when initialize this Animation object) for this frame.
 * @param aRect The area of Texture2D to draw.
 * @param aName The image name.
 * @param duration how long this frame will last.
 */
- (void)addFrame:(CGRect)aRect named:(NSString*)aName withDuration:(float)duration;

@end