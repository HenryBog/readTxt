//
//  XXRankingListLayout.h
//  Novel
//
//  Created by xx on 2018/9/3.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooksListModel.h"

@interface XXRankingListLayout : NSObject

- (instancetype)initWithLayout:(BooksListItemModel *)model;

@property (nonatomic, strong) BooksListItemModel *model;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat marginTop;

@property (nonatomic, assign) CGFloat marginBottom;

@property (nonatomic, assign) CGFloat marginLeft;

@property (nonatomic, assign) CGFloat marginRight;

@property (nonatomic, assign) CGFloat textLeft;

@property (nonatomic, assign) CGFloat textVerSpace;

@property (nonatomic, assign) CGSize coverSize;

@property (nonatomic, strong) YYTextLayout *titleLayout;

@property (nonatomic, strong) YYTextLayout *authorAndCatLayout;

@property (nonatomic, strong) YYTextLayout *shortIntroLayout;

@property (nonatomic, strong) YYTextLayout *followerAndRetentionLayout;


@end
