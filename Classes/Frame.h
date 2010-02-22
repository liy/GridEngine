//
//  Frame.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture2D;

@interface Frame : NSObject {
	float delay;
	CGRect rect;
	Texture2D* texRef;
}

@property (nonatomic)float delay;
@property (nonatomic, assign)Texture2D* texRef;
@property (nonatomic, readonly)CGRect rect;

- (id)initWithTex:(Texture2D*)aTexRef rect:(CGRect)aRect withDelay:(float)aDelay;

@end
