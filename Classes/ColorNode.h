//
//  ColorNode.h
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "LeafNode.h"
#import "Common.h"

@interface ColorNode : LeafNode {
	//Define an array of VCQuad contains vertices, color information
	VCQuad* vcQuad;
	
	//top-left
	Color4f tlColor;
	//bottom-left
	Color4f rlColor;
	//top-right
	Color4f trColor;
	//bottom-right
	Color4f brColor;
}

//apply tint color.
@property (nonatomic, assign)Color4f tlColor;
@property (nonatomic, assign)Color4f rlColor;
@property (nonatomic, assign)Color4f trColor;
@property (nonatomic, assign)Color4f brColor;

@end
