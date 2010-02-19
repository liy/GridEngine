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
	CGRect content;
	Texture2D* texRef;
	TextureManager* texManager;
}

@property (nonatomic, readwrite)CGRect content;
@property (nonatomic, assign)Texture2D* texRef;

- (id)initWithName:(NSString*)aName;

@end
