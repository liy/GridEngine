//
//  LeafNode.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "TextureManager.h"
#import "Common.h"

@interface LeafNode : Node {
	//Define an array of TVCQuad contains texture, vertices, color information
	TVCQuad* tvcQuad;
	
	//rgba
	Color4f tintColor;
}

//apply tint color.
@property (nonatomic, assign)Color4f tintColor;

@end
