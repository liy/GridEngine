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
	TVCQuad* tvcQuads;
	uint numOfQuads;
	GETexManager* texManager;
	GLubyte* indices;
}

@property (nonatomic, assign, readwrite)uint numOfQuads;

+ (GESpriteBatch*)sharedSpriteBatch;

- (void)batchNode:(GETextureNode*)aTexNode;

- (void)flush;

@end
