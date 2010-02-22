//
//  CollectionNode.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "CollectionNode.h"


@implementation CollectionNode

- (id)init{
	if (self = [super init]) {
		children = [[NSMutableArray arrayWithCapacity:3] retain];
	}
	return self;
}

- (void)draw{
	//draw child nodes.
	for (Node* node in children) {
		[node draw];
	}
}

- (Node*)addChild:(Node*)aNode{
	aNode.parent = self;
	[children addObject:aNode];
	//all the children should shift by amount of the container's position.
	aNode.pos = CGPointMake(aNode.pos.x + pos.x, aNode.pos.y + pos.y);
	return [aNode retain];
}

- (Node*)getChildAt:(uint)index{
	return [children objectAtIndex:index];

}

- (Node*)removeChild:(Node*)aNode{
	if ([self contains:aNode]) {
		[children removeObject:aNode];
		aNode.parent = nil;
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

- (void)dealloc{
	[children release];
	[super dealloc];
}

@end