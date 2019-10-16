//
//  XXDatabase.mm
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXDatabase+WCTTableCoding.h"
#import "XXDatabase.h"
#import <WCDB/WCDB.h>
#import "XXBookModel+WCTTableCoding.h"
#import "XXBookChapterModel+WCTTableCoding.h"
#import "XXBookBodyModel+WCTTableCoding.h"


@interface XXDatabase ()

@property (nonatomic, strong) WCTDatabase *database;

@end

@implementation XXDatabase


+ (instancetype)shareInstance {
    
    static XXDatabase * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XXDatabase alloc] init];
    });
    
    return instance;
}


- (WCTDatabase *)database {
    if (_database) return _database;
    _database = [[WCTDatabase alloc] initWithPath:[NSString getDBPath]];
    if ([_database canOpen]) {
        if ([_database isOpened]) {
            if ([_database isTableExists:kBookTableName]) {
                NSLog(@"kBookTableName表已经存在");
            } else {
                NSLog(@"创建kBookTableName表");
                [_database createTableAndIndexesOfName:kBookTableName withClass:XXBookModel.class];
            }
        }
    }
    return _database;
}


//查找书架是否存在某本书
- (XXBookModel *)getBookWithId:(NSString *)id {
    XXBookModel *object = [self.database getOneObjectOfClass:XXBookModel.class fromTable:kBookTableName where:XXBookModel.id == id];
    return object;
}


//插入书架
- (BOOL)insertBook:(XXBookModel *)object {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970]*1000;
    object.addTime = interval;
    return [self.database insertObject:object into:kBookTableName];
}


//获取书架列表
- (NSArray <XXBookModel *>*)getBooks {
    return [self.database getObjectsOfClass:XXBookModel.class fromTable:kBookTableName orderBy:XXBookModel.addTime.order(WCTOrderedDescending)];
}


//更新书本
- (BOOL)updateBook:(XXBookModel *)object {
    return [self.database updateRowsInTable:kBookTableName onProperties:{XXBookModel.summaryId, XXBookModel.updateStatus, XXBookModel.chapter, XXBookModel.page, XXBookModel.updated, XXBookModel.lastChapter} withObject:object where:XXBookModel.id == object.id];
}


//删除某本书籍
- (BOOL)deleteBookWithId:(NSString *)id {
    return [self.database deleteObjectsFromTable:kBookTableName where:XXBookModel.id == id];
}


//插入章节内容
- (BOOL)insertBookBody:(XXBookBodyModel *)object bookId:(NSString *)bookId {
    NSString *name = [self getTableNameWithType:kDataTablaNameType_body name:bookId];
    [self createTableName:name class:XXBookBodyModel.class];
    return [self.database insertObject:object into:name];
}


//查询章节内容
- (XXBookBodyModel *)getBookBodyWithLink:(NSString *)link bookId:(NSString *)bookId {
    NSString *name = [self getTableNameWithType:kDataTablaNameType_body name:bookId];
    [self createTableName:name class:XXBookBodyModel.class];
    return [self.database getOneObjectOfClass:XXBookBodyModel.class fromTable:name where:XXBookBodyModel.link == link];
}


//插入小说目录
- (BOOL)insertChapters:(NSArray <XXBookChapterModel *>*)objects summaryId:(NSString *)summaryId {
    NSString *name = [self getTableNameWithType:kDataTablaNameType_chapter name:summaryId];
    [self createTableName:name class:XXBookChapterModel.class];
    return [self.database insertObjects:objects into:name];
}


//获取小说目录
- (NSArray <XXBookChapterModel *>*)getChaptersWithSummaryId:(NSString *)summaryId {
    NSString *name = [self getTableNameWithType:kDataTablaNameType_chapter name:summaryId];
    [self createTableName:name class:XXBookChapterModel.class];
    return [self.database getAllObjectsOfClass:XXBookChapterModel.class fromTable:name];
}


//清空小说目录
- (BOOL)deleteChaptersWithSummaryId:(NSString *)summaryId {
    return [self.database deleteAllObjectsFromTable:[self getTableNameWithType:kDataTablaNameType_chapter name:summaryId]];
}


//创建表
- (BOOL)createTableName:(NSString *)name class:(Class)clasz {
    if (![self.database isTableExists:name]) {
        return [self.database createTableAndIndexesOfName:name withClass:clasz];
    }
    return NO;
}


//目录用源id拼接区分，内容表直接使用book id 拼接 这样就能让内容表有唯一性，使用link作为主键
- (NSString *)getTableNameWithType:(kDataTablaNameType)nameType name:(NSString *)name {
    if (nameType == kDataTablaNameType_body) {
        static NSString *id = @"XXBody";
        name = NSStringFormat(@"%@%@", id, name);
    }
    else if (nameType == kDataTablaNameType_chapter) {
        static NSString *id = @"XXChapter";
        name = NSStringFormat(@"%@%@", id, name);
    }
    return name;
}


//删除表
- (BOOL)dropTableName:(NSString *)tableName {
    return [self.database dropTableOfName:tableName];
}

@end
