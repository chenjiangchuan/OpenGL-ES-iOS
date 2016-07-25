//
//  JCGLKViewController.m
//  OpenGL-ES-06
//
//  Created by chenjiangchuan on 16/7/25.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCGLKViewController.h"
#import "JCGLKVertexAttribArrayBuffer.h"

typedef struct {

    GLKVector3 positionCoords;
    GLKVector2 textureCoords;

} SceneVertex;

const static SceneVertex vertices[] = {

    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

@interface JCGLKViewController ()

/** baseEffect */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
/** vertexBuffer */
@property (strong, nonatomic) JCGLKVertexAttribArrayBuffer *vertexBuffer;

@end

@implementation JCGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化GLK
    [self setupGLK];
}

/**
 *  初始化GLK
 */
- (void)setupGLK {

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view 不是 GLKView");

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 标识符生成、绑定、内存分配
    self.vertexBuffer = [[JCGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         data:vertices
                         usage:GL_STATIC_DRAW];

    // 设置纹理
    [self setupTexture];
}

/**
 *  设置纹理
 */
- (void)setupTexture {

    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];

    NSDictionary *options = @{
                              GLKTextureLoaderOriginBottomLeft : [NSNumber numberWithBool:YES],
                              };

    GLKTextureInfo *info0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    GLKTextureInfo *info1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];

    self.baseEffect.texture2d0.name = info0.name;
    self.baseEffect.texture2d0.target = info0.target;

    self.baseEffect.texture2d1.name = info1.name;
    self.baseEffect.texture2d1.target = info1.target;
    // 设置多重纹理模式
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClear(GL_COLOR_BUFFER_BIT);

    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];

    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];

    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];

    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];

    // Delete buffers that aren't needed when view is unloaded
    self.vertexBuffer = nil;

    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
