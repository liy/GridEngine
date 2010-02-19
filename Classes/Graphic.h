//
//  Graphic.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafNode.h"
#import "TextureManager.h"

@class Texture2D;

/**
 * Graphic represents a pure image, without any frames or children.
 */
@interface Graphic : LeafNode {
	CGRect content;
	Texture2D* texRef;
	TextureManager* texManager;
	//Color
}

@property (nonatomic, readwrite)CGRect content;
@property (nonatomic, assign)Texture2D* texRef;

/**
 * Create a Graphic object using the image file name.
 * @param aName The image's file name.
 */
- (id)initWithName:(NSString*)aName;

@end
