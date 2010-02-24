//
//  Renderer.m
//  GridEngine
//
//  Created by Liy on 10-2-21.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Renderer.h"


@implementation Renderer

- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		screenBounds = [[UIScreen mainScreen] bounds];
		
		//clear colour
		glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
		//disable depth test, 2D only
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		//setup projection
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		//Since the OpenGL is using bottom left as 0,0 origin, iPhone, MacOSX is using top left as origin.
		//we need to follow the iPhone screen's coordinate to specify the projection
		glOrthof(0.0f, screenBounds.size.width, screenBounds.size.height, 0.0f, -1.0f, 1.0f);
		//glOrthof(0.0f, screenBounds.size.width, 0.0f, screenBounds.size.height, -1.0f, 1.0f);
	}
	
	return self;
}

- (void)begin{
	// This application only creates a single context which is already set current at this point.
	// This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
    
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
    // Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
	glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
	
	// Clear the screen.  If we are going to draw a background image then this clear is not necessary
	// as drawing the background image will destroy the previous image
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Setup how the images are to be blended when rendered.  This could be changed at different points during your
	// render process if you wanted to apply different effects
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)render{
	
}

- (void)end{
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}
	
	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end
