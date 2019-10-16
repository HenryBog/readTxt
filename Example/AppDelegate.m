//
//  AppDelegate.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import "AppDelegate.h"
#import "CYLMainRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _statusBarHeight = STATUS_BAR_HEIGHT;
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;

    CYLMainRootViewController *rootViewController = [[CYLMainRootViewController alloc] init];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    [self setUpNavigationBarAppearance];
    [self customizeInterface];
    [self setupRequest];
    return YES;
}

//设置网络
- (void)setupRequest {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = SERVERCE_HOST;
    config.cdnUrl = chapter_URL;
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
    textAttributes = @{
                       NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                       NSForegroundColorAttributeName : [UIColor blackColor],
                       };
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
//    navigationBarAppearance.backgroundColor = [UIColor whiteColor];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
}

/**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterface {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
}

@end
