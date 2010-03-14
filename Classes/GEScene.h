//
//  Scene.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GECollectionNode.h"

@interface GEScene : GECollectionNode {
	NSString* name;
}

@property (nonatomic, assign)NSString* name;

@end
