//
//  GLKEffectPropertyTexture+SettingTexture.m
//  OpenGL-ES-04
//
//  Created by chenjiangchuan on 16/7/22.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "GLKEffectPropertyTexture+SettingTexture.h"

@implementation GLKEffectPropertyTexture (SettingTexture)

- (void)jc_glkSetParameter:(GLenum)pname param:(GLint)param {

    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, pname, param);
}

@end
