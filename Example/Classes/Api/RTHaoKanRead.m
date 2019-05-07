//
//  RTHaoKanRead.m
//  CYLTabBarController
//
//  Created by Henry on 2019/4/30.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import "RTHaoKanRead.h"

static NSString *RTHaoKanReadUrl = @"http://porth5.haokanread.com";
static NSString *RTBookRead = @"/book/read";

@implementation RTHaoKanRead


+ (void)loadBookDetailRead {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:RTBookRead] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    //    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[self requestBodyWithBook_id:@"34"] options:0 error:nil];
    NSString *body = @"book_id=34&user_id=&chapter_id=0";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
        }
    }] resume];
}

@end
