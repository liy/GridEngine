//
//  Node.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Node.h"
#import "Common.h"

@implementation Node

@synthesize visible;
@synthesize numChildren;
@synthesize parent;
@synthesize camera;
@synthesize pos;
@synthesize contentSize;
@synthesize size;
@synthesize rotation;
@synthesize scaleX;
@synthesize scaleY;
@synthesize transform;
@synthesize anchor;

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
		
		size = contentSize;
		
		pos = CGPointMake(0.0f, 0.0f);
		
		anchor = CGPointMake(0.0f, 0.0f);
		
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

- (void)centreAnchor{
	anchor = CGPointMake(contentSize.width/2, contentSize.height/2);
}

/**
 * =========================================================================================================================
 * FIXME: Using a matrix to contain all the affine transformtion.
 * =========================================================================================================================
 */
- (void)setSize:(CGSize)aSize{
	if (contentSize.width != 0 && contentSize.height != 0) {
		size = aSize;
		[self setScaleX:(size.width/contentSize.width)];
		[self setScaleY:(size.height/contentSize.height)];
	}
}

- (void)setScaleX:(float)aScaleX{
	scaleX = aScaleX;
	//Since matrix's a and d are combined with scale and rotation.
	//we need to create brand new matrix to update the transform matrix, we need to assign the existing translation as well.
	//We alwasy apply translate first(it does not related to scale and rotation), then scale finally rotation.
	//This is the people mostly wanted effect: scale the picture bigger then rotate.
	//If you want to rotate first then rotate, you can directly set the transform matrix.
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
}

- (void)setScaleY:(float)aScaleY{
	scaleY = aScaleY;
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
}

- (void)setRotation:(float)aRotation{
	rotation = aRotation;
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
}

- (void)setPos:(CGPoint)aPos{
	pos = aPos;
	transform.tx = pos.x;
	transform.ty = pos.y;
}

- (void)setTransform:(CGAffineTransform)matrix{
	transform = matrix;
	/**
	 * Matrix:
	 * |a   b   0|
	 * |c   d   0|
	 * |tx  ty  1|
	 *
	 * Equation 1:
	 * x' = a*x + c*y + tx
	 * y' = b*x + d*y + ty    
	 *
	 * Equation 2:
	 * x' = scaleX*cos(theta)*x - skewX*cos(theta)*y + tx
	 * y' = skewY*sin(theta)*x + scaleY*cos(theta)*y + ty
	 *
	 * Dquation 3:
	 * a = scaleX * cos(theta)
	 * c = skewX * (-sin(theta))
	 * b = skewY * sin(theta)
	 * d = scaleY * cos(theta)
	 *
	 * A union point at (1, 0). Without any transformation:
	 * Since, x=1, y=0, tx=0, ty=0
	 * then, x'=a, y'=b
	 * So, theta = atan(b/a) ===> theta = atan2f(b, a)
	 * 
	 * After aquired theta rotation.
	 * From Equation 3, we can easily calculate scaleX, scaleY.
	 */
	float radian = atan2f(transform.b, transform.a);
	rotation = RADIANS_TO_DEGREES(radian);
	scaleX = transform.a/cosf(radian);
	scaleY = transform.d/cosf(radian);
	pos = CGPointMake(transform.tx, transform.ty);
}

@end
