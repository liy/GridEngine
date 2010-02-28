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
		
		Sprite* l1 = [[Sprite alloc] init];
		l1.rotation = 15;
		[scene addChild:l1];
		
		Sprite* l2 = [[Sprite alloc] init];
		l2.rotation = -15;
		[l1 addChild:l2];
		
		Sprite* l3 = [[Sprite alloc] init];
		l3.rotation = 15;
		[l2 addChild:l3];
		
		Graphic* graphic = [[Graphic alloc] initWithFile:@"grey.jpg"];
		
		[l3 addChild:graphic];
		graphic.pos = CGPointMake(100.0f, 0.0f);
		graphic.rotation = -15;
		
		CGRect box = [graphic boundingbox];
		NSLog(@"x:%.2f y:%.2f width:%.2f  height:%.2f", box.origin.x, box.origin.y, box.size.width, box.size.height);
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
