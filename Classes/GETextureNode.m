//
//  TextureNode.m
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GETextureNode.h"


@implementation GETextureNode

@synthesize rect;
@synthesize texRef;
@synthesize tintColor;
@synthesize tlColor;
@synthesize blColor;
@synthesize trColor;
@synthesize brColor;
@synthesize tvcQuads;
@synthesize numOfQuads;
@synthesize immediateMode;
@synthesize blendFunc;
@synthesize mask;

- (id)initWithFile:(NSString*)aName{
	if (self = [super init]) {
		numOfQuads = 1;
		tvcQuads = calloc(numOfQuads, sizeof(TVCQuad));
		//bzero(&tvcQuad, sizeof(TVCQuad));
		
		immediateMode = YES;
		
		blendFunc.dst = DEFAULT_BLEND_DST;
		blendFunc.src = DEFAULT_BLEND_SRC;
		
		mask = nil;
		
		texManager = [GETexManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		//note the float casting.
		texWidthRatio = 1.0f/(GLfloat)texRef.pixelsWide;
		texHeightRatio = 1.0f/(GLfloat)texRef.pixelsHigh;
		
		[self setPos:CGPointMake(0.0f, 0.0f)];
		[self setRect:CGRectMake(0.0f, 0.0f, texRef.contentSize.width, texRef.contentSize.height)];
		[self setTintColor:Color4bMake(255, 255, 255, 255)];
	}
	return self;
}

- (id)initWithFile:(NSString *)aName rect:(CGRect)aRect{
	if (self = [super init]) {
		numOfQuads = 1;
		tvcQuads = calloc(numOfQuads, sizeof(TVCQuad));
		//bzero(&tvcQuad, sizeof(TVCQuad));
		
		immediateMode = YES;
		
		blendFunc.dst = DEFAULT_BLEND_DST;
		blendFunc.src = DEFAULT_BLEND_SRC;
		
		mask = nil;
		
		texManager = [GETexManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		//note the float casting.
		texWidthRatio = 1.0f/(float)texRef.pixelsWide;
		texHeightRatio = 1.0f/(float)texRef.pixelsHigh;
		
		[self setPos:CGPointMake(0.0f, 0.0f)];
		[self setRect:aRect];
		[self setTintColor:Color4bMake(255, 255, 255, 255)];
	}
	return self;
}

- (void)dealloc{
	free(tvcQuads);
	//free(&tvcQuad);
	[super dealloc];
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | TextureName=%d, Rect = (%.2f,%.2f,%.2f,%.2f)>", [self class], self,
			texRef.name,
			rect.origin.x,
			rect.origin.y,
			rect.size.width,
			rect.size.height];
}

- (void)updateVertices{
	//Every node retains the node's transformation concatenated all its parents' transformations.
	//we can directly use this matrix to transform the vertices.
	CGAffineTransform matrix = parentConcatTransforms;
	
	/*
	 x' = x*a + y*c + tx;
	 y' = x*b + y*d + ty;
	 */
	/*
	float x1 = 0.0;
	float y1 = 0.0;
	
	float x2 = 0.0 + contentSize.width;
	float y2 = 0.0 + contentSize.height;
	 */
	
	float x1 = 0.0f;
	float y1 = 0.0f;
	
	float x2 = self.contentSize.width;
	float y2 = self.contentSize.height;
	
	float a = matrix.a;
	float b = matrix.b;
	float c = matrix.c;
	float d = matrix.d;
	float tx = matrix.tx;
	float ty = matrix.ty;
	
	
	tvcQuads[0].tl.vertices.x = x1*a + y2*c + tx;
	tvcQuads[0].tl.vertices.y = x1*b + y2*d + ty;
	tvcQuads[0].bl.vertices.x = x1*a + y1*c + tx;
	tvcQuads[0].bl.vertices.y = x1*b + y1*d + ty;
	tvcQuads[0].tr.vertices.x = x2*a + y2*c + tx;
	tvcQuads[0].tr.vertices.y = x2*b + y2*d + ty;
	tvcQuads[0].br.vertices.x = x2*a + y1*c + tx;
	tvcQuads[0].br.vertices.y = x2*b + y1*d + ty;
	
	/*
	tvcQuad.tl.vertices.x = x1*a + y2*c + tx;
	tvcQuad.tl.vertices.y = x1*b + y2*d + ty;
	tvcQuad.bl.vertices.x = x1*a + y1*c + tx;
	tvcQuad.bl.vertices.y = x1*b + y1*d + ty;
	tvcQuad.tr.vertices.x = x2*a + y2*c + tx;
	tvcQuad.tr.vertices.y = x2*b + y2*d + ty;
	tvcQuad.br.vertices.x = x2*a + y1*c + tx;
	tvcQuad.br.vertices.y = x2*b + y1*d + ty;
	 */
	
	
}

- (void)traverse{
	//first we need to concatenate parent matrix.
	[self updateVertices];
	//check whether to draw.
	[super traverse];
}

- (BOOL)draw{
	if ([super draw]) {
		//draw mask first if there is mask
		if (mask != nil) {
			//Draw mask first with the correct blend function.
			//Make source image(the mask itself) all zero, that is black and tranparent.
			//The destination image(the pixels under this mask) colour will be multiplied by the source image's corresponding pixel's alpha value. 
			//The area covered by mask's 0 alpha pixels will remains the same(srcA is 0, 1-srcA will be 1); and the area
			//covered by source image's none zero alpha pixels, their RGBA channels will be bring down depends on the source alpha value.
			//The final equation for this blend function is:
			//{0 + dstR*(1-srcA), 0 + dstG*(1-srcA), 0 + dstB*(1-srcB), A*(1-srcA)}
			//1. dst means desination image which is the pixel values under the mask.
			//2. src means source image which is actually the mask's pixel values.
			//3. R,G,B,A are the red, green, blue and alpha channel's values.
			mask.blendFunc = (BlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA};
			//Draw the mask, can not directly call draw. We need to update the transformation as well.
			[mask traverse];
			
			//set this actual texture's blend func, ready to draw the actual texture
			//This blend function's main purpose is retain the source image's pixels above destination transparent pixels(the mask's solid pixels are turned into
			//transparent pixels), if the destination image pixels has solid, none tranparent pixels their colour will be retianed. 
			//The final equation is:
			//{srcR*(1-dstA) + dstR*dstA, srcG*(1-dstA) + dstG*dstA, srcB*(1-dstA) + dstB*dstA, srcA*(1-dstA) + dstA*dstA}
			self.blendFunc = (BlendFunc){GL_ONE_MINUS_DST_ALPHA, GL_DST_ALPHA};
		}
		return YES;
	}
	return NO;
}

- (void)setRect:(CGRect)aRect{
	rect = aRect;
	//update the contentSize to the size of the rect.
	contentSize = CGSizeMake(rect.size.width, rect.size.height);
	
	GLfloat texWidth = texWidthRatio*rect.size.width;
	GLfloat texHeight = texHeightRatio*rect.size.height;
	GLfloat offsetX = texWidthRatio*rect.origin.x;
	GLfloat offsetY = texHeightRatio*rect.origin.y;
	
	
	tvcQuads[0].tl.texCoords.u = offsetX;
	tvcQuads[0].tl.texCoords.v = offsetY + texHeight;
	tvcQuads[0].bl.texCoords.u = offsetX;
	tvcQuads[0].bl.texCoords.v = offsetY;
	tvcQuads[0].tr.texCoords.u = offsetX + texWidth;
	tvcQuads[0].tr.texCoords.v = offsetY + texHeight;
	tvcQuads[0].br.texCoords.u = offsetX + texWidth;
	tvcQuads[0].br.texCoords.v = offsetY;
	
	
	/*
	tvcQuad.tl.texCoords.u = offsetX;
	tvcQuad.tl.texCoords.v = offsetY + texHeight;
	tvcQuad.bl.texCoords.u = offsetX;
	tvcQuad.bl.texCoords.v = offsetY;
	tvcQuad.tr.texCoords.u = offsetX + texWidth;
	tvcQuad.tr.texCoords.v = offsetY + texHeight;
	tvcQuad.br.texCoords.u = offsetX + texWidth;
	tvcQuad.br.texCoords.v = offsetY;
	 */
}

- (void)setTintColor:(Color4b)aColor{
	tintColor = aColor;
	
	self.tlColor = tintColor;
	self.blColor = tintColor;
	self.trColor = tintColor;
	self.brColor = tintColor;
}

/**
 * ============================================================================================================
 * Note that there is upside down flip for the color setting.
 * Not sure why, but if we try to use:
 *		glOrthof(0.0f, screenBounds.size.width, screenBounds.size.height, 0.0f, -1.0f, 1.0f);
 * follow the iPhone screen's coordinate to specify the projection, the texture is ok, but the color position is upside down.
 * Same thing for this and do not flip color position:
 *      glOrthof(0.0f, screenBounds.size.width, 0.0f, screenBounds.size.height, -1.0f, 1.0f);
 * texture will be render upside down.
 * 
 * So we end up must flip either of them, texture or color.
 *
 * ============================================================================================================
 */
- (void)setTlColor:(Color4b)aColor{
	blColor = aColor;
	tvcQuads[0].bl.color = blColor;
	//tvcQuad.bl.color = blColor;
}

- (void)setBlColor:(Color4b)aColor{
	tlColor = aColor;
	tvcQuads[0].tl.color = tlColor;
	//tvcQuad.tl.color = tlColor;
}

- (void)setTrColor:(Color4b)aColor{
	brColor = aColor;
	tvcQuads[0].br.color = brColor;
	//tvcQuad.br.color = brColor;
}

- (void)setBrColor:(Color4b)aColor{
	trColor = aColor;
	tvcQuads[0].tr.color = trColor;
	//tvcQuad.tr.color = trColor;
}
@end
