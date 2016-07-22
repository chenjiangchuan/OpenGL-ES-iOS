//
//  JCViewController.h
//  OpenGL-ES-02
//
//  Created by chenjiangchuan on 16/7/21.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import <GLKit/GLKit.h>

@class JCGLKVertexAttribArrayBuffer;

@interface JCViewController : GLKViewController

/**  */
@property (strong, nonatomic) JCGLKVertexAttribArrayBuffer *vertexBuffer;
/**  */
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end
