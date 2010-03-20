//
//  ColorNode.h
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "GENode.h"
#import "geTypes.h"

/**
 * Color node purely having a color filling
 */
@interface GEColorNode : GENode {
	//Define an array of VCQuad contains vertices, color information
	TVCQuad* tvcQuads;
	
	//top-left
	Color4b tlColor;
	//bottom-left
	Color4b blColor;
	//top-right
	Color4b trColor;
	//bottom-right
	Color4b brColor;
}

//apply tint color.
@property (nonatomic, assign)Color4b tlColor;
@property (nonatomic, assign)Color4b blColor;
@property (nonatomic, assign)Color4b trColor;
@property (nonatomic, assign)Color4b brColor;

@end
