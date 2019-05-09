//
//  RTHaoKanRead.m
//  CYLTabBarController
//
//  Created by Henry on 2019/4/30.
//

#import "RTHaoKanRead.h"
#import "NSObject+YYModel.h"
#import "NSDictionary+YYAdd.h"
#import "RTBookCacheManager.h"

//好看
static NSString *RTHaoKanReadUrl = @"http://porth5.haokanread.com";
//阅读
static NSString *RTBookRead = @"/book/read";
//书列表
static NSString *RTBookDirectory = @"/book/directory";

@implementation RTHaoKanRead


+ (void)loadBookDetailReadWithBookid:(NSString *)bookid chapter_id:(NSString *)chapter_id block:(void(^)(RTBookDirectoryModel *model, NSError *error))block {
    RTBookDirectoryModel *model = [[RTBookCacheManager shareManager] bookDetailModelWithBookId:bookid chapter_id:chapter_id];
    if (model && model.bookDetailModel && model.bookDetailModel.content > 0) {
        block(model,nil);
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RTHaoKanReadUrl,RTBookRead]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSString *body = [NSString stringWithFormat:@"book_id=%@&user_id=&chapter_id=%@", bookid, chapter_id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block(nil, error);
            return ;
        } else {
            RTDataModel *dataModel = [RTDataModel modelWithJSON:data];
            if (dataModel && dataModel.code.integerValue == 200) {
                RTBookDetailModel *model = [RTBookDetailModel modelWithJSON:dataModel.data];
                if ([dataModel.extra containsObjectForKey:@"pre"]) {
                    model.lastChapter_id = [dataModel.extra stringValueForKey:@"pre" default:@""];
                }
                if ([dataModel.extra containsObjectForKey:@"next"]) {
                    model.nextChapter_id = [dataModel.extra stringValueForKey:@"next" default:@""];
                }
               RTBookDirectoryModel *newModel = [[RTBookCacheManager shareManager] bookWriteWithModel:model];
                block(newModel,nil);
            } else {
                error = [[NSError alloc] initWithDomain:dataModel.msg ?: @"" code:dataModel.code.integerValue userInfo:nil];
                block(nil, error);
            }
        }
    }] resume];
}

+ (void)loadBookDirectoryWith:(NSString *)bookId sort:(NSString *)sort limit:(NSString *)limit block:(void(^)(NSArray <RTBookDirectoryModel *>*array, NSError *error))block {
    if (bookId.length < 1) {
        NSLog(@"bookid 为空");
    }
    NSArray *array = [[RTBookCacheManager shareManager] getRTBookFileWithBookid:bookId];
    if (array.count > 0 && array.count == limit.integerValue) {
        block(array,nil);
        return;
    }
    NSError *error = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RTHaoKanReadUrl, RTBookDirectory]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSString *body = [NSString stringWithFormat: @"book_id=%@&sort=%@&page=1&limit=%@", bookId?: @"", sort ?: @"asc" , limit?:@"1"];
    
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block(nil, error);
            return ;
        } else {
            RTDataModel *dataModel = [RTDataModel modelWithJSON:data];
            if (dataModel && dataModel.code.integerValue == 200) {
                NSArray *list = [NSArray modelArrayWithClass:[RTBookDirectoryModel class] json:dataModel.data];
                if (list.count > 0) {
                    RTBookDirectoryModel *model = list.firstObject;
                    model.count = [dataModel.extra stringValueForKey:@"count" default:@"0"];
                }
                [[RTBookCacheManager shareManager] saveRTBookFileWithArray:list];
                block(list,nil);
            } else {
                error = [[NSError alloc] initWithDomain:dataModel.msg ?: @"" code:dataModel.code.integerValue userInfo:nil];
                block(nil, error);
            }
        }
    }] resume];
}



@end
