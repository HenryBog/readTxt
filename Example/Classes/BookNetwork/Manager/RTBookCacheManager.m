//
//  RTBookCacheManager.m
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import "RTBookCacheManager.h"

//
#define RTBookFile @"BookList"

@interface RTBookCacheManager ()
@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, copy) NSString *BookFile;

@end

@implementation RTBookCacheManager

+ (id)shareManager {
    static RTBookCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[RTBookCacheManager alloc] init];
        manager.fileManager = [NSFileManager defaultManager];
    });
    return manager;
}

//写入书籍目录
- (NSString *)bookFileWihtBookID:(NSString *)bookid {
    NSString *path = [self filePath:[NSString stringWithFormat:@"%@/%@",RTBookFile,bookid]];
    if (1) {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (RTBookDirectoryModel *)bookDetailModelWithBookId:(NSString *)bookid chapter_id:(NSString *)chapter_id {
    __block RTBookDirectoryModel *newModel;
    NSArray *arr = [self getRTBookFileWithBookid:bookid];
    if (arr.count > 0) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTBookDirectoryModel *bookModel = obj;
            if ([bookModel.chapter_id isEqualToString:chapter_id]) {
                newModel = bookModel;
                *stop = YES;
            }
        }];
    }
    return newModel;
}

- (RTBookDirectoryModel *)bookWriteWithModel:(RTBookDetailModel *)model {
    
    __block RTBookDirectoryModel *newModel;
    NSArray *arr = [self getRTBookFileWithBookid:model.book_id];
    if (arr.count > 0) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTBookDirectoryModel *bookModel = obj;
            if ([bookModel.chapter_id isEqualToString: model.chapter_id]) {
                if (!bookModel.bookDetailModel) {
                    bookModel.bookDetailModel = [[RTBookDetailModel alloc] init];
                }
                bookModel.bookDetailModel = model;
                newModel = bookModel;
                *stop = YES;
            }
        }];
    } else {
        newModel = [[RTBookDirectoryModel alloc] init];
        newModel.bookDetailModel = [[RTBookDetailModel alloc] init];
        newModel.bookDetailModel = model;
        arr = @[newModel];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.plist",[self bookFileWihtBookID:model.book_id],model.book_id];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:arr forKey:model.book_id];
    [archiver finishEncoding];
    [data writeToFile:fileName atomically:YES ];
    return newModel;
}


//经过限制，返回的数组都会是有值的，不管是不是首次进入程序
- (NSArray<RTBookDetailModel *> *)getRTBookFileWithBookid:(NSString *)bookid {
    NSArray *arr = [NSArray array];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.plist",[self bookFileWihtBookID:bookid],bookid];
    NSData* data = [NSData dataWithContentsOfFile:fileName];
    if ([data length] > 0) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *array = [unArchiver decodeObjectForKey:bookid];
        [unArchiver finishDecoding];
        if(array && array.count > 0){
            return  array;
        } else {
            return arr;
        }
    } else {
        return arr;
    }
}

- (void)saveRTBookFileWithArray:(NSArray<RTBookDetailModel *> *)array {
    if (array.count < 1) {
        return ;
    }
    RTBookDetailModel *model = array.firstObject;
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.plist",[self bookFileWihtBookID:model.book_id],model.book_id];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSArray *bookModelArray = [self getRTBookFileWithBookid:model.book_id];
    if (bookModelArray.count > 0) {
        array = [self redundantArrayWithOriginalArray:bookModelArray newArray:array];
    }
    
    [archiver encodeObject:array forKey:model.book_id];
    [archiver finishEncoding];
    [data writeToFile:fileName atomically:YES ];
}

- (NSString *)filePath:(NSString *)fileName {
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filePath = [myDocPath stringByAppendingPathComponent:fileName];
    return filePath;
}

//originalArray 旧数组  newArray 新的数组
- (NSArray *)redundantArrayWithOriginalArray:(NSArray *)originalArray newArray:(NSArray *)newArray {
    if (originalArray.count == 0 || newArray.count == 0) {
        return nil;
    }
    NSMutableArray *redundantArray = [NSMutableArray array];
    [originalArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newArray enumerateObjectsUsingBlock:^(id  _Nonnull existedObj, NSUInteger subidx, BOOL * _Nonnull substop) {
            if ([obj isEqual:existedObj]) {
                [redundantArray addObject:obj];
                *substop = YES;
            }
        }];
    }];
    return [redundantArray copy];
}

- (BOOL)writeContent:(NSString *)content writeFile:(NSString *)file {
    if (content.length < 1 || file.length < 1) {
        return NO;
    }
    NSError *error = nil;
    [content writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
        return NO;
    }
    return YES;
}

@end
