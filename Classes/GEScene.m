//
//  Scene.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEScene.h"


@implementation GEScene

@synthesize name;

- (id)initWithName:(NSString *)aName{
	if (self = [super init]) {
		name = aName;
	}
	return self;
}

@end
