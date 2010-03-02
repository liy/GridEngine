//
//  Node.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@class CollectionNode;

/**
 * Abstract class for CollectionNode and LeafNode.
 *
 *
 */
@interface Node : NSObject {
	CGPoint pos;
	//original content size. default is (0,0).
	CGSize contentSize;
	//The rotation of the node.
	float rotation;
	
	
	//The transformation matrix for this node.
	//Note that this transform matrix does not contains any of its parents' transform.
	//The exact draw transform matrix is calculated when the node is draw to the screen
	//Which will concatenate its parent transform matrix to produce correct transform result.
	CGAffineTransform transform;
	
	//The matrix concat current node's matrix with paren's parentConcatTransforms.
	//This means this matrix concat all its parents' transformation matrix. We can directly use this
	//for rendering.
	//YOUR SHOULD NEVER EVER OVERRIDE THIS VARIABLE OUTSIDE OF THE ENGINE BY YOURSELF, UNLESS YOU KNOW WHAT YOU ARE DOING.
	CGAffineTransform parentConcatTransforms;
	
	
	//scales
	float scaleX;
	float scaleY;
	//number of children under this node. LeafNode will always have 0 child.
	uint numChildren;
	//The parent node of this node, root node will have a parent=nil
	CollectionNode* parent;
	//The camera pointed to this node.
	Camera* camera;
	//whether this node is visible on the screen.
	//If it is invisible, it will not fire draw method. But underlying
	//data update could be updated.
	BOOL visible;
	
	//An abstract point to identify the exact position of the Node.
	//Since some display object can be any shape, we need a generic and simple way to discirbe its position
	//This point's x and y will use the local coordinate system of this Node, eg:
	//If this Node width and height is 100*100, if we put the anchor point at its centre,
	//the anchor point position will be (50, 50), top-right:(0, 100), top-left:(0,0), bottom-right(100,100)
	//It can go over the size of the Node as well: (-50, -30) will be somewhere towards top-left but outside of the 
	//size of this node.
	//Default achor position will be at (0,0)
	CGPoint anchor;
	
	//The changed size of the Node, default is (0,0)
	CGSize size;
}

/**
 * Whether the visual object will be rendred on the screen.
 */
@property (nonatomic)BOOL visible;
/**
 * Position of the node. Default is (0,0) at the bottom left.
 */
@property (nonatomic, assign)CGPoint pos;
/**
 * The contentSize of the visual object, default is (0,0). The transform matrix will not apply to contentSize.
 * If the node has a texture or video the contentSize will be the size of the video or texture image.
 * For the Animation, the contentSize could be different from time to time depends on the Frame rect.
 * But the Animation's contentSize is also not applied with tranformation matrix.
 * After transform the contentSize will NOT be changed.
 *
 * Only Animation will update contentSize depends on different frames.
 */
@property (nonatomic, readonly)CGSize contentSize;
@property (nonatomic, readonly)uint numChildren;
@property (nonatomic, assign)CollectionNode* parent;
@property (nonatomic, assign)Camera* camera;
@property (nonatomic, readwrite)float rotation;
@property (nonatomic)float scaleX;
@property (nonatomic)float scaleY;
@property (nonatomic, assign)CGAffineTransform transform;
@property (nonatomic, assign)CGPoint anchor;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGAffineTransform parentConcatTransforms;

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

/**
 * Add a Node to its child. 
 */
- (Node*)addChild:(Node*)aNode;

/**
 * Get its child node using children array index (Kind of depth index if you like.)
 * @return A child node of this node. nil if the node does not exsit(index out of bounds)
 */
- (Node*)getChildAt:(uint)index;

/**
 * Remove a child from its children array.
 */
- (Node*)removeChild:(Node*)aNode;

/**
 * Remove a specific indexed child.
 */
- (Node*)removeChildAt:(uint)index;

/**
 * Whether this node directly contains a node.
 */
- (BOOL)contains:(Node*)aNode;

/**
 * Whether this node has the specified desendant node
 */
- (BOOL)hasDescendantNode:(Node*)aNode;

/**
 * NOT USED Anymmore xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 * Get all the parent transformations concat together.
 */
- (CGAffineTransform)concatParentTransformations;

/**
 * Update the transformation matrix which contains all the parents transformation matrix.
 */
- (void)updateParentConcatTransforms;

/**
 *
 */
- (CGRect)boundingbox;
@end
