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
		
		Graphic* g1 = [[Graphic alloc] initWithFile:@"walking.png"];
		g1.pos = CGPointMake(120.0f, 120.0f);
		g1.scaleX = 2;
		g1.scaleY = 2;
		g1.rotation = 45;
		//g1.anchor = CGPointMake(g1.contentSize.width/2, g1.contentSize.height/2);
		[g1 centreAnchor];
		
		[scene addChild:g1];
		
		Graphic* g2 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		//[g2 centreAnchor];
		//g2.pos = CGPointMake(60.0f, 60.0f);
		//g2.scaleX = 0.5;
		//g2.scaleY = 0.5;
		//g2.pos = CGPointMake(0.0f, 0.0f);
		[scene addChild:g2];
		
		Animation* animation = [[Animation alloc] initWithFile:@"walking.png"];
		animation.pos = CGPointMake(100.0f, 140.0f);
		animation.size = CGSizeMake(27.0f, 31.0f);
		//animation.scaleX = 2;
		//animation.scaleY = 2;
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.2];
			trackX+=18.0f;
		}
		[animation play];
		animation.repeat = YES;
		animation.pingpong = YES;
		[scene addChild:animation];
		
		//[scene setScaleX:2.0f];
		
		//scene.rotation = 20.0f;
		//scene.pos = CGPointMake(10.0f, 10.0f);
		
		//[scene setScaleY:2.0f];
		
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
