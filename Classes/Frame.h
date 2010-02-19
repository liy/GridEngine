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
	float duration;
	CGRect content;
	Texture2D* texRef;
}

@property (nonatomic)float duration;
@property (nonatomic, assign)Texture2D* texRef;
@property (nonatomic, readonly)CGRect content;

- (id)initWithTex:(Texture2D*)aTexRef rect:(CGRect)rect withDuration:(float)aDuration;

@end
