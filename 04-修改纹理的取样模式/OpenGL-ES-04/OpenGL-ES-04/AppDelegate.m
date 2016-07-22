//
//  AppDelegate.m
//  OpenGL-ES-04
//
//  Created by chenjiangchuan on 16/7/22.
//  Copyright © 2016年 JC‘Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "JCGLKViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController = [[JCGLKViewController alloc] init];

    [self.window makeKeyAndVisible];

    return YES;
}

@end
