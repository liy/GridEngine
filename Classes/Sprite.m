//
//  Sprite.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Sprite.h"
#import "Graphic.h"

@implementation Sprite

- (id)initWithFile:(NSString *)aName{
	if (self = [super init]) {
		Graphic* graphic = [[Graphic alloc] initWithFile:aName];
		[self addChild:graphic];
	}
	return self;
}

/*
- (void)setPos:(CGPoint)aPos{
	pos = aPos;
	
	for (Node* node in children) {
		//shift for every child
		node.pos = CGPointMake(node.pos.x + pos.x, node.pos.y + pos.y);
	}
}
*/

@end
