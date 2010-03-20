//
//  TextureNode.h
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GETexManager.h"
#import "GENode.h"
#import "geTypes.h"

@interface GETextureNode : GENode {
	//Specify the area and position to draw from the texture.
	CGRect rect;
	
	GETexManager* texManager;
	
	Texture2D* texRef;
	
	//Define an array of TVCQuad contains texture, vertices, color information
	TVCQuad* tvcQuads;
	int numOfQuads;
	//TVCQuad tvcQuad;
	
	//1 texel will represents how many actual pixels in the picture width. will be 1/textureWidth
	//since texture u & v range from 0-1, so if we draw the texture use u v, we need to
	//translate normal texture size and position into 0-1 range.
	float texWidthRatio;
	//1/textureHeight
	float texHeightRatio;
	
	//rgba, simple property to set a solid color for all 4 points in the quad.
	//If you want a gradient color tint, you can specify the color individually for the 4 points.
	Color4b tintColor;
	
	//top-left
	Color4b tlColor;
	//bottom-left
	Color4b blColor;
	//top-right
	Color4b trColor;
	//bottom-right
	Color4b brColor;
	
	BOOL immediateMode;
	
	BlendFunc blendFunc;
}

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

//apply tint color for individual vertices.
@property (nonatomic, assign)Color4b tlColor;
@property (nonatomic, assign)Color4b blColor;
@property (nonatomic, assign)Color4b trColor;
@property (nonatomic, assign)Color4b brColor;
//Apply tint color.
@property (nonatomic, assign)Color4b tintColor;
//Specify the area and position to draw from the texture.
@property (nonatomic, assign)CGRect rect;
//can manually change texture. But remember to update the rect as well.
@property (nonatomic, assign)Texture2D* texRef;

@property (nonatomic, readonly)int numOfQuads;
@property (nonatomic, readonly)TVCQuad* tvcQuads;
//@property (nonatomic, readonly)TVCQuad tvcQuad;

@property (nonatomic, assign)BOOL immediateMode;
@property (nonatomic, assign, readwrite)BlendFunc blendFunc;

@end
