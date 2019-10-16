//
//  RTBookDirectoryModel.m
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import "RTBookDirectoryModel.h"

@implementation RTBookDirectoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bookDetailModel" : [RTBookDetailModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (LSYChapterModel *)modelWithBookModel:(RTBookDirectoryModel *)bookModel {
    LSYChapterModel *model = [[LSYChapterModel alloc] init];
    if (!bookModel ) {
        return model;
    }
    model.title = bookModel.chapter_title ?: @"";
    if (bookModel && bookModel.bookDetailModel && bookModel.bookDetailModel.content) {
        model.content = bookModel.bookDetailModel.content.length > 0 ? bookModel.bookDetailModel.content : @"";
    }
    return model;
}

@end
