//
//  Sprite.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Sprite.h"


@implementation Sprite

@synthesize content;
@synthesize texRef;

- (id)initWithName:(NSString *)aName{
	if (self = [super init]) {
		texManager = [TextureManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		content = CGRectMake(0.0f, 0.0f, texRef.contentSize.width, texRef.contentSize.height);
	}
	return self;
}

@end
