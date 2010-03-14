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

- (id)initWithFile:(NSString*)aName{
	if (self = [super init]) {
		tvcQuad = calloc(1, sizeof(TVCQuad));
		
		//int numOfQuads = sizeof(*tvcQuad)/sizeof(TVCQuad);
		//NSLog(@"numOfQuads: %i", numOfQuads);
		
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
		tvcQuad = calloc(1, sizeof(TVCQuad));
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
	
	tvcQuad[0].tl.vertices.x = x1*a + y2*c + tx;
	tvcQuad[0].tl.vertices.y = x1*b + y2*d + ty;
	tvcQuad[0].bl.vertices.x = x1*a + y1*c + tx;
	tvcQuad[0].bl.vertices.y = x1*b + y1*d + ty;
	tvcQuad[0].tr.vertices.x = x2*a + y2*c + tx;
	tvcQuad[0].tr.vertices.y = x2*b + y2*d + ty;
	tvcQuad[0].br.vertices.x = x2*a + y1*c + tx;
	tvcQuad[0].br.vertices.y = x2*b + y1*d + ty;
	
	
}

- (void)traverse{
	//first we need to concatenate parent matrix.
	[self updateVertices];
	//check whether to draw.
	[super traverse];
}


- (void)setRect:(CGRect)aRect{
	rect = aRect;
	//update the contentSize to the size of the rect.
	contentSize = CGSizeMake(rect.size.width, rect.size.height);
	
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
	tvcQuad[0].bl.color = blColor;
}

- (void)setBlColor:(Color4b)aColor{
	tlColor = aColor;
	tvcQuad[0].tl.color = tlColor;
}

- (void)setTrColor:(Color4b)aColor{
	brColor = aColor;
	tvcQuad[0].br.color = brColor;
}

- (void)setBrColor:(Color4b)aColor{
	trColor = aColor;
	tvcQuad[0].tr.color = trColor;
}
@end
