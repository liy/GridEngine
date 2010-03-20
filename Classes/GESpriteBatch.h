//
//  SpriteBatch.h
//  GridEngine
//
//  Created by Liy on 10-3-15.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GENode.h"
#import "GECommon.h"
#import "GEConfig.h"
#import "GETexManager.h"
#import "GETextureNode.h"

@interface GESpriteBatch : GENode {
	//All the quad vertices, color and texture coords information is stored here.
	TVCQuad* batchedQuads;
	//number of quads batched by now.
	uint numOfQuads;
	
	//The texture manager manages the textures. We need to check the currently bounded texture.
	//If the node which wants to be batched has a different texture from the currently bounded texture.
	//We must flush the current batched all the tvcQuads arrays to the graphic card to draw it.
	GETexManager* texManager;
	
	//This is a indices array used by glDrawElements telling graphic card how to draw the geometry.
	GLubyte* indices;
	
	BlendFunc blendFunc;
}

@property (nonatomic, readonly)uint numOfQuads;

/**
 * Get the shared GESpriteBatch. The instance should be already initialized when GEDirector is created.
 *
 */
+ (GESpriteBatch*)sharedSpriteBatch;

/**
 * Batch the node's texture, color and vertices information.
 */
- (void)batchNode:(GETextureNode*)aTexNode;

/**
 * Send all the batched texture, color and vertices information to graphic card to render.
 * It also reset the GESpriteBatch state once it finished drawing, and get ready to accept next node batch.
 * Note: It might has nothing to flush(when the display tree reached the end, but no batched nodes at all). So an extra
 * check it placed in this method to make sure numOfQuads is not 0, if it is 0 simply return and stop further execution.
 */
- (void)flush;

@end
