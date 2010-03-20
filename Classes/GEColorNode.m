//
//  ColorNode.m
//  GridEngine
//
//  Created by Liy on 10-2-22.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEColorNode.h"


@implementation GEColorNode

@synthesize tlColor;
@synthesize blColor;
@synthesize trColor;
@synthesize brColor;

- (id)init{
	if (self = [super init]) {
		tvcQuads = calloc(1, sizeof(VCQuad));
		
		tlColor = Color4bMake(255, 255, 255, 255);
		blColor = Color4bMake(255, 255, 255, 255);
		trColor = Color4bMake(255, 255, 255, 255);
		brColor = Color4bMake(255, 255, 255, 255);
	}
	return self;
}

- (void) dealloc{
	free(tvcQuads);
	[super dealloc];
}

@end
