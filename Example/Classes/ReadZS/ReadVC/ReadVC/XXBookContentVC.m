//
//  XXBookContentVC.m
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookContentVC.h"
#import "BatteryView.h"

@interface XXBookContentVC ()

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) BatteryView *batteryView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation XXBookContentVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景颜色的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgColorWithNotifiction:) name:kNotificationWithChangeBg object:nil];
}


- (void)changeBgColorWithNotifiction:(NSNotification *)sender {
    kBgColor bgoColor = [[sender userInfo][kNotificationWithChangeBg] integerValue];
    [self changeBgColorWithIndex:bgoColor];
}


#pragma mark - 改变背景颜色
- (void)changeBgColorWithIndex:(kBgColor)bgoColor {
    
    NSString *bgImageName;
    switch (kReadingManager.bgColor) {
        case kBgColor_default:
            bgImageName = @"def_bg_375x667_";
            break;
        case kBgColor_ink:
            bgImageName = @"ink_bg_375x667_";
            break;
        case kBgColor_flax:
            bgImageName = @"flax_bg_375x667_";
            break;
        case kBgColor_green:
            bgImageName = @"green_bg_375x667_";
            break;
        case kBgColor_peach:
            bgImageName = @"peach_bg_375x667_";
            break;
        case kBgColor_Black:
            bgImageName = @"coffee_mode_bg";
            break;
        default:
            break;
    }
    
    if (kReadingManager.dayMode == kDayMode_night) {
        UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.yy_color = color;
        self.contentLabel.attributedText = text;
        
        self.titleLabel.textColor = color;
        self.timeLabel.textColor = color;
        self.pageLabel.textColor = color;
    } else {
        
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.yy_color = kblackColor;
        self.contentLabel.attributedText = text;
        
        self.titleLabel.textColor = knormalColor;
        self.timeLabel.textColor = knormalColor;
        self.pageLabel.textColor = knormalColor;
    }
    
    UIImage *bgImage = UIImageName(bgImageName);
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    
    self.batteryView.backgroundColor = [bgImage mostColor];
    [self.batteryView setNeedsDisplay];
}


#pragma mark - setter

- (void)setBookModel:(XXBookChapterModel *)bookModel {
    _bookModel = bookModel;
    self.titleLabel.text = bookModel.title;
    
    if (bookModel.status == kbookBodyStatus_loading) {
        self.contentLabel.hidden = YES;
        self.statusLabel.text = @"加载中...";
    }
    else if (bookModel.status == kbookBodyStatus_error) {
        self.contentLabel.hidden = YES;
        self.statusLabel.text = bookModel.errorString;
    }
    else {
        _statusLabel.hidden = YES;
        self.contentLabel.hidden = NO;
    }
}


- (void)setPage:(NSUInteger)page {
    _page = page;
    self.contentLabel.attributedText = [kReadingManager getStringWithpage:page andChapter:_bookModel];
    self.timeLabel.text = [[DateTools shareDate] getTimeString];
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", page+1, _bookModel.pageCount];
    NSLog(@"加载广告%d", (page+1 ==  _bookModel.pageCount));
    [self changeBgColorWithIndex:kReadingManager.bgColor];
}


#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFont:fontSize(13)];
        [self.view addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat top = 0;
            if (xx_iPhoneX) {
                top = kSafeAreaInsets.safeAreaInsets.top;
            }
            make.top.mas_equalTo(self.view.mas_top).offset(top);
            make.left.mas_equalTo(self.view.mas_left).offset(kReadSpaceX);
            make.right.mas_equalTo(self.view.mas_right).offset(-kReadSpaceX);
            make.height.mas_equalTo(kReadingTopH);
        }];
    }
    return _titleLabel;
}


- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel newLabel:@"" andTextColor:kblackColor andFont:kFont_Zhong(16)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(44);
            make.left.mas_equalTo(self.view.mas_left).offset(kReadSpaceX);
            make.right.mas_equalTo(self.view.mas_right).offset(-kReadSpaceX);
        }];
    }
    return _statusLabel;
}


- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];//居上对齐
        [self.view addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left).offset(kReadSpaceX);
            make.right.mas_equalTo(self.view.mas_right).offset(-kReadSpaceX);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
    }
    return _contentLabel;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kSafeAreaInsets.safeAreaInsets.bottom);
            make.height.mas_equalTo(kReadingBottomH);
        }];
    }
    return _bottomView;
}

- (BatteryView *)batteryView {
    if (!_batteryView) {
        
        _batteryView = [[BatteryView alloc] init];
        _batteryView.fillColor = [UIColor colorWithRed:0.35 green:0.31 blue:0.22 alpha:1.00];
        [self.bottomView addSubview:_batteryView];
        
        [_batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.left.mas_equalTo(self.bottomView.mas_left).offset(kReadSpaceX);
            make.size.mas_equalTo(CGSizeMake(AdaWidth(25), AdaWidth(10)));
        }];
    }
    return _batteryView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFont:fontSize(12)];
        [self.bottomView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batteryView);
            make.left.mas_equalTo(self.batteryView.mas_right).offset(AdaWidth(8));
        }];
        
    }
    return _timeLabel;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFont:fontSize(12)];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:_pageLabel];
        
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batteryView);
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(AdaWidth(12.f));
            make.right.mas_equalTo(self.bottomView.mas_right).offset(-kReadSpaceX);
        }];
    }
    return _pageLabel;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
