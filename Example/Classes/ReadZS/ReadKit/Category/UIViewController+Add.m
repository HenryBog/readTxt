//
//  UIViewController+Add.m
//  Novel
//
//  Created by app on 2018/1/17.
//  Copyright © 2018年 th. All rights reserved.
//

#import "UIViewController+Add.h"

@implementation UIViewController (Add)


//push跳转简写
- (void)pushViewController:(UIViewController *)targetViewController {
    
    if (targetViewController) {
        [self.navigationController pushViewController:targetViewController animated:YES];
    } else {
        NSLog(@"注意targetViewController不能为空");
    }
}


//popViewControllerAnimated简写
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


//返回，适应不同跳转的情况
- (void)go2Back {
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
