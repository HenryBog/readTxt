//
//  CYLDetailsViewController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLDetailsViewController.h"
#import "CYLTabBarController.h"
#import "CYLMineViewController.h"
#import "CYLHomeViewController.h"
@interface CYLDetailsViewController ()

@end

@implementation CYLDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情页";
    self.view.backgroundColor = [UIColor orangeColor];
  
}

- (NSDictionary *)requestBodyWithBook_id:(NSString *)book_id {
    return @{@"book_id":book_id,
             @"user_id":@"",
             @"chapter_id":@"0"
             };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    // [self cyl_popSelectTabBarChildViewControllerAtIndex:3 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//    [self cyl_popSelectTabBarChildViewControllerForClassType:[CYLMineViewController class] completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//        CYLMineViewController *mineViewController = selectedTabBarChildViewController;
//        @try {
//            [mineViewController testPush];
//        } @catch (NSException *exception) {
//            NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
//        }
//    }];
}

@end
