//
//  DirectDraw.m
//  GridEngine
//
//  Created by Liy on 10-3-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "DirectDraw.h"


@implementation DirectDraw

- (id)initWithFile:(NSString *)aName{
	if (self = [super initWithFile:aName]) {
		numOfQuads = 4;
		quads = calloc(numOfQuads, sizeof(TVCQuad));
		
		[self setPos:CGPointMake(0.0f, 0.0f)];
		[self setRect:CGRectMake(0.0f, 0.0f, texRef.contentSize.width, texRef.contentSize.height)];
		[self setTintColor:Color4bMake(255, 255, 255, 255)];
	}
	return self;
}

- (void)setRect:(CGRect)aRect{
	rect = aRect;
	//update the contentSize to the size of the rect.
	contentSize = CGSizeMake(rect.size.width, rect.size.height);
	
	GLfloat texWidth = texWidthRatio*rect.size.width;
	GLfloat texHeight = texHeightRatio*rect.size.height;
	GLfloat offsetX = texWidthRatio*rect.origin.x;
	GLfloat offsetY = texHeightRatio*rect.origin.y;
	
	
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].tl.texCoords.u = offsetX;
		quads[i].tl.texCoords.v = offsetY + texHeight;
		quads[i].bl.texCoords.u = offsetX;
		quads[i].bl.texCoords.v = offsetY;
		quads[i].tr.texCoords.u = offsetX + texWidth;
		quads[i].tr.texCoords.v = offsetY + texHeight;
		quads[i].br.texCoords.u = offsetX + texWidth;
		quads[i].br.texCoords.v = offsetY;
	}
	
}

- (void)setTlColor:(Color4b)aColor{
	blColor = aColor;
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].bl.color = blColor;
	}
}

- (void)setBlColor:(Color4b)aColor{
	tlColor = aColor;
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].tl.color = aColor;
	}
}

- (void)setTrColor:(Color4b)aColor{
	brColor = aColor;
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].br.color = aColor;
	}
}

- (void)setBrColor:(Color4b)aColor{
	trColor = aColor;
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].tr.color = aColor;
	}
}

- (void)updateTVCQuads{
	for (int i=0; i<numOfQuads; ++i) {
		quads[i].tl.vertices.x = 0.0f + i*20.0f;
		quads[i].tl.vertices.y = 0.0f + i*20.0f;
		quads[i].bl.vertices.x = 0.0f + i*20.0f;
		quads[i].bl.vertices.y = 20.0f + i*20.0f;
		quads[i].tr.vertices.x = 20.0f + i*20.0f;
		quads[i].tr.vertices.y = 0.0f + i*20.0f;
		quads[i].br.vertices.x = 20.0f + i*20.0f;
		quads[i].br.vertices.y = 20.0f + i*20.0f;
	}
	
}

- (void)draw{
	[self updateTVCQuads];
	
	//save the current matrix
	glPushMatrix();
	
	//enable to use coords array as a source texture
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	//enable texture 2d
	glEnable(GL_TEXTURE_2D);
	
	//bind the texture.
	//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
	if (texManager.boundedTex != [texRef name]) {
		glBindTexture(GL_TEXTURE_2D, [texRef name]);
		texManager.boundedTex = [texRef name];
	}
	else {
		//NSLog(@"Image already binded");
	}
	
	//get the start memory address for the tvcQuad struct.
	//Note that tvcQuad is defined as array, we need to access the actual tvcQuad memory address using normal square bracket.
	int addr = (int)&quads[0];
	//calculate the memory location offset, should be 0. Since there is nothing before texCoords property of TVCQuad.
	int offset = offsetof(TVCPoint, texCoords);
	//set the texture coordinates we what to render from. (positions on the Texture2D generated image)
	glTexCoordPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr));
	
	//memory offset to define the start of vertices. Should be sizeof(texCoords) which is 8 bytes(2 GLfloat each for 4 bytes).
	offset = offsetof(TVCPoint, vertices);
	//set the target vertices which define the area we what to draw the texture.
	glVertexPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr + offset));
	
	//offset to define the start of color array. Before this property we have texCoords(u & v GLfloat) 
	//and vertices(x & y GLfloat) which are 16 bytes.
	offset = offsetof(TVCPoint, color);
	//set the color tint array for the texture.
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(TVCPoint), (void*)(addr + offset));
	
	//enable blend
	glEnable(GL_BLEND);
	
	//draw the image
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4*numOfQuads);
	
	//disable
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPopMatrix();
}

@end
