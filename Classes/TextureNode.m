//
//  TextureNode.m
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "TextureNode.h"


@implementation TextureNode

@synthesize rect;
@synthesize texRef;
@synthesize tintColor;
@synthesize tlColor;
@synthesize blColor;
@synthesize trColor;
@synthesize brColor;

- (id)initWithFile:(NSString*)aName{
	if (self = [super init]) {
		tvcQuad = calloc(1, sizeof(TVCQuad));
		texManager = [TextureManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		//update contentSize
		contentSize = CGSizeMake(texRef.contentSize.width, texRef.contentSize.height);
		
		//note the float casting.
		texWidthRatio = 1.0f/(GLfloat)texRef.pixelsWide;
		texHeightRatio = 1.0f/(GLfloat)texRef.pixelsHigh;
		
		[self setPos:CGPointMake(0.0f, 0.0f)];
		[self setRect:CGRectMake(0.0f, 0.0f, texRef.contentSize.width, texRef.contentSize.height)];
		[self setTintColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)];
	}
	return self;
}

- (id)initWithFile:(NSString *)aName rect:(CGRect)aRect{
	if (self = [super init]) {
		tvcQuad = calloc(1, sizeof(TVCQuad));
		texManager = [TextureManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		//update contentSize
		contentSize = CGSizeMake(rect.size.width, rect.size.height);
		
		//note the float casting.
		texWidthRatio = 1.0f/(float)texRef.pixelsWide;
		texHeightRatio = 1.0f/(float)texRef.pixelsHigh;
		
		[self setPos:CGPointMake(0.0f, 0.0f)];
		[self setRect:aRect];
		[self setTintColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)];
	}
	return self;
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
	//====================================================== method 1 recursive call
	//concat all its parents' transformation matrix
	CGAffineTransform matrix = [self concatParentTransformations];
	
	
	//======================================================method 2 parentConcatTransform, updated every display tree change and transformation change
	//CGAffineTransform matrix = parentConcatTransforms;
	
	/*
	 x' = x*a + y*c + tx;
	 y' = x*b + y*d + ty;
	 */
	/*
	float x1 = -anchor.x;
	float y1 = -anchor.y;
	
	float x2 = -anchor.x + contentSize.width;
	float y2 = -anchor.y + contentSize.height;
	 */
	
	float x1 = 0.0f;
	float y1 = 0.0f;
	
	float x2 = self.contentSize.width;
	float y2 = self.contentSize.height;
	
	tvcQuad[0].tl.vertices.x = x1*matrix.a + y2*matrix.c + matrix.tx;
	tvcQuad[0].tl.vertices.y = x1*matrix.b + y2*matrix.d + matrix.ty;
	tvcQuad[0].bl.vertices.x = x1*matrix.a + y1*matrix.c + matrix.tx;
	tvcQuad[0].bl.vertices.y = x1*matrix.b + y1*matrix.d + matrix.ty;
	tvcQuad[0].tr.vertices.x = x2*matrix.a + y2*matrix.c + matrix.tx;
	tvcQuad[0].tr.vertices.y = x2*matrix.b + y2*matrix.d + matrix.ty;
	tvcQuad[0].br.vertices.x = x2*matrix.a + y1*matrix.c + matrix.tx;
	tvcQuad[0].br.vertices.y = x2*matrix.b + y1*matrix.d + matrix.ty;
}

- (void)visit{
	//first we need to concatenate parent matrix.
	[self updateVertices];
	[super visit];
}


- (void)setRect:(CGRect)aRect{
	rect = aRect;
	
	GLfloat texWidth = texWidthRatio*rect.size.width;
	GLfloat texHeight = texHeightRatio*rect.size.height;
	GLfloat offsetX = texWidthRatio*rect.origin.x;
	GLfloat offsetY = texHeightRatio*rect.origin.y;
	
	
	tvcQuad[0].tl.texCoords.u = offsetX;
	tvcQuad[0].tl.texCoords.v = offsetY + texHeight;
	tvcQuad[0].bl.texCoords.u = offsetX;
	tvcQuad[0].bl.texCoords.v = offsetY;
	tvcQuad[0].tr.texCoords.u = offsetX + texWidth;
	tvcQuad[0].tr.texCoords.v = offsetY + texHeight;
	tvcQuad[0].br.texCoords.u = offsetX + texWidth;
	tvcQuad[0].br.texCoords.v = offsetY;
}

- (void)setTintColor:(Color4f)aColor{
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
- (void)setTlColor:(Color4f)aColor{
	blColor = aColor;
	tvcQuad[0].bl.color = blColor;
}

- (void)setBlColor:(Color4f)aColor{
	tlColor = aColor;
	tvcQuad[0].tl.color = aColor;
}

- (void)setTrColor:(Color4f)aColor{
	brColor = aColor;
	tvcQuad[0].br.color = aColor;
}

- (void)setBrColor:(Color4f)aColor{
	trColor = aColor;
	tvcQuad[0].tr.color = aColor;
}
@end
