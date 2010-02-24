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
	CGPoint pos;
	CGSize size;
	float rotation;
	CGAffineTransform transform;
	float scaleX;
	float scaleY;
	uint numChildren;
	Node* parent;
	Camera* camera;
	BOOL visible;
}

/**
 * Whether the visual object will be rendred on the screen.
 */
@property (nonatomic, readwrite)BOOL visible;
/**
 * Position of the node. Default is (0,0) at the bottom left.
 */
@property (nonatomic, readwrite, assign)CGPoint pos;
/**
 * The size of the visual object, default is (0,0).
 * After transform the size will be changed as well.
 */
@property (nonatomic, readwrite, assign)CGSize size;
@property (nonatomic, readonly)uint numChildren;
@property (nonatomic, assign)Node* parent;
@property (nonatomic, assign)Camera* camera;
@property (nonatomic)float rotation;
@property (nonatomic, readwrite)float scaleX;
@property (nonatomic, readwrite)float scaleY;
@property (nonatomic, readwrite, assign)CGAffineTransform transform;

/**
 * Used for scan all the child nodes if there is any. Draw function is triggered here as well.
 * The update code could be placed here as well. Since the visit function will always be triggered.
 * We can update underlying data even the visual object is invisible.
 */
- (void)visit;

/**
 * Override this function and do all the drawing here. Remember to call [super draw] which decide whether to process
 * draw function. If the node is invisible, this function will returned without further processing.
 */
- (void)draw;

- (Node*)addChild:(Node*)aNode;

- (Node*)getChildAt:(uint)index;

- (Node*)removeChild:(Node*)aNode;

- (Node*)removeChildAt:(uint)index;

- (BOOL)contains:(Node*)aNode;

- (BOOL)hasDescendantNode:(Node*)aNode;

@end
