//
//  JCViewController.m
//  OpenGL-ES-01
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCViewController.h"

typedef struct {
    // 顶点坐标
    GLKVector3  positionCoords;
} SceneVertex;

// 绘制一个三角形，所以有3个顶点的坐标x/y/z，坐标的取值范围从 0.0 - 1.0
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}},
    {{0.5f, -0.5f, 0.0}},
    {{-0.5f, 0.5f, 0.0}},
};

@interface JCViewController ()
{
    /** 数据缓存到OpenGL-ES的唯一标识 */
    GLuint vertexBufferID;
}

/** 
    GLKBaseEffect 的存在是为了简化OpenGL ES的很多常用操作。
    GLKBaseEffect 隐藏了iOS设备支持的多个OpenGL ES版本之间的差异。
    在应用中使用 GLKBaseEffect 能减少需要编写的代码量
 
    省去了Shading Language程序开发
 */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end

@implementation JCViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    // 初始化相关工作
    [self setupGLK];
}

/**
 *  初始化相关工作
 */
- (void)setupGLK {

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"viewController's view is not a GLKView");

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    [EAGLContext setCurrentContext:view.context];

    /*
        GLKBaseEffect类提供了不依赖于所使用的OpenGL ES版本的控制OpenGL ES渲染的方法
     */
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    // 控制渲染像素颜色
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    // 设置当前OpenGL ES的上下文的“清除颜色”为不透明黑色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 1.生成 - 请求OpenGL ES为GPU控制的缓存生成一个独一无二的标识符
    glGenBuffers(1, &vertexBufferID);


    /*
        2.绑定 - 告诉OpenGL ES为接下来的运算使用一个缓存
        glBindBuffer (GLenum target, GLuint buffer);
     
     target：要绑定哪一种类型的缓存；OpenGL ES 2.0对glBindBuffer()的实现只支持两种类型的缓存；
        GL_ARRAY_BUFFER 和 GL_ELEMENT_ARRAY_BUFFER
     GL_ARRAY_BUFFER：用于指定一个顶点属性数组，比如这里三角形顶点的位置。
     
     buffer：要绑定的缓存的标识符
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);


    /*
        3.缓存数据 - 让OpenGL ES为当前绑定的缓存分配并初始化足够的连续内存
     
        glBufferData函数复制应用的顶点数据到当前上下文所绑定的顶点缓存中
        
        glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage);
     
        target：指定要更新上下文中所绑定的是哪一种类型的缓存；
        size：指定要复制进这个缓存的字节的数量；
        data：要复制的字节的地址；
        usage：提示了缓存在未来运算中可能将会被怎样使用；
            GL_STATIC_DRAW：告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对其进行修改。
            GL_DYNAMIC_DRAW：告诉上下文，缓存内的数据会频繁改变，同时提示OpenGL ES以不同的方式来处理缓存的存储。
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}


/**
 *  重绘GLKView
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    /*
     告诉当前OpenGL-ES的上下文，baseEffect准备好了，以便为使用baseEffect生成的属性和
     Shading Language程序的绘图做好准备。
     */
    [self.baseEffect prepareToDraw];

    /**
     设置当前绑定的帧缓存的像素颜色，
     渲染缓存中的每一个像素的颜色为前面使用glClearColor()函数设定的值

     glClear()函数会有效地设置帧缓存中的每一个像素的颜色为背景色
     */
    glClear(GL_COLOR_BUFFER_BIT);

    // 4.启动 - 告诉OpenGL ES在接下来的渲染中是否使用缓存中的数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);

    /*
     5.设置指针 - 告诉OpenGL ES顶点数据在哪里,以及怎么解释为每个顶点保存的数据

     glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)

     indx：指示当前绑定的缓存包含每个顶点的位置信息；
     size：指示每个位置有 3 个部分；
     type：每个部分都保存为一个浮点类型的值；
     normalized：小数点固定数据是否可以被改变；
     stride：它指定了每个顶点的保存需要多少个字节；
     ptr：告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据。
     */
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);

    /*
     6.绘图 - 告诉OpenGL ES使用当前绑定并启动的缓存中的数据渲染整个场景或者某个场景的一部分

     glDrawArrays (GLenum mode, GLint first, GLsizei count);

     mode：告诉GPU怎么处理在绑定的顶点缓存内的顶点数据；
     first：缓存内需要渲染的第一个顶点的位置；
     count：需要渲染的顶点的数量
     */
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

/**
 *  view消失的时候要删除缓存区的数据
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    GLKView *view = (GLKView *)self.view;

    [EAGLContext setCurrentContext:view.context];

    if (vertexBufferID != 0) {
        // 7.删除 - 告诉OpenGL ES删除以前生成的缓存并释放相关的资源
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }

    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
