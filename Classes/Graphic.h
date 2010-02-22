//
//  Graphic.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafNode.h"
#import "TextureManager.h"
#import "Common.h"

@class Texture2D;

/**
 * Graphic represents a pure image, without any frames or children.
 */
@interface Graphic : LeafNode {
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
}

//Specify the area and position to draw from the texture.
@property (nonatomic, assign)CGRect rect;
//can manually change texture. But remember to update the rect as well.
@property (nonatomic, assign)Texture2D* texRef;

/**
 * Create a Graphic object using the image file name.
 * @param aName The image's file name.
 */
- (id)initWithFile:(NSString*)aName;

/**
 * Create a Graphic object using the image file name. Rectangle defines the area and postion
 * to draw from the texture.
 * @param aName The image's file name.
 * @param aRect Specify the area and position to draw from the texture.
 */
- (id)initWithFile:(NSString *)aName rect:(CGRect)aRect;

@end
