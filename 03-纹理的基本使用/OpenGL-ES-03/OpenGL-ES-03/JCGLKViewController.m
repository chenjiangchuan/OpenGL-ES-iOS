//
//  JCGLKViewController.m
//  OpenGL-ES-03
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCGLKViewController.h"
#import "JCGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords; // 顶点坐标系
    GLKVector2 textureCoords; // 纹理坐标系
} SceneVertor;

static const SceneVertor vertices[] = {
    // 前3个是顶点坐标x/y/z，后面2个是顶点坐标对应的纹理U/V的坐标
    {{-0.5f, -0.5f, 0.0}, {0.0f, 0.0f}},
    {{0.5f, -0.5f, 0.0}, {1.0f, 0.0f}},
    {{-0.5f, 0.5f, 0.0}, {0.0f, 1.0f}},
};

@interface JCGLKViewController ()

/** Vertex */
@property (strong, nonatomic) JCGLKVertexAttribArrayBuffer *vertexBuffer;
/** GLKBaseEffect */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end

@implementation JCGLKViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化vertexBuffer
    [self setupVertexBuffer];
}

/**
 *  初始化vertexBuffer
 */
- (void)setupVertexBuffer {

    // 设置OpenGL ES上下文
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view不是GLKView");
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];

    // 设置baseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    // 设置背景色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 生成标识符，绑定，分配内存
    self.vertexBuffer = [[JCGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertor) numberOfVertices:sizeof(vertices) / sizeof(SceneVertor) bytes:vertices usage:GL_STATIC_DRAW];

    // 设置纹理，这里图片的文字一定要带上后缀，否则运行崩溃
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];

    /**
     *  GLKTextureLoader会自动调用glTexParameteri()方法为创建的纹理缓存设置OpenGL ES
        取样和循环模式
     */
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];

    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    [self.baseEffect prepareToDraw];

    // 清除背景色，并把背景色设置为glClearColor设置的背景颜色
    glClear(GL_COLOR_BUFFER_BIT);

    // 允许使用缓冲区顶点数据，设置指针
    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertor, positionCoords) shouldEnable:YES];

    // 允许使用缓冲区纹理数据，设置指针
    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertor, textureCoords) shouldEnable:YES];

    // 绘图
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];

    self.vertexBuffer = nil;
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
