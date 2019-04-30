//
//  CYLMineViewController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLMineViewController.h"

@implementation CYLMineViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    self.tabBarItem.title = @"我的23333";
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
}
- (void)testPush {
    [self cyl_showBadgeValue:[NSString stringWithFormat:@"%@", @(3)] animationType:CYLBadgeAnimationTypeNone];
}

@end
