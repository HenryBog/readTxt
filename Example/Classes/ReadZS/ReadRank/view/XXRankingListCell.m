//
//  XXRankingListCell.m
//  Novel
//
//  Created by xx on 2018/9/3.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRankingListCell.h"

@interface XXRankingListCell()

/** 图片 */
@property (nonatomic, strong) UIImageView *coverView;

/** 作者 */
@property (nonatomic, strong) YYLabel *titleLabel;

/** 作者 | 类型 */
@property (nonatomic, strong) YYLabel *authorAndCatLabel;

/** 简介 */
@property (nonatomic, strong) YYLabel *shortIntroLabel;

/** n人在追 | n%读者留存 */
@property (nonatomic, strong) YYLabel *followerAndRetentionLabel;

/** underline */
@property (nonatomic, strong) UIView *lineView;


@end

@implementation XXRankingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupViews {
    
    _coverView = [[UIImageView alloc] init];
    [self addSubview:_coverView];
    
    //otherLabel
    _titleLabel = [YYLabel newYYLabel];
    [self.contentView addSubview:_titleLabel];
    
    _authorAndCatLabel = [YYLabel newYYLabel];
    [self.contentView addSubview:_authorAndCatLabel];
    
    _shortIntroLabel = [YYLabel newYYLabel];
    [self.contentView addSubview:_shortIntroLabel];
    
    _followerAndRetentionLabel = [YYLabel newYYLabel];
    [self.contentView addSubview:_followerAndRetentionLabel];
    
    //underline
    _lineView = [UIView newLine];
    [self.contentView addSubview:_lineView];
}


- (void)setLayout:(XXRankingListLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    
    
    //cover
    _coverView.size = layout.coverSize;
    _coverView.origin = CGPointMake(layout.marginLeft, (layout.height - _coverView.height)/2);
    [_coverView sd_setImageWithURL:NSURLwithString(layout.model.cover) placeholderImage:UIImageName(@"default_book_cover")];
    
    //title
    _titleLabel.size = layout.titleLayout.textBoundingSize;
    _titleLabel.origin = CGPointMake(_coverView.right + layout.textLeft, layout.marginTop);
    _titleLabel.textLayout = layout.titleLayout;
    
    
    //authorAndCat
    _authorAndCatLabel.size = layout.authorAndCatLayout.textBoundingSize;
    _authorAndCatLabel.origin = CGPointMake(_titleLabel.left, _titleLabel.bottom + layout.textVerSpace);
    _authorAndCatLabel.textLayout = layout.authorAndCatLayout;
    
    
    //shortIntro
    _shortIntroLabel.size = layout.shortIntroLayout.textBoundingSize;
    _shortIntroLabel.origin = CGPointMake(_titleLabel.left, _authorAndCatLabel.bottom + layout.textVerSpace);
    _shortIntroLabel.textLayout = layout.shortIntroLayout;
    
    //_followerAndRetention
    _followerAndRetentionLabel.size = layout.followerAndRetentionLayout.textBoundingSize;
    _followerAndRetentionLabel.origin = CGPointMake(_titleLabel.left, _shortIntroLabel.bottom + layout.textVerSpace);
    _followerAndRetentionLabel.textLayout = layout.followerAndRetentionLayout;
    
    //underline
    _lineView.size = CGSizeMake(kScreenWidth - layout.marginLeft - layout.marginRight, klineHeight);
    _lineView.origin = CGPointMake(layout.marginLeft, layout.height - 0.5);
}

@end
