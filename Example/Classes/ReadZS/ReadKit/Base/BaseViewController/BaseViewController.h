//
//  BaseViewController.h
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLBaseViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "XXEmptyView.h"

/**
 *  根视图控制器类，一切普通视图控制器都继承此类。
 */
@interface BaseViewController : CYLBaseViewController


//- (BOOL)navigationShouldPopOnBackButton 可以拦截系统的返回事件


/** 空视图 */
@property (nonatomic, strong) XXEmptyView *emptyView;


/**
 创建UI
 */
- (void)setupViews;


/**
 布局
 */
- (void)setupLayout;


/**
 开始网络请求
 
 @param show 是否显示loading
 */
- (void)requestDataWithShowLoading:(BOOL)show;


/**
 配置空视图，在子控制器调用
 */
- (void)configEmptyView;


/**
 显示空视图
 
 @param errorTitle <#errorTitle description#>
 @param errorMessage <#errorMessage description#>
 */
- (void)showEmpty:(NSString *)errorTitle message:(NSString *)errorMessage;


/* 错误标题 */
@property (nonatomic, copy) NSString *errorTitle;


/* 错误详细 */
@property (nonatomic, copy) NSString *errorMessage;

@end
