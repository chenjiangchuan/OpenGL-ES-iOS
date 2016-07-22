//
//  JCViewController.m
//  OpenGL-ES-02
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCViewController.h"
#import "JCGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

@implementation JCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化
    [self setupVertex];
}

- (void)setupVertex {

    // 获取View，设置上下文
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];

    // 设置GLKBaseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    // 设置背景颜色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 生成标识符，绑定，分配内存
    self.vertexBuffer = [[JCGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         data:vertices
                         usage:GL_STATIC_DRAW];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    // 告诉OpenGL-ES，已经准备好了，可以绘图了
    [self.baseEffect prepareToDraw];

    // 绘制背景色
    glClear(GL_COLOR_BUFFER_BIT);

    // 允许OpenGL-ES使用缓冲区的数据
    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];

    // 绘制
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    GLKView *view =(GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];

    self.vertexBuffer = nil;

    ((GLKView *)(self.view)).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
