//
//  Animation.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Animation.h"
#import "Frame.h"
#import "Director.h"


@implementation Animation

@synthesize pingpong;
@synthesize repeat;
@synthesize running;
@synthesize direction;
@synthesize defaultDelay;

- (id)initWithFile:(NSString*)aName{
	if (self = [super initWithFile:aName]) {
		frames = [[NSMutableArray alloc] initWithCapacity:5];

		currentFrameIndex = 0;
		
		pingpong = NO;
		
		repeat = NO;
		
		running = NO;
		
		direction = ani_forward;
		
		frameTimer = 0;
		
		defaultDelay = 1.0/2.0;
		
		firstRound = YES;
		
		
		NSLog(@"animation finished");
	}
	return self;
}

- (void)addFrame:(CGRect)aRect{
	Frame* frame = [[Frame alloc] initWithTex:texRef rect:aRect withDelay:defaultDelay];
	[frames addObject:frame];
	[frame release];
	
}

- (void)addFrame:(CGRect)aRect named:(NSString*)aName{
	Texture2D* tex = [texManager getTexture2D:aName];
	Frame* frame = [[Frame alloc] initWithTex:tex rect:aRect withDelay:defaultDelay];
	[frames addObject:frame];
	[frame release];
}

- (void)addFrame:(CGRect)aRect withDelay:(float)aDelay{
	Frame* frame = [[Frame alloc] initWithTex:texRef rect:aRect withDelay:aDelay];
	[frames addObject:frame];
	[frame release];
}

- (void)addFrame:(CGRect)aRect named:(NSString*)aName withDelay:(float)aDelay{
	Texture2D* tex = [texManager getTexture2D:aName];
	Frame* frame = [[Frame alloc] initWithTex:tex rect:aRect withDelay:aDelay];
	[frames addObject:frame];
	[frame release];
}

- (void)draw{
	//update the frame rectangle according to the delta time.
	if (running) {
		frameTimer += [[Director sharedDirector] delta];
		
		if (frameTimer > [[frames objectAtIndex:currentFrameIndex] delay]) {
			//go to next frame
			currentFrameIndex+=direction;
			frameTimer = 0;
			
			//frame number is exceed limit
			if (currentFrameIndex>([frames count]-1) || currentFrameIndex<0) {
				//keep repeat and pingpong, never stop
				if(pingpong && repeat){
					direction*=-1;
					currentFrameIndex+=direction;
				}
				//only pingpong once.
				else if(pingpong && !repeat){
					direction*=-1;
					if (firstRound) {
						firstRound = NO;
						currentFrameIndex+=direction;
					}
					else {
						firstRound = YES;
						running = NO;
						currentFrameIndex = 0;
					}
				}
				//go back to first frame
				else if(!pingpong && repeat){
					currentFrameIndex = 0;
				}
				//stop
				else {
					running = NO;
					currentFrameIndex = 0;
				}
			}
			//NSLog(@"next frame %u",currentFrameIndex);
		}
	}
	
	
	//set the draw rect to the new frame rect
	self.rect = [[frames objectAtIndex:currentFrameIndex] rect];
	
	NSLog(@"%@", [self description]);
	
	
	//save the current matrix
	glPushMatrix();
	
	//enable to use coords array as a source texture
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	//enable texture 2d
	glEnable(GL_TEXTURE_2D);
	
	//bind the texture.
	//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
	if (texManager.boundedTex != [texRef name]) {
		glBindTexture(GL_TEXTURE_2D, [texRef name]);
		texManager.boundedTex = [texRef name];
	}
	else {
		//NSLog(@"Image already binded");
	}
	
	glTranslatef(pos.x, pos.y, 0);
	glRotatef(rotation, 0.0f, 0.0f, 1.0f);
	glTranslatef(-pos.x, -pos.y, 0);
	
	//get the start memory address for the tvcQuad struct.
	//Note that tvcQuad is defined as array, we need to access the actual tvcQuad memory address using normal square bracket.
	int addr = (int)&tvcQuad[0];
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
	glColorPointer(4, GL_FLOAT, sizeof(TVCPoint), (void*)(addr + offset));
	
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
}



@end
