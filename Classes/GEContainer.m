//
//  Sprite.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEContainer.h"
#import "GESprite.h"

@implementation GEContainer

- (id)initWithFile:(NSString *)aName{
	if (self = [super init]) {
		GESprite* graphic = [[GESprite alloc] initWithFile:aName];
		[self addChild:graphic];
	}
	return self;
}

@end
