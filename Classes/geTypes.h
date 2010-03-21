/*
 *  geTypes.h
 *  GridEngine
 *
 *  Created by Liy on 10-3-17.
 *  Copyright 2010 Bangboo. All rights reserved.
 *
 */

//define the blend function 
typedef struct _blendFunc{
	GLenum src;
	GLenum dst;
}BlendFunc;

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

//A color r g b a, value from 0-255, 1 byte for each channel.
typedef struct _Color4b{
	GLubyte r;
	GLubyte g;
	GLubyte b;
	GLubyte a;
}Color4b;

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
	
	//the color tint of this point.  4 bytes
	Color4b color;
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
	Color4b color;
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

static inline Color4b Color4bMake(GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha)
{
	return (Color4b){red, green, blue, alpha};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f){red, green, blue, alpha};
}