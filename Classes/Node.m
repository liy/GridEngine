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
@synthesize pos;
@synthesize size;
@synthesize rotation;
@synthesize scaleX;
@synthesize scaleY;
@synthesize transform;

- (id)init{
	if (self = [super init]) {
		numChildren = 0;
		parent = nil;
		camera = [[Camera alloc] init];
		
		rotation = 0.0f;
		scaleX = 1.0f;
		scaleY = 1.0f;
		size = CGSizeMake(0.0f, 0.0f);
		pos = CGPointMake(0.0f, 0.0f);
		transform = CGAffineTransformIdentity;
	}
	return self;
}

- (void)draw{
	//do nothing
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
	//do nothing
	return nil;
}

- (BOOL)contains:(Node*)aNode{
	//default NO
	return NO;
}

- (BOOL)hasDescendantNode:(Node*)aNode{
	//default NO
	return NO;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X, pos=(%.2f,%.2f) size=(%.2f,%.2f)>", [self class], self,
			pos.x,
			pos.y,
			size.width,
			size.height];
}

- (void)setPos:(CGPoint)aPos{
	pos = aPos;
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
}

- (void)setSize:(CGSize)aSize{
	[self setScaleX:aSize.width/size.width];
	[self setScaleY:aSize.height/size.height];
	size = aSize;
}

- (void)setScaleX:(float)aScaleX{
	scaleX = aScaleX;
	transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY);
}

- (void)setScaleY:(float)aScaleY{
	scaleY = aScaleY;
	transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY);
}

- (void)setRotation:(float)aRotation{
	rotation = aRotation;
	transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotation);
}

- (void)setTransform:(CGAffineTransform)aTransform{
	transform = aTransform;
	NSLog(@"set tx:%f", aTransform.tx);
	[self setPos:CGPointMake(transform.tx, transform.ty)];
	//[self setScaleX:transform.a];
	//[self setScaleY:transform.d];
	//[self setSize:CGSizeMake(size.width*scaleX, size.height*scaleY)];
	//[self setRotation:acosf(rotation/(180.0*M_PI))*(180/M_PI)];
}

@end
