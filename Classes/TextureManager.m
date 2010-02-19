//
//  TextureManager.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "TextureManager.h"
#import "Texture2D.h"

@implementation TextureManager

@synthesize boundedTex;

static TextureManager* instance;

+ (TextureManager*)sharedTextureManager{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [TextureManager alloc];
		}
	}
	
	return instance;
}

- (id) init{
	if (self = [super init]) {
		texCache = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

- (Texture2D*)getTexture2D:(NSString *)fileName{
	Texture2D* tex = [texCache objectForKey:fileName];
	if (tex == nil) {
		tex = [[Texture2D alloc] initWithImage:[UIImage imageNamed:fileName]];
		[texCache setObject:tex forKey:fileName];
	}
	return [tex autorelease];
}

- (Texture2D*)removeTexture2D:(NSString*)fileName{
	Texture2D* tex = [texCache objectForKey:fileName];
	if (tex != nil) {
		//ensure the retain count is not 0
		[tex retain];
		[texCache removeObjectForKey:fileName];
	}
	return [tex autorelease];
}

- (void)clear{
	[texCache removeAllObjects];
}

@end
