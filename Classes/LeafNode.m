//
//  LeafNode.m
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "LeafNode.h"


@implementation LeafNode

@synthesize tintColor;

- (id)init{
	if (self = [super init]) {
		tvcQuad = calloc(1, sizeof(TVCQuad));
	}
	return self;
}

- (void)setPos:(CGPoint)aPos{
	[super setPos:aPos];
	
	tvcQuad[0].tl.vertices.x = pos.x;
	tvcQuad[0].tl.vertices.y = pos.y + size.height;
	tvcQuad[0].bl.vertices.x = pos.x;
	tvcQuad[0].bl.vertices.y = pos.y;
	tvcQuad[0].tr.vertices.x = pos.x + size.width;
	tvcQuad[0].tr.vertices.y = pos.y + size.height;
	tvcQuad[0].br.vertices.x = pos.x + size.width;
	tvcQuad[0].br.vertices.y = pos.y;
}

- (void)setSize:(CGSize)aSize{
	[super setSize:aSize];
	
	tvcQuad[0].tl.vertices.x = pos.x;
	tvcQuad[0].tl.vertices.y = pos.y + size.height;
	tvcQuad[0].bl.vertices.x = pos.x;
	tvcQuad[0].bl.vertices.y = pos.y;
	tvcQuad[0].tr.vertices.x = pos.x + size.width;
	tvcQuad[0].tr.vertices.y = pos.y + size.height;
	tvcQuad[0].br.vertices.x = pos.x + size.width;
	tvcQuad[0].br.vertices.y = pos.y;
}

- (void)setTintColor:(Color4f)aColor{
	tintColor = aColor;
	
	tvcQuad[0].tl.color = tintColor;
	tvcQuad[0].bl.color = tintColor;
	tvcQuad[0].tr.color = tintColor;
	tvcQuad[0].br.color = tintColor;
}

@end
