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
@synthesize rotation;
@synthesize scaleX;
@synthesize scaleY;
@synthesize transform;
@synthesize anchor;
@synthesize size;
@synthesize parentConcatTransforms;

- (id)init{
	if (self = [super init]) {
		visible = YES;
		
		numChildren = 0;
		
		parent = nil;
		
		camera = [[Camera alloc] init];
		
		transform = CGAffineTransformIdentity;
		
		parentConcatTransforms = transform;
		
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

- (void)draw{
	//if it is not visible then do not draw.
	if (!visible)
		return;
}

- (void)visit{
	//always draw current node
	[self draw];
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
			contentSize.width,
			contentSize.height];
}

//======================================================================================================================================
- (CGAffineTransform)concatParentTransformations{
	//If we have a parent for this node, then we need to
	//concat the transformation matrix to its parent node's concated transformation matrix
	//The recursive call gather all transformation matrix of the parent nodes.
	if (parent != nil) {
		//float radian = atan2f(transform.b, transform.a);
		//NSLog(@"rotation: %f", RADIANS_TO_DEGREES(radian));
		return CGAffineTransformConcat(transform, [parent concatParentTransformations]);
		
	}
	//if parent node is nil, means we reach the root of the display tree. Simply return
	//the root node's transformation matrix. This matrix will be concat with all the children node matrix.
	else {
		return transform;
	}
}

- (void)updateParentConcatTransform{
	//update current node's parentConcatTransformation. This part is used by both LeafNode and CollectionNode
	//Collection node will need to update all its descendant nodes' parentConcatTransform
	if (parent!=nil) {
		parentConcatTransforms = CGAffineTransformConcat(transform, [parent parentConcatTransforms]);
	}
	else {
		parentConcatTransforms = transform;
	}
}

/**
 * =========================================================================================================================
 * FIXME: Using a matrix to contain all the affine transformtion.
 * =========================================================================================================================
 */
- (void)setScaleX:(float)aScaleX{
	scaleX = aScaleX;
	//Since matrix's a and d are combined with scale and rotation.
	//we need to create brand new matrix to update the transform matrix, we need to assign the existing translation as well.
	//We normally do not want image to be skewed.
	//So, we need to apply scale first, then we rotated (This ensure the target does not skew)
	//Finally we translate the target to the desire position.
	//However, CGAffineTransform is appplied in opposite direction. So we need to call translate first, then rotate, finally rotate.
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	[self updateParentConcatTransform];
}

- (void)setScaleY:(float)aScaleY{
	scaleY = aScaleY;
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	[self updateParentConcatTransform];
}

- (void)setRotation:(float)aRotation{
	rotation = aRotation;
	transform = CGAffineTransformTranslate(CGAffineTransformIdentity, pos.x, pos.y);
	transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(rotation));
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	[self updateParentConcatTransform];
}

- (void)setPos:(CGPoint)aPos{
	pos = aPos;
	
	//We need to retain the rotation, scale, and skew of the original transformation
	//All we need to change is translation.
	transform.tx = 0.0f;
	transform.ty = 0.0f;
	CGAffineTransform matrix = CGAffineTransformMakeTranslation(pos.x, pos.y);
	transform = CGAffineTransformConcat(transform, matrix);
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	[self updateParentConcatTransform];
}

- (void)setAnchor:(CGPoint)aPoint{
	anchor = aPoint;
	
	transform.tx = 0.0f;
	transform.ty = 0.0f;
	
	CGAffineTransform matrix = CGAffineTransformMakeTranslation(pos.x, pos.y);
	transform = CGAffineTransformConcat(transform, matrix);
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	[self updateParentConcatTransform];
}

- (CGRect)boundingbox{
	//The bounding box without transform is simply the contentSize rectangle.
	CGRect box = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
	//We need to find out the transformation matrix of current node and its parent node.
	CGAffineTransform matrix = [self concatParentTransformations];
	
	return CGRectApplyAffineTransform(box, matrix);
}

//======================================================================================================================================

- (void)setTransform:(CGAffineTransform)matrix{
	transform = matrix;
	transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
	
	//Update parentConcatTransformation
	[self updateParentConcatTransform];
	
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

/**
 * Never set the size when the Node's contentSize is 0.
 */
- (void)setSize:(CGSize)aSize{
	
	//make sure the scale is valid.
	if (!CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
		size = aSize;
		self.scaleX = size.width/self.contentSize.width;
		self.scaleY = size.height/self.contentSize.height;
	}
	else {
		NSLog(@"size is 0!!!!!");
		self.scaleX = 1.0f;
		self.scaleY = 1.0f;
	}
}

@end
