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

- (id)initWithFile:(NSString*)aName{
	if (self = [super init]) {
		tvcQuad = calloc(1, sizeof(TVCQuad));
		texManager = [TextureManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		//note the float casting.
		texWidthRatio = 1.0f/(float)texRef.pixelsWide;
		texHeightRatio = 1.0f/(float)texRef.pixelsHigh;
		
		[self setSize:CGSizeMake(texRef.contentSize.width, texRef.contentSize.height)];
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
		
		
		//note the float casting.
		texWidthRatio = 1.0f/(float)texRef.pixelsWide;
		texHeightRatio = 1.0f/(float)texRef.pixelsHigh;
		
		[self setRect:aRect];
		[self setSize:CGSizeMake(rect.size.width, rect.size.height)];
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

- (void)setPos:(CGPoint)aPos{
	[super setPos:aPos];
	
	tvcQuad[0].tl.vertices.x = pos.x;
	tvcQuad[0].tl.vertices.y = pos.y + size.height;
	tvcQuad[0].bl.vertices.x = pos.x;
	tvcQuad[0].bl.vertices.y = pos.y;
	tvcQuad[0].tr.vertices.x = pos.x + size.width;
	tvcQuad[0].tr.vertices.y = pos.y + size.height;
	tvcQuad[0].br.vertices.x = pos.x + size.width;
	tvcQuad[0].br.vertices.y = pos.y;
}

- (void)setSize:(CGSize)aSize{
	[super setSize:aSize];
	
	tvcQuad[0].tl.vertices.x = pos.x;
	tvcQuad[0].tl.vertices.y = pos.y + size.height;
	tvcQuad[0].bl.vertices.x = pos.x;
	tvcQuad[0].bl.vertices.y = pos.y;
	tvcQuad[0].tr.vertices.x = pos.x + size.width;
	tvcQuad[0].tr.vertices.y = pos.y + size.height;
	tvcQuad[0].br.vertices.x = pos.x + size.width;
	tvcQuad[0].br.vertices.y = pos.y;
}

- (void)setTintColor:(Color4f)aColor{
	tintColor = aColor;
	
	tvcQuad[0].tl.color = tintColor;
	tvcQuad[0].bl.color = tintColor;
	tvcQuad[0].tr.color = tintColor;
	tvcQuad[0].br.color = tintColor;
}
@end
