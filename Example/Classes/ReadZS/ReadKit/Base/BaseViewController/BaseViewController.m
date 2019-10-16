//
//  BaseViewController.m
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#pragma mark - UIViewController

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
}


/*
 在info.plist文件中 View controller-based status bar appearance
 -> YES，则控制器对状态栏设置的优先级高于application
 -> NO，则以application为准，控制器设置状态栏-(UIStatusBarStyle)preferredStatusBarStyle - (BOOL)prefersStatusBarHidden 是无效的的根本不会被调用
 */

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是否需要横屏
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self setupViews];
    
    [self setupLayout];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
//                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    kSafeAreaInsets.safeAreaInsets = self.view.safeAreaInsets;
}


//创建UI
- (void)setupViews {
    
}


//布局
- (void)setupLayout {
    
}


//网络请求
- (void)requestDataWithShowLoading:(BOOL)show {
    if (show) {
        [HUD showProgressCircleNoValue:nil inView:self.view];
    }
}


//创建空视图
- (void)configEmptyView {
    [self.emptyView showInView:self.view];
    [self.emptyView showImage:UIImageName(@"empty_ic") title:@"没有数据" message:nil];
    self.emptyView.hidden = YES;
}


- (void)showEmpty:(NSString *)errorTitle message:(NSString *)errorMessage {
    [self.emptyView updateTitle:errorTitle message:errorMessage];
    self.emptyView.hidden = NO;
}


- (XXEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[XXEmptyView alloc] init];
    }
    return _emptyView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
