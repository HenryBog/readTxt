//
//  XXBookModel.mm
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookModel+WCTTableCoding.h"
#import "XXBookModel.h"
#import <WCDB/WCDB.h>

@implementation XXBookModel

WCDB_IMPLEMENTATION(XXBookModel)
WCDB_SYNTHESIZE(XXBookModel, id)
WCDB_SYNTHESIZE(XXBookModel, summaryId)
WCDB_SYNTHESIZE(XXBookModel, coverURL)
WCDB_SYNTHESIZE(XXBookModel, title)
WCDB_SYNTHESIZE(XXBookModel, updateStatus)
WCDB_SYNTHESIZE(XXBookModel, page)
WCDB_SYNTHESIZE(XXBookModel, updated)
WCDB_SYNTHESIZE(XXBookModel, chapter)
WCDB_SYNTHESIZE(XXBookModel, lastChapter)
WCDB_SYNTHESIZE(XXBookModel, addTime)

// 约束宏定义数据库的主键
WCDB_PRIMARY(XXBookModel, id)

@end
