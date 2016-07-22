//
//  GLKEffectPropertyTexture+SettingTexture.h
//  OpenGL-ES-04
//
//  Created by chenjiangchuan on 16/7/22.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLKEffectPropertyTexture (SettingTexture)

/**
 *  设置纹理的取样模式
 *
 *  @param pname 参数
 *  @param param 参数对应的值
 */
- (void)jc_glkSetParameter:(GLenum)pname param:(GLint)param;

@end
