//
//  xxBaseSctrollView.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseScrollView.h"
@class XXEmptyView;

@interface BaseScrollView()

@property (nonatomic, copy) NSString *emptyError;

@end

@implementation BaseScrollView

- (void)dealloc {
    NSLog(@"%@ 释放了", self.className);
    [kNotificationCenter removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
        //self.alwaysBounceVertical = YES;
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            //必须要约束宽度
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).priorityLow();
        }];
        
        [self setupViews];
        [self setupLayout];
        [self configEvent];
    }
    return self;
}


- (void)setupViews {
    
}


- (void)setupLayout {
    
}


- (void)configEvent {
    
}


- (void)configWithModel:(id)model {
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delaysContentTouches = NO;
    }
    return self;
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
