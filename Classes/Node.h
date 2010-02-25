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
	//original content size. default is (0,0).
	CGSize contentSize;
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
 */
@property (nonatomic, readonly)CGSize contentSize;
@property (nonatomic, readonly)uint numChildren;
@property (nonatomic, assign)Node* parent;
@property (nonatomic, assign)Camera* camera;
@property (nonatomic)float rotation;
@property (nonatomic)float scaleX;
@property (nonatomic)float scaleY;
@property (nonatomic, assign)CGAffineTransform transform;

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

/**
 * Set size. Node it does not set resize the contentSize property. It only update the transformation matrix.
 * update the scale properties.
 */
- (void)size:(CGSize)aSize;

/**
 * Return the current size of the Node, will could be equal to contentSize if the scaleX and scaleY is 1.
 * If the scaleX and scaleY are not 1, the returned CGSize will be different from the contentSize.
 */
- (CGSize)size;

@end
