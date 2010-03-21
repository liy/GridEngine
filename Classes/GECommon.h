/*
 *  Common.h
 *  GridEngine
 *
 *  Created by Liy on 10-2-19.
 *  Copyright 2010 Bangboo. All rights reserved.
 *
 */
#import <OpenGLES/ES1/gl.h>

#define DEGREES_TO_RADIANS(DEGREE) ((DEGREE) * M_PI / 180.0)
#define RADIANS_TO_DEGREES(RADIAN) ((RADIAN) * 180.0 / M_PI)

//offset calculate function to get a memory offset of a member inside a struct type, in bytes
//eg: offsetof(TVCPoint, texCoords) will be 0 bytes(There is no former member before texCoords in TVCPoint), 
//offsetof(TVCPoint, vertices) will be 8 bytes.(The former member is texCoords has 2 GLfloat, each of them is 4 bytes)
#define offsetof(TYPE, MEMBER) __builtin_offsetof (TYPE, MEMBER)

#define DEFAULT_BLEND_SRC GL_ONE
/// default gl blend dst function
#define DEFAULT_BLEND_DST GL_ONE_MINUS_SRC_ALPHA