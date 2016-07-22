//
//  JCGLKVertexAttribArrayBuffer.m
//  OpenGL-ES-02
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCGLKVertexAttribArrayBuffer.h"

@implementation JCGLKVertexAttribArrayBuffer

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
                               usage:(GLenum)usage {

    if (self = [super init]) {

        self.stride = aStride;
        self.bufferSizeBytes = aStride * count;

        // 1.生成标识符
        glGenBuffers(1, &_name);

        // 2.绑定标识符
        glBindBuffer(GL_ARRAY_BUFFER, self.name);

        // 3.分配内存
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, data, usage);

        NSAssert(self.name != 0, @"生成的标识符有错");
    }

    return self;
}

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
                   shouldEnable:(BOOL)shouldEnable {

    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offsetPtr < self.stride);
    NSAssert(0 != self.name, @"Invalid name");

    glBindBuffer(GL_ARRAY_BUFFER, self.name);

    // 是否允许使用缓存中的数据
    if (shouldEnable) {
        // 4.开启
        glEnableVertexAttribArray(index);
    }

    // 5.设置指针
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offsetPtr);
}

/**
 *  把数据渲染到整个场景或者场景的某一部分
 *
 *  @param mode  处理数据的方式，整体分为点（GL_POINTS）、线（GL_LINES）、三角形（GL_TRIANGLES）
 *  @param first 需要渲染的第一个顶点的位置
 *  @param count 需要渲染的顶点的数量
 */
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count {

    // 6.绘图
    glDrawArrays(mode, first, count);
}

/**
 *  把数据渲染到整个场景或者场景的某一部分（等同drawPreparedArraysWithMode）
 *
 *  @param mode  处理数据的方式，整体分为点（GL_POINTS）、线（GL_LINES）、三角形（GL_TRIANGLES）
 *  @param first 需要渲染的第一个顶点的位置
 *  @param count 需要渲染的顶点的数量
 */
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count {

    NSAssert(self.bufferSizeBytes >=
             ((first + count) * self.stride),
             @"Attempt to draw more vertex data than available.");

    glDrawArrays(mode, first, count);
}

/**
 *  重新绑定，分配内存
 *
 *  @param stride  单个数据的大小
 *  @param count   数据的个数 = 数据的总大小 / 单个数据的大小
 *  @param dataPtr 要复制的数据的地址
 */
- (void)reinitWithAttribStride:(GLsizei)aStride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr {

    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != _name, @"Invalid name");

    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;

    // 绑定
    glBindBuffer(GL_ARRAY_BUFFER, self.name);

    // 分配内存，这里使用GL_DYNAMIC_DRAW，而不是GL_STATIC_DRAW，为了兼容
    glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}

/**
 *  重写dealloc方法
 */
- (void)dealloc
{
    // Delete buffer from current context
    if (0 != self.name) {
        // 7.删除缓存
        glDeleteBuffers (1, &_name);
        _name = 0;
    }
}

@end
