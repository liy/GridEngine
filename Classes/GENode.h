//
//  Node.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GECamera.h"

@class GECollectionNode;

/**
 * Abstract class for CollectionNode and LeafNode.
 *
 *
 */
@interface GENode : NSObject {
	CGPoint pos;
	//original content size. default is (0,0). CollectionNode's contentSize can change depends on the children's transformations.
	//The Animation's contentSize can also change depends on the different frame's rect.
	//Note, contentSize can be different to the texRef's contentSize(The whole image size loaded)
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
	GECollectionNode* parent;
	//The camera pointed to this node.
	GECamera* camera;
	//whether this node is visible on the screen.
	//If it is invisible, it will not fire draw method. But underlying
	//data update could be updated.
	BOOL visible;
	
	//An abstract ratio point to identify the exact position of the Node.
	//Since some display object can be any shape, we need a generic and simple way to discirbe its position
	//This point's x and y will use the ratio of the node's contentSize, so we do not need to care about the size of the Node. eg:
	//If we put the anchor point at its centre, the anchor point position will be (0.5, 0.5), top-right:(0.0, 1.0), top-left:(0.0,0.0), 
	//bottom-right(1.0,1.0)
	//It can go over the contentSize of the Node as well: (-5.0, -3.0) will be somewhere towards top-left but outside of the 
	//contentSize of this node.
	//Default achor position will be at (0.0,0.0)
	//It is also used during rotation, for example: if we centre the anchor then rotate, the object will spinning around the anchor point. 
	CGPoint anchor;
	
	//The changed size of the Node, default is (0,0).
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
 * CollectionNode's contentSize is calculated by checking its children's contentSize. It can be changed depends on the
 * transformation of the children nodes.
 */
@property (nonatomic, readonly)CGSize contentSize;
@property (nonatomic, readonly)uint numChildren;
@property (nonatomic, assign)GECollectionNode* parent;
@property (nonatomic, assign)GECamera* camera;
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
- (void)traverse;

/**
 * Override this function and do all the drawing here. Remember to call [super draw] which decide whether to process
 * draw function. If the node is invisible, this function will returned without further processing.
 */
- (void)draw;

/**
 * This is a hack method which directly draw this Node and its sub nodes
 */
- (void)directDraw;

/**
 * Add a Node to its child. 
 */
- (GENode*)addChild:(GENode*)aNode;

/**
 * Get its child node using children array index (Kind of depth index if you like.)
 * @return A child node of this node. nil if the node does not exsit(index out of bounds)
 */
- (GENode*)getChildAt:(uint)index;

/**
 * Remove a child from its children array.
 */
- (GENode*)removeChild:(GENode*)aNode;

/**
 * Remove a specific indexed child.
 */
- (GENode*)removeChildAt:(uint)index;

/**
 * Whether this node directly contains a node.
 */
- (BOOL)contains:(GENode*)aNode;

/**
 * Whether this node has the specified desendant node
 */
- (BOOL)hasDescendantNode:(GENode*)aNode;

/**
 * NOT USED Anymmore xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 * Get all the parent transformations concat together.
 */
//- (CGAffineTransform)concatParentTransformations;

/**
 * Update the transformation matrix which contains all the parents transformation matrix.
 */
- (void)updateParentConcatTransforms;

/**
 * Calculate the rectangle bounding box for the node. All the transformations are taken into account as well.
 * Defined the area and position covered by the node.
 */
- (CGRect)boundingbox;

@end
