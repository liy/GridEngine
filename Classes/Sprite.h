//
//  Sprite.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionNode.h"
#import "TextureManager.h"

@class Texture2D;

@interface Sprite : CollectionNode {
}

/**
 *Create a Graphic inside this Sprite automatically.
 */
- (id)initWithFile:(NSString*)aName;

@end
