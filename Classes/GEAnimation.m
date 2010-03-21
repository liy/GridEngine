//
//  Animation.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "GEAnimation.h"
#import "GEDirector.h"

// This GEFrame class is for GEAnimation only.
@implementation GEFrame

@synthesize delay;
@synthesize texName;
@synthesize rect;

- (id)initWithTexName:(GLuint)aName rect:(CGRect)aRect withDelay:(float)aDelay{
	if (self = [super init]) {
		delay = aDelay;
		rect = aRect;
		texName = aName;
	}
	return self;
}

@end


@implementation GEAnimation

@synthesize pingpong;
@synthesize repeat;
@synthesize stopped;
@synthesize direction;
@synthesize defaultDelay;

- (id)initWithFile:(NSString*)aName{
	if (self = [super initWithFile:aName]) {
		frames = [[NSMutableArray alloc] initWithCapacity:5];

		currentFrameIndex = 0;
		
		pingpong = NO;
		
		repeat = NO;
		
		stopped = YES;
		
		direction = ani_forward;
		
		frameTimer = 0;
		
		defaultDelay = 1.0/2.0;
		
		firstRound = YES;
		
		contentSize = CGSizeMake(0.0f, 0.0f);
	}
	return self;
}

- (void)dealloc{
	[frames release];
	[super dealloc];
}

- (void)addFrame:(CGRect)aRect{
	[self addFrame:aRect texture:texRef withDelay:defaultDelay];
}

- (void)addFrame:(CGRect)aRect named:(NSString*)aName{
	Texture2D* tex = [texManager getTexture2D:aName];
	
	[self addFrame:aRect texture:tex withDelay:defaultDelay];
}

- (void)addFrame:(CGRect)aRect withDelay:(float)aDelay{
	[self addFrame:aRect texture:texRef withDelay:aDelay];
}

- (void)addFrame:(CGRect)aRect named:(NSString*)aName withDelay:(float)aDelay{
	Texture2D* tex = [texManager getTexture2D:aName];
	
	[self addFrame:aRect texture:tex withDelay:aDelay];
}

- (void)addFrame:(CGRect)aRect texture:(Texture2D*)tex withDelay:(float)aDelay{
	//Since the contentSize will be zero at the beginning.
	//If contentSize is zero, the scaleX and scaleY will not be able to correctly calculated.
	//Since scaleX = size.width/contentSize.height, the result will be infinity.
	if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
		contentSize = aRect.size;
		self.size = CGSizeMake(self.contentSize.width*scaleX, self.contentSize.height*scaleY);
	}
	
	GEFrame* frame = [[GEFrame alloc] initWithTexName:tex.name rect:aRect withDelay:aDelay];
	[frames addObject:frame];
	[frame release];
}

- (GEFrame*)getFrame:(uint)frameIndex{
	return [frames objectAtIndex:frameIndex];
}

- (GEFrame*)getCurrentFrame{
	if ([frames count] == 0) {
		return nil;
	}
	return [frames objectAtIndex:currentFrameIndex];
}

- (void)reset{
	//stop update frame.
	stopped = YES;
	frameTimer = 0.0;
	firstRound = YES;
	currentFrameIndex = 0;
}

- (void)stop{
	stopped = YES;
	frameTimer = 0.0;
}


- (void)play{
	stopped = NO;
}

- (void)gotoAndPlay:(uint)index{
	if (index < [frames count]) {
		stopped = NO;
		frameTimer = 0.0;
		currentFrameIndex = index;
	}
}

- (void)gotoAndStop:(uint)index{
	if (index < [frames count]) {
		stopped = YES;
		frameTimer = 0.0;
		currentFrameIndex = index;
	}
}

- (void)setDirection:(int)aDir{
	if (aDir>=0) {
		direction = ani_forward;
	}
	else {
		direction = ani_backword;
	}

}

- (void)updateAnimation{
	//update the frame according to the delta time.
	if (!stopped) {
		frameTimer += [[GEDirector sharedDirector] delta];
		
		if (frameTimer > [[frames objectAtIndex:currentFrameIndex] delay]) {
			//go to next frame
			currentFrameIndex+=direction;
			frameTimer = 0;
			
			//frame number is exceed limit
			if (currentFrameIndex>([frames count]-1) || currentFrameIndex<0) {
				//keep repeat and pingpong, never stop
				if(pingpong && repeat){
					direction*=-1;
					//"direction*2" makes sure the last frame or the first frame do not render twice.
					//See below pingpoing && !repeat case.
					currentFrameIndex+=direction*2;
				}
				//only pingpong once.
				else if(pingpong && !repeat){
					//exceeded the index bound for the first time, still need pingpong once.
					if (firstRound) {
						direction*=-1;
						firstRound = NO;
						
						//Reset the current frame to the previous frame immediately.
						//For example, if animation started using ani_forward, at this point, direction will be -1, currentFrameIndex will be [frames count].
						//However since frame index [frames count]-1 is already rendered for its delay time period. we need to jump to [frame count]-2,
						//the new currentFrameIndex = [frame count] + -1*2.
						//If animation started using ani_backward, at this point, direction will be 1, currentFrameIndex will be -1. Since frame 0 is 
						//already rendered for it delay time period, we need to directly jump to frame 1 which is: currentFrameIndex = -1 + 1*2. Both cases
						//are correct.
						currentFrameIndex+=direction*2;
					}
					//exceeded frames index bounds again. stop the animation
					else {
						//next round start the animation, means a new round.
						firstRound = YES;
						stopped = YES;
						
						//because at this point the currentFramIndex is out of bounds already.
						//It can be -1 or [frames count], this further calculation makes sure the frame is not out of bounds.
						//For example, if animation started using ani_forward, at this point, direction will be -1,
						//currentFrameIndex will be -1, so the new currentFrameIndex = -1 - -1 which will be 0. 
						//If animation started using ani_backward, at this point, direction will be 1, currentFrameIndex will be [frames count].
						//So the new currentFrameIndex = [frames count]-1. Both casese are correct.
						currentFrameIndex -= direction;
					}
				}
				//go back to start frame
				else if(!pingpong && repeat){
					if (direction == ani_forward) {
						currentFrameIndex = 0;
					}
					else {
						currentFrameIndex = [frames count]-1;
					}
				}
				//stop
				else {
					stopped = YES;
					//stop at last valid frame.
					currentFrameIndex -= direction;
				}
			}
		}
	}
}

- (void)traverse{
	//first we need to update the frams in this animation.
	[self updateAnimation];
	
	GEFrame* frame = [frames objectAtIndex:currentFrameIndex];
	//change contentSize
	contentSize = CGSizeMake(frame.rect.size.width, frame.rect.size.height);
	//since we updated the contentSize, the anchor point is calculated based on the contentSize.
	//we need to simply set the anchor point again.
	self.anchor = CGPointMake(anchor.x, anchor.y);
	
	//Finished updating the animation
	//super class will fire draw method
	[super traverse];
}

- (BOOL)draw{
	//super class will decide whether to draw this node.
	if ([super draw]) {
		//set the draw rect to the new frame rect
		GEFrame* frame = [frames objectAtIndex:currentFrameIndex];
		//update the rect with current frame's rect
		self.rect = [frame rect];
		
		if (immediateMode) {
			[[GESpriteBatch sharedSpriteBatch] batchNode:self];
			return YES;
		}
		
		//save the current matrix
		glPushMatrix();
		
		//enable to use coords array as a source texture
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		
		//enable texture 2d
		glEnable(GL_TEXTURE_2D);
		
		//bind the texture.
		//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
		if (texManager.boundedTex != frame.texName) {
			glBindTexture(GL_TEXTURE_2D, frame.texName);
			texManager.boundedTex = frame.texName;
		}
		else {
			//NSLog(@"Image already binded");
		}
		
		//get the start memory address for the tvcQuad struct.
		//Note that tvcQuad is defined as array, we need to access the actual tvcQuad memory address using normal square bracket.
		//int addr = (int)&tvcQuad[0];
		int addr = (int)&tvcQuads[0];
		//calculate the memory location offset, should be 0. Since there is nothing before texCoords property of TVCQuad.
		int offset = offsetof(TVCPoint, texCoords);
		//set the texture coordinates we what to render from. (positions on the Texture2D generated image)
		glTexCoordPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr));
		
		//memory offset to define the start of vertices. Should be sizeof(texCoords) which is 8 bytes(2 GLfloat each for 4 bytes).
		offset = offsetof(TVCPoint, vertices);
		//set the target vertices which define the area we what to draw the texture.
		glVertexPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr + offset));
		
		//offset to define the start of color array. Before this property we have texCoords(u & v GLfloat) 
		//and vertices(x & y GLfloat) which are 16 bytes.
		offset = offsetof(TVCPoint, color);
		//set the color tint array for the texture.
		glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(TVCPoint), (void*)(addr + offset));
		
		//enable blend
		glEnable(GL_BLEND);
		
		//draw the image
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		//disable
		glDisable(GL_BLEND);
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
		glPopMatrix();
		return YES;
	}
	return NO;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | TextureName=%d, Rect = (%.2f,%.2f,%.2f,%.2f)>, Pos=<%.2f,%.2f>", [self class], self,
			texRef.name,
			rect.origin.x,
			rect.origin.y,
			rect.size.width,
			rect.size.height,
			pos.x,
			pos.y];
}

@end
