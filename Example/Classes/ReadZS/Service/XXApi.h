//
//  XXApi.h
//  Novel
//
//  Created by xx on 2018/9/3.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXRankingListLayout.h"
#import "XXRankingApi.h"

typedef NS_ENUM(NSInteger, kBookListType) {
    kBookListType_rank, //排行版
    kBookListType_recommend,//书籍详情里的推荐更多
    kBookListType_search,//搜索
};


@interface XXApi : NSObject


/**
 获取小说列表

 @param type <#type description#>
 @param id <#id description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)getBookListWithListType:(kBookListType)type id:(NSString *)id success:(void(^)(NSArray <XXRankingListLayout *>*list))success failure:(requestFailure)failure;



@end
