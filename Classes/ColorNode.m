//
//  ColorNode.m
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "ColorNode.h"


@implementation ColorNode

@synthesize tlColor;
@synthesize rlColor;
@synthesize trColor;
@synthesize brColor;

- (id)init{
	if (self = [super init]) {
		vcQuad = calloc(1, sizeof(VCQuad));
		
		tlColor = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
		rlColor = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
		trColor = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
		brColor = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
	}
	return self;
}

@end
