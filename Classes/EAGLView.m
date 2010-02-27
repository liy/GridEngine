//
//  EAGLView.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright Bangboo 2010. All rights reserved.
//

#import "EAGLView.h"
#import "Animation.h"
#import "Director.h"
#import "Sprite.h"
#import "Common.h"

@implementation EAGLView

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        director = [[Director sharedDirector] init];
		//create a scene immediately as the current scene;
		Scene* scene = [[Scene alloc] initWithName:@"Main Scene"];
		[director addScene:scene];
		director.currentScene = scene;
		
		
		
		Graphic* walkSheet = [[Graphic alloc] initWithFile:@"walking.png"];
		[scene addChild:walkSheet];
		walkSheet.pos = CGPointMake(100.0f, 180.0f);
		
		Sprite* container = [[Sprite alloc] init];
		[container centreAnchor];
		container.pos = CGPointMake(20.0f, 20.0f);
		[scene addChild:container];
		container.size = CGSizeMake(100.0f, 100.0f);
		//container.rotation = 25;
		
		Graphic* square = [[Graphic alloc] initWithFile:@"grey.jpg"];
		[container addChild:square];
		
		
		Animation* walk = [[Animation alloc] initWithFile:@"walking.png"];
		[container addChild:walk];
		walk.pos = CGPointMake(120.0f, 120.0f);
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[walk addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.2];
			trackX+=18.0f;
		}
		[walk centreAnchor];
		walk.size = CGSizeMake(17.0f, 31.0f);
		walk.repeat = YES;
		walk.pingpong = YES;
		[walk play];
		
		scene.rotation = 20;
    }
	
    return self;
}

- (void) layoutSubviews
{
	[[director renderer] resizeFromLayer:(CAEAGLLayer*)self.layer];
    [director mainLoop];
}


- (void) startAnimation
{
	[director startAnimation];
}

- (void)stopAnimation
{
	[director stopAnimation];
}

- (void) dealloc
{
    [director release];
	
    [super dealloc];
}

@end
