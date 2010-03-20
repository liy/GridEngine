//
//  TextureManager.h
//  GridEngine
//
//  Created by Liy on 10-2-18.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "Texture2D.h"
#import "geTypes.h"
#import "geCommon.h"

@interface GETexManager : NSObject {
	GLuint boundedTex;
	NSMutableDictionary* texCache;
}

//The currently bounded texture in the OpenGL.
@property (nonatomic) GLuint boundedTex;

/**
 *Get the ResroucesManager for this game.
 *@return A TextureManager instance.
 */
+ (GETexManager*)sharedTextureManager;

/**
 * Get the Texture2D object using the exact file name of the image. 
 * If the Texture2D is not in the TextureManager, create a new one and return it.
 * @param fileName The file name of the image for Texture2D to load.
 * @return A Texture2D object managed by this TextureManager.
 */
- (Texture2D*)getTexture2D:(NSString*)fileName;

/**
 * Remove the Texture2D specified by file name from this TextureManager.
 * @param fileName The file name, the key to remove the Texture2D object.
 * @return A Texture2D object if it is sucessfully removed, or nil fail to remove.
 */
- (Texture2D*)removeTexture2D:(NSString*)fileName;

/**
 * Clear all the Texture2D objects managed by this TextureManager.
 */
- (void)clear;

@end
