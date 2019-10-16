//
//  UIViewController+Add.h
//  Novel
//
//  Created by app on 2018/1/17.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Add)

/**
 push跳转简写
 
 @param targetViewController 目标viewController
 */
- (void)pushViewController:(UIViewController *)targetViewController;


/**
 popViewControllerAnimated简写
 */
- (void)popViewController;


/**
 返回，适应不同跳转的情况
 */
- (void)go2Back;

@end
