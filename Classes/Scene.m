//
//  Scene.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Scene.h"


@implementation Scene

@synthesize name;

- (id)initWithName:(NSString *)aName{
	if (self = [super init]) {
		name = aName;
	}
	return self;
}

@end
