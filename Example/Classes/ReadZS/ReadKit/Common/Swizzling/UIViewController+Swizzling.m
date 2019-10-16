//
//  UIViewController+Swizzling.m
//  Novel
//
//  Created by xx on 2018/9/2.
//  Copyright © 2018年 th. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "SwizzlingDefine.h"

@implementation UIViewController (Swizzling)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidLoad),    @selector(swizzling_viewDidLoad));
    });
}

#pragma mark - ViewDidLoad
- (void)swizzling_viewDidLoad {
    [self swizzling_viewDidLoad];
    if (self.navigationController) {
        UIImage *buttonNormal = UIImageName(@"backTo");
        [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationItem.backBarButtonItem = backItem;
    }
}

@end
