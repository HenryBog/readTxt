//
//  XXBookBodyModel.mm
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookBodyModel+WCTTableCoding.h"
#import "XXBookBodyModel.h"
#import <WCDB/WCDB.h>

@implementation XXBookBodyModel

WCDB_IMPLEMENTATION(XXBookBodyModel)
WCDB_SYNTHESIZE(XXBookBodyModel, title)
WCDB_SYNTHESIZE(XXBookBodyModel, body)
WCDB_SYNTHESIZE(XXBookBodyModel, link)
// 约束宏定义数据库的主键
WCDB_PRIMARY(XXBookBodyModel, link)

@end
