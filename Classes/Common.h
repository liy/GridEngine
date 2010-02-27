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

//A texture only has u and v property, note that the range is between 0.0f-1.0f
typedef struct _Tex2f {
	GLfloat u;
	GLfloat v;
} Tex2f;

//A vertex has x and y property.(z is not implemented yet)
typedef struct _Vertex2f {
	GLfloat x;
	GLfloat y;
} Vertex2f;

//TODO: change rgba type, reduce memory usage.
typedef struct _Color4f{
	GLfloat r;
	GLfloat g;
	GLfloat b;
	GLfloat a;
}Color4f;

//Short for texture vertices color point. means this struct contains all those informations.
typedef struct _TVCPoint
{
	//texture coordinate point define where the point is drew from. 8 bytes 
	Tex2f texCoords;
	
	//vertices define where to draw the point to. 8 bytes
	Vertex2f vertices;
	
	//the color tint of this point.  16 bytes
	Color4f color;
} TVCPoint;

//A rectangle struct contains 4 corners which contain all the texture, vertice and color information.
typedef struct _TVCQuad{
	
	//top left
	TVCPoint tl;
	//bottom left
	TVCPoint bl;
	//top right
	TVCPoint tr;
	//bottom right
	TVCPoint br; 
}TVCQuad;

typedef struct _VCPoint{
	//vertices define where to draw the point to. 8 bytes
	Vertex2f vertices;
	
	//the color tint of this point.  16 bytes
	Color4f color;
}VCPoint;

typedef struct _VCQuad{
	//top left
	VCPoint tl;
	//bottom left
	VCPoint bl;
	//top right
	VCPoint tr;
	//bottom right
	VCPoint br;
}VCQuad;

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f){red, green, blue, alpha};
}