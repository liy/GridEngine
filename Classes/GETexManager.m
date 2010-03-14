//
//  TextureManager.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GETexManager.h"
#import "Texture2D.h"

@implementation GETexManager

@synthesize boundedTex;

static GETexManager* instance;

+ (GETexManager*)sharedTextureManager{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [GETexManager alloc];
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

- (void)dealloc{
	[texCache release];
	[super dealloc];
}

- (Texture2D*)getTexture2D:(NSString *)fileName{
	Texture2D* tex = [texCache objectForKey:fileName];
	if (tex == nil) {
		tex = [[Texture2D alloc] initWithImage:[UIImage imageNamed:fileName]];
		[texCache setObject:tex forKey:fileName];
	}
	//never auto release here.... I don't know why I did it before.
	//Since if you do not retain the tex in other method, you will get nil texture, which will result
	//unexpect error or crash
	return tex;
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
