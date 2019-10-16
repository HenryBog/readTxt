//
//  XXBookBodyModel+WCTTableCoding.h
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookBodyModel.h"
#import <WCDB/WCDB.h>

@interface XXBookBodyModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(title)
WCDB_PROPERTY(body)
WCDB_PROPERTY(link)

@end
