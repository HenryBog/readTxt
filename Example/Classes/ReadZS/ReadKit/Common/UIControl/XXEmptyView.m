//
//  XXEmptyView.m
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXEmptyView.h"

@interface XXEmptyView()

/** 父视图 */
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) YYLabel *messageLabel;

@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation XXEmptyView


- (void)dealloc {
    if (_refreshDelegate) {
        [_refreshDelegate sendCompleted];
    }
}


- (instancetype)init {
    if (self = [super init]) {
        _isFirstAppear = YES;
        [self setupViews];
        [self configEvent];
    }
    return self;
}


- (void)showInView:(UIView *)parentView {
    [parentView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentView);
    }];
}


- (void)emptyTap {
    if (_refreshDelegate && !self.hidden) {
        [_refreshDelegate sendNext:nil];
    }
}


- (void)configEvent {
    [self addTarget:self action:@selector(emptyTap) forControlEvents:UIControlEventTouchUpInside];
    MJWeakSelf;
    self.titleLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf emptyTap];
    };
    self.messageLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf emptyTap];
    };
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyTap)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}


- (void)setupViews {
    
    [self addSubview:self.container];
    
    [self.container addSubview:self.imageView];
    
    [self.container addSubview:self.titleLabel];
    
    [self.container addSubview:self.messageLabel];
    
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).priorityLow();
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.imageView.mas_top);
        make.bottom.mas_equalTo(self.messageLabel.mas_bottom);
    }];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container);
        make.top.equalTo(self.container);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self.container);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(24.f);
    }];
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8.f);
        make.left.mas_equalTo(self.container.mas_left).offset(30.f);
        make.right.mas_equalTo(self.container.mas_right).offset(-30.f);
    }];
}


- (void)showImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    
    self.imageView.image = image;
    
    if (!IsEmpty(title)) self.titleLabel.text = title;
    
    if (!IsEmpty(message)) self.messageLabel.text = message;
    
    if (!image) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
            make.top.equalTo(@0);
            make.centerX.equalTo(self.container);
        }];
    }
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (IsEmpty(title)) make.height.mas_equalTo(0);
    }];
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (IsEmpty(message)) make.height.mas_equalTo(0);
    }];
    
    if (_isFirstAppear) {
        _isFirstAppear = NO;
        self.imageCenterOffsetY = 0;
        self.titleMarginTop = 24;
        self.messageMarginTop = 8;
    }
}


- (void)configEdgesSuperView:(UIView *)superView {
    if (!superView) return;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}


- (void)updateTitle:(NSString *)title message:(NSString *)message {
    
    if (!IsEmpty(title)) self.titleLabel.text = title;
    if (!IsEmpty(message)) self.messageLabel.text = message;
}


#pragma mark - setter


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        //将emptyView移到背后
        [self.superview sendSubviewToBack:self];
    }
    else {
        //放到前面
        [self.superview bringSubviewToFront:self];
    }
}


- (void)setImageCenterOffsetY:(CGFloat)imageCenterOffsetY {
    _imageCenterOffsetY = imageCenterOffsetY;
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(imageCenterOffsetY).priorityHigh();
    }];
}


- (void)setTitleMarginTop:(CGFloat)titleMarginTop {
    _titleMarginTop = titleMarginTop;
    CGFloat top = titleMarginTop;
    if (!self.imageView.image) {
        self.imageCenterOffsetY = titleMarginTop;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(0);
        }];
    }
    else {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(top);
        }];
    }
}


- (void)setMessageMarginTop:(CGFloat)messageMarginTop {
    _messageMarginTop = messageMarginTop;
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(messageMarginTop);
    }];
}


- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = _titleFont;
}


- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}


- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    self.messageLabel.font = _messageFont;
}


- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.messageLabel.textColor = _messageColor;
}


#pragma mark - getter

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = kFont_Zhong(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}


- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = kFont_xi(12);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

@end
