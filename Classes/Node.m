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
		transform = CGAffineTransformIdentity;
		
		rotation = 0.0f;
		scaleX = 1.0f;
		scaleY = 1.0f;
		contentSize = CGSizeMake(0.0f, 0.0f);
		pos = CGPointMake(0.0f, 0.0f);
		
	}
	return self;
}

- (void)updateTransformation{
	
	transform = CGAffineTransformIdentity;
	transform = CGAffineTransformRotate(transform, rotation);
	transform = CGAffineTransformTranslate(transform, pos.x, pos.y);
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	
	/*
	 when draw, create a new transform matrix to concat with parent transform.
	if (parent != nil) {
		transform = CGAffineTransformConcat( parent.transform, transform);
	}
	 */
	
	
	NSLog(@"%@ pos x:%f, y:%f", [self class], pos.x, pos.y);
	NSLog(@"%@ tra x:%f, y:%f", [self class], transform.tx, transform.ty);
}

- (void)visit{
	[self updateTransformation];
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
