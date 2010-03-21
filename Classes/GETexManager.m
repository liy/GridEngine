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
		if (tex == nil) {
			NSLog(@"Image creation error, Texture2D is nil.");
			return nil;
		}
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
		//ensure the retain count is not 0, one you retain the retain count will be 2.
		[tex retain];
		//after you remove the Texture2D, its retain count will be 1.
		[texCache removeObjectForKey:fileName];
	}
	//After autorelease is triggered the texture reatain count will be 0, memory will be free.
	return [tex autorelease];
}

- (void)clear{
	[texCache removeAllObjects];
}

@end
