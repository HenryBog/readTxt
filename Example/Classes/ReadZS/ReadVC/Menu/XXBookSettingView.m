//
//  XXBookSettingView.m
//  Novel
//
//  Created by app on 2018/1/22.
//  Copyright © 2018年 th. All rights reserved.
//

#define kItemW AdaWidth(44)

#import "XXBookSettingView.h"

@interface XXBookSettingView()

@property (nonatomic, strong) UIButton *smallButton;

@property (nonatomic, strong) UIButton *bigButton;

@property (nonatomic, strong) NSMutableArray *colorSubViews;

@property (nonatomic, strong) UIButton *colorSeletedButton;

//@property (nonatomic, strong) UIButton *landspaceButton;

@end

@implementation XXBookSettingView

- (void)setupViews {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
}

- (void)setupLayout {
    
    UIImage *sImage = UIImageName(@"setting_font_smaller_normal");
    UIImage *bImage = UIImageName(@"setting_font_bigger");
    UIImage *settingImage = UIImageName(@"blackboard_reader_setting");
    
    UIButton *smallButton = [[UIButton alloc] init];
    [smallButton setImage:sImage forState:UIControlStateNormal];
    [self addSubview:smallButton];
    
    UIButton *bigButton = [[UIButton alloc] init];
    [bigButton setImage:bImage forState:UIControlStateNormal];
    [self addSubview:bigButton];
    
    UIButton *settingButton = [[UIButton alloc] init];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [self addSubview:settingButton];
    
//    _landspaceButton = [UIButton newButtonTitle:@"" font:15 normarlColor:kwhiteColor];
//    _landspaceButton.layer.cornerRadius = AdaWidth(5);
//    _landspaceButton.layer.borderColor = klineColor.CGColor;
//    _landspaceButton.layer.borderWidth = klineHeight;
//    [self addSubview:_landspaceButton];
//
//
//    BookSettingModel *setMd = [BookSettingModel decodeModelWithKey:NSStringFromClass([BookSettingModel class])];
//
//    if (setMd.isLandspace) {
//        [_landspaceButton setTitle:@"竖屏" forState:0];
//    } else {
//        [_landspaceButton setTitle:@"横屏" forState:0];
//    }
    
    CGFloat settingWidth = AdaWidth(60);
    CGFloat fontBtnSpaceX = AdaWidth(20);
    CGSize buttonSize = CGSizeMake((kScreenWidth - fontBtnSpaceX*2 - settingWidth)/2, sImage.height);
    
    [smallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AdaWidth(12.f));
        make.left.equalTo(@(fontBtnSpaceX));
        make.size.mas_equalTo(buttonSize);
    }];
    
    [bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallButton);
        make.left.mas_equalTo(smallButton.mas_right).offset(fontBtnSpaceX);
        make.size.equalTo(smallButton);
    }];
    
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bigButton);
        make.right.equalTo(@0);
        make.width.mas_equalTo(settingWidth);
    }];
    
    MJWeakSelf;
    [[smallButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakSelf.changeSmallerFontBlock) {
            weakSelf.changeSmallerFontBlock();
        }
    }];
    
    [[bigButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakSelf.changeBiggerFontBlock) {
            weakSelf.changeBiggerFontBlock();
        }
    }];
    
//    [[_landspaceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (weakself.landspaceBlock) {
//            weakself.landspaceBlock();
//        }
//    }];
    
    [[settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakSelf.moreSettingBlock) {
            weakSelf.moreSettingBlock();
        }
    }];
    
    _colorSubViews = [[NSMutableArray alloc] init];
    
    NSArray *colors = @[@"def_53x32_", @"ink_53x32_", @"flax_53x32_", @"green_53x32_", @"peach_53x32_"];
    
    CGFloat itemSpace = (kScreenWidth - colors.count * kItemW) / (colors.count + 1);
    
    MAS_VIEW *prev;
    for (int i = 0; i < colors.count; i++) {
        
        kBgColor bgColor = i + 1;
        
        UIButton *colorButton = [[UIButton alloc] init];
        colorButton.tag = bgColor;
        [colorButton setBackgroundImage:UIImageName(colors[i]) forState:0];
        colorButton.layer.masksToBounds = YES;
        [colorButton setImage:UIImageName(@"setting_theme_selected") forState:UIControlStateSelected];
        [self addSubview:colorButton];
        
        [colorButton addTarget:self action:@selector(seletedColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kItemW, kItemW));
            make.left.equalTo(prev ? prev.mas_right : self.mas_left).offset(itemSpace);
            make.top.mas_equalTo(smallButton.mas_bottom).offset(AdaWidth(12.f));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-AdaWidth(12.f));
        }];
        colorButton.layer.cornerRadius = kItemW/2;
        
        prev = colorButton;
        
        if (kReadingManager.bgColor == bgColor) {
            [self seletedColor:colorButton];
        }
        
        [_colorSubViews addObject:colorButton];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemSpace = (kScreenWidth - _colorSubViews.count * kItemW) / (_colorSubViews.count + 1);
    
    MAS_VIEW *prev;
    for (int i = 0; i < _colorSubViews.count; i++) {
        
        UIButton *colorButton = _colorSubViews[i];
        
        [colorButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(prev ? prev.mas_right : self.mas_left).offset(itemSpace);
        }];
        
        prev = colorButton;
    }
}


- (void)seletedColor:(UIButton *)sender {
    
    if (sender.selected) return;
    
    sender.selected = YES;
    _colorSeletedButton.selected = NO;
    _colorSeletedButton = sender;
    
    kReadingManager.bgColor = sender.tag;
    kReadingManager.dayMode = kDayMode_light;
    
    //查询设置model
    BookSettingModel *model = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    model.dayMode = kReadingManager.dayMode;
    model.bgColor = sender.tag;
    [BookSettingModel encodeModel:model key:[BookSettingModel className]];
    
    //发送通知到内容页面改变背景颜色
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithChangeBg object:nil userInfo:@{kNotificationWithChangeBg:NSStringFormat(@"%ld", (long)sender.tag)}];
}


- (void)changeLightbgColorSeleted:(kBgColor)bgColor {
    
    UIButton *seletedButton;
    for (UIButton *button in _colorSubViews) {
        if (button.tag == bgColor) {
            seletedButton = button;
            break;
        }
    }
    
    if (seletedButton) {
       [self seletedColor:seletedButton];
    }
}


- (void)changeNight {
    for (UIButton *button in _colorSubViews) {
        button.selected = NO;
    }
}

@end
