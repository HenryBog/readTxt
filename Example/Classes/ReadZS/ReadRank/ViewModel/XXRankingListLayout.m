//
//  XXRankingListLayout.m
//  Novel
//
//  Created by xx on 2018/9/3.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRankingListLayout.h"

@implementation XXRankingListLayout

- (instancetype)initWithLayout:(BooksListItemModel *)model {
    if (self = [super init]) {
        _model = model;
        [self _layout];
    }
    return self;
}


- (void)_layout {
    
    _height = 0;
    _marginTop = 8;
    _marginBottom = 8;
    _marginLeft = 12;
    _marginRight = 12;
    _textLeft = 10;
    _textVerSpace = 3;
    _coverSize = CGSizeMake(50, 62.5);
    
    _height += _marginTop + _marginBottom;
    
    [self _layoutTitle];
    [self _layoutAuthorAndCat];
    [self _layoutShortIntro];
    [self _layoutFollowerAndRetention];
}


/** 标题 */
- (void)_layoutTitle {
    if (_model.title) {
        _titleLayout = [YYTextLayout layoutWithTitle:_model.title textFont:kFont_Zhong(15) textColor:kblackColor maxSize:CGSizeMake(kScreenWidth - _marginLeft - _marginRight - _coverSize.width - _textLeft, HUGE) maximumNumberOfRows:1 lineSpace:0];
        _height += _titleLayout.textBoundingSize.height;
    }
}


/** 读者 | 类型 */
- (void)_layoutAuthorAndCat {
    if (_model.author || _model.cat) {
        NSString *authorAndCat = nil;
        if (_model.cat.length == 0) {
            authorAndCat = [NSString stringWithFormat:@"%@",_model.author];
        } else {
            authorAndCat = [NSString stringWithFormat:@"%@ | %@",_model.author,_model.cat];
        }
        
        _authorAndCatLayout = [YYTextLayout layoutWithTitle:authorAndCat textFont:kFont_Zhong(12) textColor:[UIColor lightGrayColor] maxSize:CGSizeMake(kScreenWidth - _marginLeft - _marginRight - _coverSize.width - _textLeft, HUGE) maximumNumberOfRows:1 lineSpace:0];
        _height += _authorAndCatLayout.textBoundingSize.height + _textVerSpace;
    }
}


/** 简介 */
- (void)_layoutShortIntro {
    if (_model.shortIntro) {
        _shortIntroLayout = [YYTextLayout layoutWithTitle:_model.shortIntro textFont:kFont_Zhong(12) textColor:[UIColor lightGrayColor] maxSize:CGSizeMake(kScreenWidth - _marginLeft - _marginRight - _coverSize.width - _textLeft, HUGE) maximumNumberOfRows:1 lineSpace:0];
        _height += _shortIntroLayout.textBoundingSize.height + _textVerSpace;
    }
}


/** n人在追 | n%读者保留 */
- (void)_layoutFollowerAndRetention {
    if (_model.latelyFollower && _model.retentionRatio) {
        NSString *followerAndRetention = nil;
        if (_model.retentionRatio == 0) {
            followerAndRetention = [NSString stringWithFormat:@"%@人在追",_model.latelyFollower];
        } else {
            followerAndRetention = [NSString stringWithFormat:@"%@人在追 | %@%@读者存留",_model.latelyFollower,_model.retentionRatio,@"%"];
        }
        
        _followerAndRetentionLayout = [YYTextLayout layoutWithTitle:followerAndRetention textFont:kFont_Zhong(12) textColor:[UIColor lightGrayColor] maxSize:CGSizeMake(kScreenWidth - _marginLeft - _marginRight - _coverSize.width - _textLeft, HUGE) maximumNumberOfRows:1 lineSpace:0];
        _height += _followerAndRetentionLayout.textBoundingSize.height + _textVerSpace;
    }
}

@end
