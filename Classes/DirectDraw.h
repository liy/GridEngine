//
//  DirectDraw.h
//  GridEngine
//
//  Created by Liy on 10-3-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextureNode.h"
#import "TextureManager.h"
#import "Common.h"

@interface DirectDraw : TextureNode {

	TVCQuad* quads;
	
	int numOfQuads;
}

@end
