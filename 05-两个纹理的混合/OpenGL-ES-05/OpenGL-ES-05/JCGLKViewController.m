//
//  JCGLKViewController.m
//  OpenGL-ES-05
//
//  Created by chenjiangchuan on 16/7/23.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCGLKViewController.h"
#import "JCGLKVertexAttribArrayBuffer.h"

typedef struct {

    GLKVector3 positionCoords; // 位置坐标
    GLKVector2 textureCoords; // 纹理坐标

} SceneVertex; // 场景顶点

static const SceneVertex vertices[] = {

    // 第一个三角形
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    // 第二个三角形
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},

};

@interface JCGLKViewController ()

/** vertexBuffer */
@property (strong, nonatomic) JCGLKVertexAttribArrayBuffer *vertexBuffer;
/** base */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
/** 第一个纹理信息 */
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
/** 第二个纹理信息 */
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end

@implementation JCGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化OpenGL ES上下文和GLKBaseEffect
    [self setupGLK];
}

/**
 *  初始化OpenGL ES上下文和GLKBaseEffect
 */
- (void)setupGLK {

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view不是GLKView类型");

    // 创建OpenGL ES上下文，并设置OpenGL ES的版本信息
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置OpenGL ES上下文
    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    // 设置背景颜色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 标识符的生成、绑定、分配内存
    self.vertexBuffer = [[JCGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    // 设置纹理
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];

    /*
       GLKTextureLoaderOriginBottomLeft
        避免纹理上下颠倒，原因是纹理坐标系和世界坐标系的原点不同
     */
    NSDictionary *options = @{
        GLKTextureLoaderOriginBottomLeft : [NSNumber numberWithBool:YES],
    };
    // 设置纹理图片
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];

    // 开启混合
    glEnable(GL_BLEND);
    // 设置混合模式
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    // 清除背景颜色，并把背景颜色改为glClearColors设置的
    glClear(GL_COLOR_BUFFER_BIT);

    // 完成渲染数据的设置：启动，设置指针
    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];


    // 绘制树叶
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];


    // 绘制虫子
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = nil;

    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
