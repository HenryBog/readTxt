//
//  xxBaseSctrollView.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView

@property (nonatomic, strong) UIView *contentView;

- (void)setupViews;

- (void)setupLayout;

- (void)configEvent;

- (void)configWithModel:(id)model;


@end
