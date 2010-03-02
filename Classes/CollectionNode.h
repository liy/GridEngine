//
//  CollectionNode.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"


@interface CollectionNode : Node {
	NSMutableArray* children;
}

@property (nonatomic, assign)NSMutableArray* children;

@end
