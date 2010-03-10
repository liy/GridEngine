//
//  Renderer.h
//  GridEngine
//
//  Created by Liy on 10-2-21.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "TextureManager.h"
#import "Scene.h"
#import "Common.h"

@interface Renderer : NSObject
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	CGRect screenBounds;
	
	Color4f clearColor;
}

@property (nonatomic, assign)Color4f clearColor;

- (void)begin;
- (void)end;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
