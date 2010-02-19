//
//  Animation.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Animation.h"
#import "Frame.h"


@implementation Animation

@synthesize texRef;

- (id)initWithName:(NSString*)aName{
	if (self = [super init]) {
		texManager = [TextureManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		frames = [[NSMutableArray alloc] initWithCapacity:5];
	}
	return self;
}

- (void)addFrame:(CGRect)aRect withDuration:(float)duration{
	Frame* frame = [[Frame alloc] initWithTex:texRef rect:aRect withDuration:duration];
	[frames addObject:frame];
	[frame release];
}

- (void)addFrame:(CGRect)aRect named:(NSString*)aName withDuration:(float)duration{
	Texture2D* tex = [texManager getTexture2D:aName];
	Frame* frame = [[Frame alloc] initWithTex:tex rect:aRect withDuration:duration];
	[frames addObject:frame];
	[frame release];
}

@end
