//
//  Frame.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture2D;

/**
 * Describe an Animation frame.
 */
@interface Frame : NSObject {
	//How many seconds should this frame be on the screen. 
	float delay;
	//Define the draw region on the texture 
	CGRect rect;
	//The texture2D reference. It might be different to the Animation's texRef.
	//Frame can have a different texRef.
	Texture2D* texRef;
}

@property (nonatomic)float delay;
@property (nonatomic, assign)Texture2D* texRef;
@property (nonatomic, readonly)CGRect rect;

- (id)initWithTex:(Texture2D*)aTexRef rect:(CGRect)aRect withDelay:(float)aDelay;

@end
