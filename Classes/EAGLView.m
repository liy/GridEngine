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
		
		Graphic* q2 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		[scene addChild:q2];
		
		Graphic* q1 = [[Graphic alloc] initWithFile:@"grey.jpg"];
		q1.pos = CGPointMake(120, 120);
		q1.anchor = CGPointMake(1, 1);
		CGAffineTransform matrix = CGAffineTransformTranslate(CGAffineTransformIdentity, 120, 120);
		matrix = CGAffineTransformScale(matrix, 1, 0.5);
		matrix = CGAffineTransformRotate(matrix, DEGREES_TO_RADIANS(0));
		q1.transform = matrix;
		
		[scene addChild:q1];
		
		CGAffineTransform testMatrix = CGAffineTransformMake(5.3, 5.2, 
															 4.1, 7.4, 
															 10, 23);
		CGAffineTransform invertTrans = CGAffineTransformInvert(CGAffineTransformMakeTranslation(10.0, 23.0));
		testMatrix = CGAffineTransformConcat(testMatrix, invertTrans);
		q2.transform = testMatrix;
		NSLog(@"| %.1f  %.1f  0.0 |", testMatrix.a, testMatrix.b);
		NSLog(@"| %.1f  %.1f  0.0 |", testMatrix.c, testMatrix.d);
		NSLog(@"| %.1f  %.1f  1.0 |", testMatrix.tx, testMatrix.ty);
		
		
		/*
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
		 */
		
		
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
