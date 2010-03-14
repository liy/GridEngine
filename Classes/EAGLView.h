//
//  EAGLView.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright Bangboo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "GEDirector.h"
#import "GEAnimation.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{	
	GEDirector* director;
	NSTimer* timer;
	GEAnimation* animation;
}

- (void)layoutSubviews;
- (void)startAnimation;
- (void)stopAnimation;

@end
