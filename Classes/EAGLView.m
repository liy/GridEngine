//
//  EAGLView.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright Bangboo 2010. All rights reserved.
//

#import "EAGLView.h"
#import "GEAnimation.h"
#import "GEDirector.h"
#import "GEContainer.h"
#import "GECommon.h"
#import "GESprite.h"

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
		
        director = [[GEDirector sharedDirector] init];
		//create a scene immediately as the current scene;
		GEScene* scene = [[GEScene alloc] initWithName:@"Main Scene"];
		[director addScene:scene];
		director.currentScene = scene;
		
		
		GEContainer* container = [[GEContainer alloc] init];
		[scene addChild:container];
		//container.rotation = 10;
		
		GESprite* q1 = [[GESprite alloc] initWithFile:@"grey.jpg"];
		q1.pos = CGPointMake(10, 10);
		[container addChild:q1];
		
		
		GESprite* q2 = [[GESprite alloc] initWithFile:@"grey.jpg"];
		q2.pos = CGPointMake(20, 20);
		q2.tintColor = Color4bMake(100, 255, 255, 255);
		[container addChild:q2];
		
		
		//CGRect box = [container boundingbox];
		GESprite* walk = [[GESprite alloc] initWithFile:@"walking.png"];
		walk.pos = CGPointMake(30.0f, 30.0f);
		[scene addChild:walk];
		 
		
		
		
		GESprite* mask1 = [[GESprite alloc] initWithFile:@"maskAlpha2.png"];
		mask1.pos = CGPointMake(40, 40);
		mask1.blendFunc = (BlendFunc){GL_ZERO,GL_ONE_MINUS_SRC_ALPHA};
		[scene addChild:mask1];
		
		
		GESprite* one = [[GESprite alloc] initWithFile:@"grass.png"];
		one.pos = CGPointMake(40, 40);
		one.blendFunc = (BlendFunc){GL_ONE_MINUS_DST_ALPHA,GL_DST_ALPHA};
		[scene addChild:one];
		
		
		
		
		
		
		
		/*
		animation = [[GEAnimation alloc] initWithFile:@"walking.png"];
		animation.pos = CGPointMake(40.0f, 40.0f);
		animation.anchor = CGPointMake(0.0, 0.0);
		animation.scaleX = 2;
		animation.scaleY = 2;

		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.5];
			trackX+=18.0f;
		}
		[animation play];
		animation.repeat = YES;
		animation.pingpong = YES;
		 */
		//[scene addChild:animation];
    }
	
    return self;
}

- (void)intervalCall:(float)delta{
	animation.rotation+=0.5;
	if (animation.rotation > 360.0) {
		[[GEScheduler sharedScheduler] remove:@selector(intervalCall:)];
	}
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
