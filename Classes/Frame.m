//
//  Frame.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Frame.h"


@implementation Frame

@synthesize delay;
@synthesize texRef;
@synthesize rect;

- (id)initWithTex:(Texture2D*)aTexRef rect:(CGRect)aRect withDelay:(float)aDelay{
	if (self = [super init]) {
		delay = aDelay;
		rect = aRect;
		texRef = aTexRef;
	}
	return self;
}

@end
