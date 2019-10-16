//
//  BaseTableView.m
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseTableView.h"
#import "XXEmptyView.h"

@implementation BaseTableView


- (void)dealloc {
    NSLog(@"%@ 释放了", self.className);
    [kNotificationCenter removeObserver:self];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *childView in self.superview.subviews) {
        if ([childView isKindOfClass:XXEmptyView.class] && !childView.hidden) {
            return childView;
            break;
        }
    }
    return [super hitTest:point withEvent:event];
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    
    [self configTableView];
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self configTableView];
    
    return self;
}


- (void)configTableView {
    
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //键盘自动退出
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    //索引颜色
    self.sectionIndexColor = [UIColor blackColor];
    self.sectionIndexBackgroundColor = [UIColor clearColor];
    self.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    //默认不设置都可以滑动 在iOS9上可能有这个问题
    //    _tableView.delaysContentTouches = YES;
    //    _tableView.panGestureRecognizer.delaysTouchesBegan = _tableView.delaysContentTouches;
    
    // Remove touch delay (since iOS 8) 移除掉手指触摸到按钮之类的事件，tableview是不会跟着滑动的
    UIView *wrapView = self.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
}


//手势判断
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    
    //如果UIControl 有高亮效果的
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}


@end
