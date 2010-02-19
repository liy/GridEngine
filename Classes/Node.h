//
//  Node.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

/**
 * Abstract class for CollectionNode and LeafNode.
 *
 *
 */
@interface Node : NSObject {
	uint numChildren;
	Node* parent;
	Camera* camera;
}

@property (nonatomic, readonly)uint numChildren;
@property (nonatomic, assign)Node* parent;
@property (nonatomic, assign)Camera* camera;

- (Node*)addChild:(Node*)aNode;

- (Node*)getChildAt:(uint)index;

- (Node*)removeChild:(Node*)aNode;

- (Node*)removeChildAt:(uint)index;

- (BOOL)contains:(Node*)aNode;

- (BOOL)hasDescendantNode:(Node*)aNode;

@end
