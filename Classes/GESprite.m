//
//  Sprite.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GESprite.h"
#import "GEGraphic.h"

@implementation GESprite

- (id)initWithFile:(NSString *)aName{
	if (self = [super init]) {
		GEGraphic* graphic = [[GEGraphic alloc] initWithFile:aName];
		[self addChild:graphic];
	}
	return self;
}

@end
