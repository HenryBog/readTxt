//
//  XXDatabase.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXBookModel,XXBookChapterModel,XXBookBodyModel;

typedef NS_ENUM(NSInteger, kDataTablaNameType) {
    kDataTablaNameType_body, //小说内容
    kDataTablaNameType_chapter, //小说目录
};

#define kDatabase [XXDatabase shareInstance]

@interface XXDatabase : NSObject


+ (instancetype)shareInstance;


/**
 查找书架是否存在某本书

 @param id <#id description#>
 @return <#return value description#>
 */
- (XXBookModel *)getBookWithId:(NSString *)id;


/**
 插入书架

 @param object <#object description#>
 @return <#return value description#>
 */
- (BOOL)insertBook:(XXBookModel *)object;


/**
 获取书架列表

 @return <#return value description#>
 */
- (NSArray <XXBookModel *>*)getBooks;


/**
 更新书本

 @param object <#object description#>
 @return <#return value description#>
 */
- (BOOL)updateBook:(XXBookModel *)object;


/**
 删除某本书籍

 @param id <#id description#>
 @return <#return value description#>
 */
- (BOOL)deleteBookWithId:(NSString *)id;


/**
 插入章节内容

 @param object XXBookBodyModel
 @param summaryId book id
 @return <#return value description#>
 */
- (BOOL)insertBookBody:(XXBookBodyModel *)object bookId:(NSString *)bookId;


/**
 查询章节内容

 @param ink <#ink description#>
 @param bookId <#bookId description#>
 @return <#return value description#>
 */
- (XXBookBodyModel *)getBookBodyWithLink:(NSString *)link bookId:(NSString *)bookId;


/**
 插入小说目录

 @param objects XXBookChapterModel
 @param summaryId 源ID作为表名
 @return <#return value description#>
 */
- (BOOL)insertChapters:(NSArray <XXBookChapterModel *>*)objects summaryId:(NSString *)summaryId;


/**
 获取小说目录

 @param summaryId 源ID作为表名
 @return <#return value description#>
 */
- (NSArray <XXBookChapterModel *>*)getChaptersWithSummaryId:(NSString *)summaryId;


/**
 清空小说目录

 @param summaryId  源ID作为表名
 @return <#return value description#>
 */
- (BOOL)deleteChaptersWithSummaryId:(NSString *)summaryId;


/**
 目录用源id拼接区分，内容表直接使用book id 拼接 这样就能让内容表有唯一性，使用link作为主键

 @param nameType <#nameType description#>
 @param name <#name description#>
 @return <#return value description#>
 */
- (NSString *)getTableNameWithType:(kDataTablaNameType)nameType name:(NSString *)name;


/**
 删除表

 @param tableName <#tableName description#>
 @return <#return value description#>
 */
- (BOOL)dropTableName:(NSString *)tableName;

@end
