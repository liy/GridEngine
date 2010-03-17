//
//  SpriteBatch.m
//  GridEngine
//
//  Created by Liy on 10-3-15.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GESpriteBatch.h"


@implementation GESpriteBatch

@synthesize numOfQuads;

static GESpriteBatch* instance;

+ (GESpriteBatch*)sharedSpriteBatch{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [GESpriteBatch alloc];
		}
	}
	
	return instance;
}

- (id)init{
	if (self = [super init]) {
		tvcQuads = calloc(MAX_NUM_QUADS, sizeof(TVCQuad));
		indices = calloc(MAX_NUM_QUADS*6, sizeof(GLubyte));
		texManager = [GETexManager sharedTextureManager];
		numOfQuads = 0;
	}
	return self;
}

- (void)batchNode:(GETextureNode*)aTexNode {
	
	//If this is not the start of the 
	if (texManager.boundedTex != aTexNode.texRef.name) {
		[self flush];
		texManager.boundedTex = aTexNode.texRef.name;
	}
	
	//update indices
	indices[numOfQuads*6+0] = numOfQuads*4+0;
	indices[numOfQuads*6+1] = numOfQuads*4+1;
	indices[numOfQuads*6+2] = numOfQuads*4+2;
	indices[numOfQuads*6+3] = numOfQuads*4+1;
	indices[numOfQuads*6+4] = numOfQuads*4+2;
	indices[numOfQuads*6+5] = numOfQuads*4+3;

	tvcQuads[numOfQuads] = aTexNode.tvcQuad;
	++numOfQuads;
}

- (void)flush{
	NSLog(@"numOfQuads: %i", numOfQuads);
	
	glPushMatrix();
	
	//enable to use coords array as a source texture
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	//enable texture 2d
	glEnable(GL_TEXTURE_2D);
	
	//bind the texture.
	//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
	glBindTexture(GL_TEXTURE_2D, texManager.boundedTex);
	
	//get the start memory address for the tvcQuad struct.
	//Note that tvcQuad is defined as array, we need to access the actual tvcQuad memory address using normal square bracket.
	int addr = (int)&tvcQuads[0];
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
	//glDrawArrays(GL_TRIANGLE_STRIP, 0, numOfQuads*4);
	glDrawElements(GL_TRIANGLES, numOfQuads*6, GL_UNSIGNED_BYTE, indices);
	
	
	//disable
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPopMatrix();
	
	//reset numer of quads to 0, clear memory
	numOfQuads = 0;
	bzero(tvcQuads, sizeof(TVCQuad)*MAX_NUM_QUADS);
	bzero(indices, sizeof(GLubyte)*MAX_NUM_QUADS);
}

@end
