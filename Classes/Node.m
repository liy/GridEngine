//
//  Node.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Node.h"


@implementation Node

@synthesize numChildren;
@synthesize parent;
@synthesize camera;


- (id)init{
	if (self = [super init]) {
		numChildren = 0;
		parent = nil;
		camera = [[Camera alloc] init];
	}
	return self;
}

- (Node*)addChild:(Node*)aNode{
	//do nothing
	return nil;
}

- (Node*)getChildAt:(uint)index{
	return nil;
}

- (Node*)removeChild:(Node*)aNode{
	//do nothing
	return nil;
}

- (Node*)removeChildAt:(uint)index{
	return nil;
}

- (BOOL)contains:(Node*)aNode{
	return NO;
}

- (BOOL)hasDescendantNode:(Node*)aNode{
	return NO;
}

@end
