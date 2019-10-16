//
//  XXApi.m
//  Novel
//
//  Created by xx on 2018/9/3.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXApi.h"

@implementation XXApi

+ (void)getBookListWithListType:(kBookListType)type id:(NSString *)id success:(void(^)(NSArray <XXRankingListLayout *>*list))success failure:(requestFailure)failure {
    switch (type) {
        case kBookListType_rank: {
            XXRankingApi *api = [[XXRankingApi alloc] initWithParameter:nil url:URL_ranking(id)];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                BooksListModel *model = [BooksListModel yy_modelWithDictionary:request.responseObject[@"ranking"]];
                if (model.books.count > 0) {
                    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:model.books.count];
                    for (BooksListItemModel *item in model.books) {
                        item.cover = NSStringFormat(@"%@%@", statics_URL, item.cover);
                        XXRankingListLayout *layout = [[XXRankingListLayout alloc] initWithLayout:item];
                        [layouts addObject:layout];
                    }
                    success(layouts);
                }
                else {
                    failure(@"列表为空...");
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                failure([request.error localizedDescription]);
            }];
        }
            break;
            
        case kBookListType_recommend: {
            XXRankingApi *api = [[XXRankingApi alloc] initWithParameter:nil url:URL_recommend(id)];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                BooksListModel *model = [BooksListModel yy_modelWithDictionary:request.responseObject];
                if (model.books.count > 0) {
                    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:model.books.count];
                    for (BooksListItemModel *item in model.books) {
                        item.cover = NSStringFormat(@"%@%@", statics_URL, item.cover);
                        XXRankingListLayout *layout = [[XXRankingListLayout alloc] initWithLayout:item];
                        [layouts addObject:layout];
                    }
                    success(layouts);
                }
                else {
                    failure(@"列表为空...");
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                failure([request.error localizedDescription]);
            }];
        }
            break;
            
        case kBookListType_search: {
            XXRankingApi *api = [[XXRankingApi alloc] initWithParameter:nil url:URL_search(id)];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                BooksListModel *model = [BooksListModel yy_modelWithDictionary:request.responseObject];
                if (model.books.count > 0) {
                    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:model.books.count];
                    for (BooksListItemModel *item in model.books) {
                        item.cover = NSStringFormat(@"%@%@", statics_URL, item.cover);
                        XXRankingListLayout *layout = [[XXRankingListLayout alloc] initWithLayout:item];
                        [layouts addObject:layout];
                    }
                    success(layouts);
                }
                else {
                    failure(@"列表为空...");
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                failure([request.error localizedDescription]);
            }];
        }
            break;
            
        default:
            success(@[]);
            break;
    }
}

@end
