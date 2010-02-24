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
		
		
		//Graphic* graphic = [[Graphic alloc] initWithFile:@"walking.png"];
		//[scene addChild:graphic];
		
		
		Animation* animation = [[Animation alloc] initWithFile:@"walking.png"];
		
		animation.pos = CGPointMake(0.0f, 0.0f);
		animation.size = CGSizeMake(17.0f, 31.0f);
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.2];
			trackX+=18.0f;
		}
		
		animation.repeat = YES;
		animation.pingpong = YES;
		[animation play];
		//[animation gotoAndPlay:1];
		//animation.trColor = Color4fMake(0.0f, 1.0f, 0.0f, 1.0f);
		//animation.brColor = Color4fMake(1.0f, 0.0f, 0.0f, 1.0f);
		[scene addChild:animation];
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
