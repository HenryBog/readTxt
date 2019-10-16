//
//  ReadingManager.m
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ReadingManager.h"
#import "XXDatabase.h"
#import "XXBookModel.h"
#import "XXBookBodyModel.h"

@interface ReadingManager()


@end

@implementation ReadingManager


+ (instancetype)shareReadingManager {
    
    static ReadingManager *readM = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        readM = [[self alloc] init];
        
        BookSettingModel *settingModel = [BookSettingModel decodeModelWithKey:BookSettingModel.className];
        
        if (!settingModel) {
            //没有存档
            settingModel = [[BookSettingModel alloc] init];
            settingModel.font = 20;
            settingModel.dayMode = kDayMode_light;
            settingModel.bgColor = kBgColor_default;
            settingModel.transitionStyle = kTransitionStyle_default;
            [BookSettingModel encodeModel:settingModel key:[BookSettingModel className]];
            
            readM.font = 20;
            readM.dayMode = settingModel.dayMode;
            readM.bgColor = settingModel.bgColor;
            readM.transitionStyle = settingModel.transitionStyle;
            
        } else {
            //已经存档了设置
            readM.isFullTapNext = settingModel.isFullTapNext;
            readM.font = settingModel.font;
            readM.bgColor = settingModel.bgColor;
            readM.transitionStyle = settingModel.transitionStyle;
        }
    });
    
    return readM;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        //code
        
    }
    
    return self;
}


- (void)clear {
    self.chapter = 0;
    self.page = 0;
    self.chapters = nil;
    self.title = nil;
    self.summaryId = nil;
    self.isSave = NO;
}


//请求源数组
- (void)requestSummaryCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    XXSummaryApi *api = [[XXSummaryApi alloc] initWithParameter:nil url:URL_summary(self.bookId)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[SummaryModel class] json:request.responseObject];
        
//        NSMutableArray *summarys = @[].mutableCopy;
//
//        for (SummaryModel *model in arr) {
//            //去掉追书的vip源，你懂得
//            if (!model.starting) {
//                [summarys addObject:model];
//            }
//        }
        
        if (arr.count > 0) {
            self.summaryId = ((SummaryModel *)arr[0])._id;
            XXBookModel *model = [kDatabase getBookWithId:self.bookId];
            model.summaryId = self.summaryId;
            [kDatabase updateBook:model];
        }
        
        completion();
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
}


//请求目录
- (void)requestChaptersWithUseCache:(BOOL)userCache completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    BOOL __block hasCaches = NO;
    if (userCache) {
        NSArray *dbChapters = [kDatabase getChaptersWithSummaryId:self.summaryId];
        
        if (!IsEmpty(dbChapters)) {
            hasCaches = YES;
            self.chapters = dbChapters;
            completion();
        }
    }
    
    XXChaptersApi *api = [[XXChaptersApi alloc] initWithParameter:nil url:URL_chapters(self.summaryId)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XXBookChapterModel class] json:request.responseObject[@"chapters"]];
        
        [kDatabase deleteChaptersWithSummaryId:self.summaryId];
        if ([kDatabase insertChapters:arr summaryId:self.summaryId]) {
            NSLog(@"目录插入成功");
        }
        else {
            NSLog(@"目录插入失败");
        }
        
        if (userCache) {
            if (!hasCaches) {
                self.chapters = arr;
                completion();
            }
            else {
                //如果存在缓存 这里直接覆盖对导致XXBookChapterModel一些记录的数据丢失
                //解决，重新绘制
                NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:arr];
                XXBookChapterModel *model = self.chapters[self.chapter];
                datas[self.chapter] = model;
                self.chapters = datas;
            }
        }
        else {
            self.chapters = arr;
            completion();
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (userCache) {
            if (!hasCaches) {
                failure([request.error localizedDescription]);
            }
        }
        else {
            failure([request.error localizedDescription]);
        }
    }];
}


//请求小说内容
- (void)requestContentWithChapter:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter Completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    if (chapter >= self.chapters.count) {
        failure(@"请求小说内容越界");
        return;
    }
    
    if (self.chapters.count == 0) {
        failure(@"目录为空！");
        return;
    }
    
    //章节内容model
    XXBookChapterModel __block *model = self.chapters[chapter];
    
    //缓存model
    XXBookBodyModel *dbModel = nil;
    if (model.link.length > 0) {
        dbModel = [kDatabase getBookBodyWithLink:model.link bookId:kReadingManager.bookId];
    }
    
    if (dbModel) {
        //有缓存
        model.body = dbModel.body;
        model.status = kbookBodyStatus_success;
        [kReadingManager pagingWithBounds:kReadingFrame withFont:fontSize(self.font) andChapter:model];
        if (ispreChapter) {
            self.page = model.pageCount - 1.0;
        }
        completion();
        return;
    }
    else {
        //没有缓存，显示加载中...
        model.body = @"加载中...";
        model.status = kbookBodyStatus_loading;
        [kReadingManager pagingWithBounds:kReadingFrame withFont:fontSize(self.font) andChapter:model];
        self.page = 0;
        completion();
    }
    
    //请求章节内容
    NSString __block *linkString = model.link;
    XXBookContentApi *api = [[XXBookContentApi alloc] initWithParameter:nil url:URL_bookContent(linkString)];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        XXBookBodyModel *tempModel = [XXBookBodyModel yy_modelWithDictionary:request.responseObject[@"chapter"]];
        if ([linkString containsString:@"vip.zhuishushenqi.com"]) {
            if (tempModel.isVip) {
                model.body = tempModel.body;
            } else {
                model.body = tempModel.cpContent;
            }
        } else {
            model.body = tempModel.body;
        }
        
        //存储章节
        XXBookBodyModel *saveModel = [[XXBookBodyModel alloc] init];
        saveModel.title = model.title;
        saveModel.body = model.body;
        saveModel.link = model.link;
        
        if ([kDatabase insertBookBody:saveModel bookId:kReadingManager.bookId]) {
            NSLog(@"存储boyd成功");
        } else {
            NSLog(@"存储boyd失败");
        }
        
        [kReadingManager pagingWithBounds:kReadingFrame withFont:fontSize(self.font) andChapter:model];
        
        if (ispreChapter && self.chapter == chapter) {
            self.page = model.pageCount - 1.0;
        }
        model.status = kbookBodyStatus_success;
        completion();
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        model.status = kbookBodyStatus_error;
        model.errorString = [request.error localizedDescription];
        [kReadingManager pagingWithBounds:kReadingFrame withFont:fontSize(self.font) andChapter:model];
        self.page = 0;
        completion();
    }];
}


- (void)allowLandscapeRight:(BOOL)allowLandscape {
    
//    kAppDelegate.disagreeRotation = !allowLandscape;
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    if (allowLandscape) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    } else {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}



//画出某章节某页的范围
- (void)pagingWithBounds:(CGRect)bounds withFont:(UIFont *)font andChapter:(XXBookChapterModel *)model {
    
    model.pageDatas = @[].mutableCopy;
    
    if (!model.body) {
        model.body = @"";
    }
    
    NSString *body = [self adjustParagraphFormat:model.body];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:body];
    attr.yy_font = font;
    attr.yy_color = kblackColor;
    
    // 设置label的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AdaWidth(9)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, body.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attr);
    
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
    CFRange range = CFRangeMake(0, 0);
    
    NSUInteger rangeOffset = 0;
    
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, NULL);
        
        range = CTFrameGetVisibleStringRange(frame);
        
        rangeOffset += range.length;
        
        //range.location
        [model.pageDatas addObject:@(range.location)];
        
        if (frame) {
            CFRelease(frame);
        }
    } while (range.location + range.length < attr.length);
    
    if (path) {
        CFRelease(path);
    }
    
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    
    model.pageCount = model.pageDatas.count;
    
    model.attributedString = attr;
}


//获取某章节某一页的内容
- (NSAttributedString *)getStringWithpage:(NSInteger)page andChapter:(XXBookChapterModel *)model {
    if (page < model.pageDatas.count) {
        
        NSUInteger loc = [model.pageDatas[page] integerValue];
        
        NSUInteger len = 0;
        
        if (page == model.pageDatas.count - 1) {
            len = model.attributedString.length - loc;
        } else {
            len = [model.pageDatas[page + 1] integerValue] - loc;
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:[model.attributedString attributedSubstringFromRange:NSMakeRange(loc, len)]];
        
        if (kReadingManager.bgColor == 5) {
            text.yy_color = kwhiteColor;
        } else {
            text.yy_color = kblackColor;
        }
        
        //        return [_content substringWithRange:NSMakeRange(loc, len)];
        return text;
    }
    return [[NSAttributedString alloc] init];
}



// 换行\t制表符，缩进 
- (NSString *)adjustParagraphFormat:(NSString *)string {
    if (!string) {
        return nil;
    }
    string = [@"\t" stringByAppendingString:string];
    string = [string stringByReplacingOccurrencesOfString:@"　　" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n　　"];
    return string;
}


@end
