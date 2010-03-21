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
		
		GESprite* q0 = [[GESprite alloc] initWithFile:@"grass.png"];
		q0.pos = CGPointMake(5, 5);
		[container addChild:q0];
		
		GESprite* q1 = [[GESprite alloc] initWithFile:@"grass.png"];
		q1.pos = CGPointMake(25, 25);
		q1.tintColor = Color4bMake(255, 0, 0, 255);
		[container addChild:q1];
		
		GESprite* q2 = [[GESprite alloc] initWithFile:@"grass.png"];
		q2.pos = CGPointMake(45, 45);
		q2.blColor = Color4bMake(0, 0, 255, 200);
		q2.brColor = Color4bMake(0, 0, 255, 200);
		q2.tlColor = Color4bMake(100, 100, 255, 200);
		q2.trColor = Color4bMake(100, 100, 255, 200);
		//blend
		q2.blendFunc = (BlendFunc){GL_SRC_ALPHA, GL_ONE};
		[container addChild:q2];
		 
		GESprite* mask = [[GESprite alloc] initWithFile:@"maskAlpha.png"];
		mask.pos = CGPointMake(150, 100);
		GESprite* grass = [[GESprite alloc] initWithFile:@"grass.png"];
		grass.pos = CGPointMake(150, 100);
		grass.mask = mask;
		[scene addChild:grass];
		
		animation = [[GEAnimation alloc] initWithFile:@"walking.png"];
		animation.pos = CGPointMake(15, 200);
		animation.anchor = CGPointMake(0.0, 0.0);
		animation.scaleX = 3;
		animation.scaleY = 3;
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.5];
			trackX+=18.0f;
		}
		[animation play];
		animation.repeat = YES;
		animation.pingpong = YES;
		//should not be add to screen since it is used as a mask
		//[scene addChild:animation];
		GESprite* logo = [[GESprite alloc] initWithFile:@"logo.png"];
		logo.pos = CGPointMake(15, 200);
		//since the anmation's size is not matched with the logo size, if there is transparent pixels
		//under the mask sprite, that will causes some wired blend results.
		logo.mask = animation;
		[scene addChild:logo];
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
