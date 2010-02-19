//
//  Frame.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Frame.h"


@implementation Frame

@synthesize duration;
@synthesize texRef;
@synthesize content;

- (id)initWithTex:(Texture2D*)aTexRef rect:(CGRect)rect withDuration:(float)aDuration{
	if (self = [super init]) {
		duration = aDuration;
		content = rect;
		texRef = aTexRef;
	}
	return self;
}

@end
