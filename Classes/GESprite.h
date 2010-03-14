//
//  Sprite.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GECollectionNode.h"
#import "GETexManager.h"

@class Texture2D;

@interface GESprite : GECollectionNode {
}

/**
 *Create a Graphic inside this Sprite automatically.
 */
- (id)initWithFile:(NSString*)aName;

@end
