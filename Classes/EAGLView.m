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
		//l1.rotation = 15;
		[scene addChild:l1];
		
		Sprite* l2 = [[Sprite alloc] init];
		//l2.rotation = 15;
		[l1 addChild:l2];
		
		Sprite* l3 = [[Sprite alloc] init];
		//l3.rotation = 15;
		[l2 addChild:l3];
		
		Graphic* square1 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		[l3 addChild:square1];
		
		
		Graphic* square2 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		square2.pos = CGPointMake(130.0f, 0.0f);
		[l3 addChild:square2];
		
		Graphic* square3 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		square3.pos = CGPointMake(130.0f, 130.0f);
		[l3 addChild:square3];
		
		CGAffineTransform matrix = CGAffineTransformIdentity;
		matrix = CGAffineTransformScale(matrix, 0.5, 0.5);
		//matrix = CGAffineTransformRotate(matrix, M_PI/4);
		l3.transform = matrix;
		l3.anchor = CGPointMake(125, 125);
		l3.pos = CGPointMake(125, 125);
		//l3.size = CGSizeMake(320, 320);
		
		
		NSLog(@"x:%.2f y:%.2f width:%.2f  height:%.2f", l3.pos.x, l3.pos.y, l3.size.width, l3.size.height);
		
		NSLog(@"========");
		
		//[l3 centreAnchor];
		//l3.anchor = CGPointMake(120, 120);
		
		NSLog(@"========");

		
		Animation* animation = [[Animation alloc] initWithFile:@"walking.png"];
		animation.pos = CGPointMake(125.0f, 125.0f);
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 30.0f) withDelay:0.1];
			trackX+=18.0f;
		}
		[animation play];
		animation.repeat = YES;
		animation.pingpong = YES;
		[scene addChild:animation];
		animation.size = CGSizeMake(30, 30);
		CGRect box = [l3 boundingbox];
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
