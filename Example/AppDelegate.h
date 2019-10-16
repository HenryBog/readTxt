//
//  AppDelegate.h
//  CYLTabBarControllerDemo
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 当状态栏消失后STATUS_BAR_HEIGHT = 0 */
@property (nonatomic, assign) CGFloat statusBarHeight;
@end

