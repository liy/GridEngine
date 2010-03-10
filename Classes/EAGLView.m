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
		
		
		Sprite* container = [[Sprite alloc] init];
		[scene addChild:container];
		
		Graphic* q1 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		q1.pos = CGPointMake(120, 120);
		q1.scaleX = 0.5;
		q1.scaleY = 0.5;
		q1.rotation = 45;
		
		//q1.transform = matrix;
		[container addChild:q1];
		
		
		Graphic* q2 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		[container addChild:q2];
		container.scaleX = 0.5;
		container.scaleY = 0.5;
		container.size = CGSizeMake(90, 90);
		
		
		NSLog(@"container contentSize width:%.2f height:%.2f", container.contentSize.width, container.contentSize.height);
		
		CGRect box = [container boundingbox];
		NSLog(@"container bouding box width:%.2f height:%.2f", box.size.width, box.size.height);
		Graphic* walk = [[Graphic alloc] initWithFile:@"walking.png"];
		walk.pos = CGPointMake(box.origin.x+box.size.width, box.origin.y+box.size.height);
		//walk.rect = CGRectMake(0.0, 0.0, 17, 31);
		[scene addChild:walk];
		
		
		Graphic* indicator = [[Graphic alloc] initWithFile:@"grey.jpg"];
		indicator.size = CGSizeMake(5, 5);
		indicator.pos = CGPointMake(90, 90);
		[scene addChild:indicator];
		
		
		animation = [[Animation alloc] initWithFile:@"walking.png"];
		animation.pos = CGPointMake(121.0f, 121.0f);
		animation.anchor = CGPointMake(0.0, 1.0);
		animation.scaleX = -1.0;
		float trackX = 0.0f;
		for (int i=0; i<3; ++i) {
			if (i == 2) {
				[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 21.0f) withDelay:0.5];
			}
			else {
				[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.5];
			}

			
			trackX+=18.0f;
		}
		[animation play];
		animation.repeat = YES;
		animation.pingpong = YES;
		animation.tlColor = Color4fMake(255, 0, 0, 255);
		[scene addChild:animation];
		
		
		/*
		 NSLog(@"Origianl===================================");
		 CGAffineTransform t = CGAffineTransformMakeTranslation(1.0, 1.0f);
		 CGAffineTransform r = CGAffineTransformMakeRotation(M_PI/2);
		 
		 NSLog(@"| %.1f  %.1f  0.0 |", t.a, t.b);
		 NSLog(@"| %.1f  %.1f  0.0 |", t.c, t.d);
		 NSLog(@"| %.1f  %.1f  1.0 |", t.tx, t.ty);
		 
		 NSLog(@"Rotation===================================");
		 
		 NSLog(@"| %.1f  %.1f  0.0 |", r.a, r.b);
		 NSLog(@"| %.1f  %.1f  0.0 |", r.c, r.d);
		 NSLog(@"| %.1f  %.1f  1.0 |", r.tx, r.ty);
		 
		 NSLog(@"Concated===================================");
		 CGAffineTransform n = CGAffineTransformRotate(t, M_PI/2);
		 
		 NSLog(@"| %.1f  %.1f  0.0 |", n.a, n.b);
		 NSLog(@"| %.1f  %.1f  0.0 |", n.c, n.d);
		 NSLog(@"| %.1f  %.1f  1.0 |", n.tx, n.ty);
		 
		 NSLog(@"TR ===========================================");
		 CGAffineTransform tr = CGAffineTransformConcat(t, r);
		 
		 CGPoint trp = CGPointApplyAffineTransform(CGPointMake(1.0, 1.0), tr);
		 NSLog(@"tr x' = %.1f", trp.x);
		 NSLog(@"tr y' = %.1f", trp.y);
		 
		 NSLog(@"RT ===========================================");
		 CGAffineTransform rt = CGAffineTransformConcat(r, t);
		 
		 CGPoint rtp = CGPointApplyAffineTransform(CGPointMake(1.0, 1.0), rt);
		 NSLog(@"rt x' = %.1f", rtp.x);
		 NSLog(@"rt y' = %.1f", rtp.y);
		 
		 NSLog(@"TR matrix ============================================");
		 NSLog(@"| %.1f  %.1f  0.0 |", tr.a, tr.b);
		 NSLog(@"| %.1f  %.1f  0.0 |", tr.c, tr.d);
		 NSLog(@"| %.1f  %.1f  1.0 |", tr.tx, tr.ty);
		 
		 NSLog(@"RT matrix ============================================");
		 NSLog(@"| %.1f  %.1f  0.0 |", rt.a, rt.b);
		 NSLog(@"| %.1f  %.1f  0.0 |", rt.c, rt.d);
		 NSLog(@"| %.1f  %.1f  1.0 |", rt.tx, rt.ty);
		 */
		//[[GEScheduler sharedScheduler] addTarget:self sel:@selector(intervalCall:) interval:0.001];
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
