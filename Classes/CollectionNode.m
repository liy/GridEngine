//
//  CollectionNode.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "CollectionNode.h"
#import "Common.h"

@implementation CollectionNode

@synthesize children;

- (id)init{
	if (self = [super init]) {
		children = [[NSMutableArray arrayWithCapacity:3] retain];
	}
	return self;
}

- (void)visit{
	//never draw the the collection node, collectionNode has nothing to draw.


	//if not visible, the sub node will not be draw.
	if (!visible) {
		return;
	}
	
	//visit child nodes.
	for (Node* node in children) {
		[node visit];
	}
}

- (Node*)addChild:(Node*)aNode{
	//We need to make sure this node is only contained in one CollectionNode
	//If the desire remove node has a parent which means it's already in the display
	//tree, we need remove it from its original CollectnionNode's children list.
	if (aNode.parent != nil) {
		[aNode.parent.children removeObject:aNode];
	}
	
	aNode.parent = self;
	[children addObject:aNode];
	
	//need to updated the added node's parentConcatTransformation
	[aNode updateParentConcatTransform];

	return [aNode retain];
}

- (Node*)getChildAt:(uint)index{
	return [children objectAtIndex:index];

}

- (Node*)removeChild:(Node*)aNode{
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
		[aNode updateParentConcatTransform];
		
		//you may want to remove it from the screen
		//but still keep it in the memory.
		return [aNode autorelease];
	}
	else {
		return nil;
	}
}

- (Node*)removeChildAt:(uint)index{
	Node* aNode = [children objectAtIndex:index];
	if (aNode != nil) {
		[children removeObject:aNode];
		aNode.parent = nil;
		
		//Since we removed the node from display tree, we need to updated the added node's parentConcatTransformation
		[aNode updateParentConcatTransform];
		
		return [aNode autorelease];
	}
	else {
		return nil;
	}
}

- (BOOL)contains:(Node*)aNode{
	return [children containsObject:aNode];
}

- (BOOL)hasDescendantNode:(Node *)aNode{
	if ([self contains:aNode])
		return YES;
	
	for (Node* node in children) {
		if ([node hasDescendantNode:aNode]) {
			return YES;
		}
	}
	return NO;
}

- (CGRect)boundingbox{
	CGPoint minPoint = CGPointZero;
	CGPoint maxPoint = CGPointZero;
	for (Node* node in children) {
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

- (void)updateParentConcatTransform{
	//update current node's parentConcatTransformation.
	[super updateParentConcatTransform];
	
	//update all its child parentConcatTransformation
	for (Node* child in children) {
		child.parentConcatTransforms = CGAffineTransformConcat(child.transform, parentConcatTransforms);
		[child updateParentConcatTransform];
	}
}

//============================================================================================================
- (CGSize)contentSize{
	CGPoint minPoint = CGPointZero;
	CGPoint maxPoint = CGPointZero;
	for (Node* node in children) {
		CGSize nodeSize = [node contentSize];
		
		if (node.pos.x < minPoint.x) {
			minPoint.x = node.pos.x;
		}
		if (node.pos.y < minPoint.y) {
			minPoint.y = node.pos.y;
		}
		
		float maxX = node.pos.x+nodeSize.width;
		float maxY = node.pos.y+nodeSize.height;
		if (maxX > maxPoint.x) {
			maxPoint.x = maxX;
		}
		if (maxY > maxPoint.y) {
			maxPoint.y = maxY;
		}
	}
	return CGSizeMake(maxPoint.x-minPoint.x, maxPoint.y-minPoint.y);
}

- (CGSize)size{
	return [self boundingbox].size;
}

- (void)dealloc{
	[children release];
	[super dealloc];
}

@end
