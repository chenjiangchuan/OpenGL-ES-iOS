//
//  JCGLKVertexAttribArrayBuffer.h
//  OpenGL-ES-02
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import <GLKit/GLKit.h>

// 顶点属性设置
typedef NS_ENUM(GLint, JCGLKVertexAttrib)
{
    JCGLKVertexAttribPosition = GLKVertexAttribPosition,
    JCGLKVertexAttribNormal = GLKVertexAttribNormal,
    JCGLKVertexAttribColor = GLKVertexAttribColor,
    JCGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    JCGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1
};

@interface JCGLKVertexAttribArrayBuffer : NSObject

/** 生成唯一的标识 */
@property (assign, nonatomic, readonly) GLuint name;
/** 缓存的大小的指针 */
@property (assign, nonatomic) GLsizeiptr bufferSizeBytes;
/** 单个缓存的大小 */
@property (assign, nonatomic) GLsizei stride;

/**
 *  完成缓冲区标识符的生成、绑定、和内存分配
 *
 *  @param stride  单个数据字节的大小
 *  @param count   数据的个数 = 数据的总大小 / 单个数据的大小
 *  @param dataPtr 要复制的数据的地址
 *  @param usage   提示了缓存在未来运算中可能将会被怎样使用
 *
 *  @return
 */
- (instancetype)initWithAttribStride:(GLsizei)aStride
                    numberOfVertices:(GLsizei)count
                                data:(const GLvoid *)data
                               usage:(GLenum)usage;

/**
 *  完成渲染数据的设置：启动，设置指针
 *
 *  @param index        指定顶点的位置
 *  @param count        指示每个位置有几个部分
 *  @param offsetPtr    告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据
 *  @param shouldEnable 渲染中是否使用缓存中的数据
 */
- (void)prepareToDrawWithAttrib:(JCGLKVertexAttrib)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offsetPtr
                   shouldEnable:(BOOL)shouldEnable;

/**
 *  把数据渲染到整个场景或者场景的某一部分
 *
 *  @param mode  处理数据的方式，整体分为点（GL_POINTS）、线（GL_LINES）、三角形（GL_TRIANGLES）
 *  @param first 需要渲染的第一个顶点的位置
 *  @param count 需要渲染的顶点的数量
 */
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;

/**
 *  把数据渲染到整个场景或者场景的某一部分（等同drawPreparedArraysWithMode）
 *
 *  @param mode  处理数据的方式，整体分为点（GL_POINTS）、线（GL_LINES）、三角形（GL_TRIANGLES）
 *  @param first 需要渲染的第一个顶点的位置
 *  @param count 需要渲染的顶点的数量
 */
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

/**
 *  重新绑定，分配内存
 *
 *  @param stride  单个数据的大小
 *  @param count   数据的个数 = 数据的总大小 / 单个数据的大小
 *  @param dataPtr 要复制的数据的地址
 */
- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

@end
