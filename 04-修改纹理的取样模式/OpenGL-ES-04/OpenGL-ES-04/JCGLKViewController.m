//
//  JCGLKViewController.m
//  OpenGL-ES-04
//
//  Created by chenjiangchuan on 16/7/22.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "JCGLKViewController.h"
#import "JCGLKVertexAttribArrayBuffer.h"
#import "GLKEffectPropertyTexture+SettingTexture.h"

typedef struct {

    GLKVector3 positionCoords;
    GLKVector3 textureCoords;

} SceneVertex;

static SceneVertex vertices[] = {

    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},

};

static const SceneVertex defaultVertices[] = {

    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},

};

static GLKVector3 movementVectors[3] = {

    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
    
};

@interface JCGLKViewController ()

/** baseEffect */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
/** vertexAtrib */
@property (strong, nonatomic) JCGLKVertexAttribArrayBuffer *vertexBuffer;
/** textureSwitch */
@property (strong, nonatomic) UISwitch *textureSwitch;
/** 纹理过滤方式：linear/nearest */
@property (assign, nonatomic) BOOL shouldUseLinearFilter;

@end

@implementation JCGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化自定义控件
    [self setupView];

    // 初始化工作
    [self setupGLK];
}

/**
 *  添加一个UISwitch控件
 */
- (void)setupView {

    self.textureSwitch = [[UISwitch alloc] init];
    self.textureSwitch.frame = (CGRect){{100, 500}, {80, 30}};
    [self.view addSubview:self.textureSwitch];
    [self.textureSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
}

/**
 *  监听UISwitch
 */
- (void)switchClick:(UISwitch *)textureSwitch {

    self.shouldUseLinearFilter = [textureSwitch isOn];

}

/**
 *  初始化工作
 */
- (void)setupGLK {

    /**
     *  For setting the desired frames per second at which the update and drawing will take place.
        
     Required method for implementing GLKViewControllerDelegate. This update method variant should be used
     when not subclassing GLKViewController. This method will not be called if the GLKViewController object
     has been subclassed and implements -(void)update.
     
     如果不设置这个属性，就不会自动调用 - (void)update 方法
     */
    self.preferredFramesPerSecond = 60;

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view不是GLKView");

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    // 这里使用GL_DYNAMIC_DRAW，因为我们要修改缓存区的内容
    self.vertexBuffer = [[JCGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                         data:vertices
                         usage:GL_DYNAMIC_DRAW];

    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];

    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];

    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;

}

/**
 *  设置了preferredFramesPerSecond属性，就会在glkView之后自动调用这个方法
 */
- (void)update {
    // 顶点动画
    [self updateAnimatedVertexPositions];
    // 设置纹理过滤模式
    [self updateTextureParameters];

    // 重新从缓存区中获取数据
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices];

}

/**
 *  重新设置纹理模式
 */
- (void)updateTextureParameters {

    [self.baseEffect.texture2d0 jc_glkSetParameter:GL_TEXTURE_MAG_FILTER param:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
}

/**
 *  更新三角形三个顶点的坐标
 */
- (void)updateAnimatedVertexPositions {

    for(int i = 0; i < 3; i++) {

        vertices[i].positionCoords.x += movementVectors[i].x;
        if(vertices[i].positionCoords.x >= 1.0f ||
           vertices[i].positionCoords.x <= -1.0f) {
            movementVectors[i].x = -movementVectors[i].x;
        }

        vertices[i].positionCoords.y += movementVectors[i].y;
        if(vertices[i].positionCoords.y >= 1.0f ||
           vertices[i].positionCoords.y <= -1.0f) {
            movementVectors[i].y = -movementVectors[i].y;
        }

        vertices[i].positionCoords.z += movementVectors[i].z;
        if(vertices[i].positionCoords.z >= 1.0f ||
           vertices[i].positionCoords.z <= -1.0f) {
            movementVectors[i].z = -movementVectors[i].z;
        }
    }
}

/**
 *  重绘
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    [self.baseEffect prepareToDraw];

    // 清除之前颜色
    glClear(GL_COLOR_BUFFER_BIT);

    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];

    [self.vertexBuffer prepareToDrawWithAttrib:JCGLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}


/**
 *  view消失的时候，把上下文清空
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = nil;
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}


@end
