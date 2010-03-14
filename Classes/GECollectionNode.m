//
//  CollectionNode.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GECollectionNode.h"
#import "GECommon.h"

@implementation GECollectionNode

@synthesize children;

- (id)init{
	if (self = [super init]) {
		children = [[NSMutableArray arrayWithCapacity:3] retain];
	}
	return self;
}

- (void)dealloc{
	[children release];
	[super dealloc];
}

- (void)traverse{
	//if not visible, the sub node will not be draw.
	if (!visible) {
		return;
	}
	
	[self draw];
	
	//visit child nodes.
	for (GENode* node in children) {
		[node traverse];
	}
}

- (void)draw{
	//manage its children LeafNode draw.
}

- (GENode*)addChild:(GENode*)aNode{
	//We need to make sure this node is only contained in one CollectionNode
	//If the desire remove node has a parent which means it's already in the display
	//tree, we need remove it from its original CollectnionNode's children list.
	if (aNode.parent != nil) {
		[aNode.parent.children removeObject:aNode];
	}
	
	aNode.parent = self;
	[children addObject:aNode];
	
	//need to updated the added node's parentConcatTransformation
	[aNode updateParentConcatTransforms];

	return [aNode retain];
}

- (GENode*)getChildAt:(uint)index{
	return [children objectAtIndex:index];

}

- (GENode*)removeChild:(GENode*)aNode{
	//The desire node to be removed has no parent node
	//basically means the programmer is trying to remove a node not in the
	//display tree.
	if (aNode.parent == nil) {
		return nil;
	}
	
	if ([self contains:aNode]) {
		[children removeObject:aNode];
		aNode.parent = nil;
		
		//Since we removed the node from display tree, we need to updated the added node's parentConcatTransformation
		[aNode updateParentConcatTransforms];
		
		//you may want to remove it from the screen
		//but still keep it in the memory.
		return [aNode autorelease];
	}
	else {
		return nil;
	}
}

- (GENode*)removeChildAt:(uint)index{
	GENode* aNode = [children objectAtIndex:index];
	if (aNode != nil) {
		[children removeObject:aNode];
		aNode.parent = nil;
		
		//Since we removed the node from display tree, we need to updated the added node's parentConcatTransformation
		[aNode updateParentConcatTransforms];
		
		return [aNode autorelease];
	}
	else {
		return nil;
	}
}

- (BOOL)contains:(GENode*)aNode{
	return [children containsObject:aNode];
}

- (BOOL)hasDescendantNode:(GENode *)aNode{
	if ([self contains:aNode])
		return YES;
	
	for (GENode* node in children) {
		if ([node hasDescendantNode:aNode]) {
			return YES;
		}
	}
	return NO;
}

// Tell the children to update their parentConcatTransformation
- (void)updateParentConcatTransforms{
	//update current node's parentConcatTransformation.
	[super updateParentConcatTransforms];
	
	//update all its child parentConcatTransformation
	
	for (GENode* child in children) {
		child.parentConcatTransforms = CGAffineTransformConcat(child.transform, parentConcatTransforms);
		[child updateParentConcatTransforms];
	}
}

//================================================ setter and getter =============================================
- (CGRect)boundingbox{
	CGPoint minPoint = CGPointZero;
	CGPoint maxPoint = CGPointZero;
	for (GENode* node in children) {
		//Get the child's bouding box.(A CollectionNode or LeafNode)
		CGRect box = [node boundingbox];
		
		if (box.origin.x < minPoint.x) {
			minPoint.x = box.origin.x;
		}
		if (box.origin.y < minPoint.y) {
			minPoint.y = box.origin.y;
		}
		
		float maxX = box.origin.x+box.size.width;
		float maxY = box.origin.y+box.size.height;
		if (maxX > maxPoint.x) {
			maxPoint.x = maxX;
		}
		if (maxY > maxPoint.y) {
			maxPoint.y = maxY;
		}
	}
	return CGRectMake(minPoint.x, minPoint.y, maxPoint.x-minPoint.x, maxPoint.y-minPoint.y);
}

- (CGSize)contentSize{
	//content size is the size of this node's bouding box without transformation applied to this node.
	return CGSizeApplyAffineTransform([self boundingbox].size, CGAffineTransformInvert(transform));
}

@end
