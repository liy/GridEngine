//
//  Node.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Node.h"

@implementation Node

@synthesize visible;
@synthesize numChildren;
@synthesize parent;
@synthesize camera;
@synthesize pos;
@synthesize contentSize;
@synthesize rotation;
@synthesize scaleX;
@synthesize scaleY;
@synthesize transform;

- (id)init{
	if (self = [super init]) {
		visible = YES;
		numChildren = 0;
		parent = nil;
		camera = [[Camera alloc] init];
		
		rotation = 0.0f;
		scaleX = 1.0f;
		scaleY = 1.0f;
		contentSize = CGSizeMake(0.0f, 0.0f);
		pos = CGPointMake(0.0f, 0.0f);
		transform = CGAffineTransformIdentity;
	}
	return self;
}

- (void)visit{
	//always draw current node
	[self draw];
}

- (void)draw{
	//if it is not visible then do not draw.
	if (!visible)
		return;
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
			[self size].width,
			[self size].height];
}


/**
 * =========================================================================================================================
 * FIXME: Using a matrix to contain all the affine transformtion.
 * =========================================================================================================================
 */
- (void)setPos:(CGPoint)aPos{
	pos = aPos;
	transform = CGAffineTransformTranslate(transform, pos.x, pos.y);
}

- (void)setScaleX:(float)aScaleX{
	scaleX = aScaleX;
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
}

- (void)setScaleY:(float)aScaleY{
	scaleY = aScaleY;
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
}

- (void)setRotation:(float)aRotation{
	rotation = aRotation;
	transform = CGAffineTransformRotate(transform, rotation);
}

- (void)setTransform:(CGAffineTransform)aTransform{
	transform = CGAffineTransformIdentity;
	[self setPos:CGPointMake(transform.tx, transform.ty)];
	[self setRotation:acosf(rotation/(180.0*M_PI))*(180/M_PI)];
	[self setScaleX:transform.a];
	[self setScaleY:transform.d];
	
}


- (CGSize)size{
	//NSLog(@"return content size width:%f  height:%f", contentSize.width, contentSize.height);
	return CGSizeMake(contentSize.width*scaleX, contentSize.height*scaleY);
}

- (void)size:(CGSize)aSize{
	if (contentSize.width != 0) {
		[self setScaleX:(aSize.width/contentSize.width)];
	}
	if (contentSize.height != 0) {
		[self setScaleY:(aSize.height/contentSize.height)];
	}
}

@end
