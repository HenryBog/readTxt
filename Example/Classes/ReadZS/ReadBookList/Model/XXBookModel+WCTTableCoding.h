//
//  XXBookModel+WCTTableCoding.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookModel.h"
#import <WCDB/WCDB.h>

@interface XXBookModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(summaryId)
WCDB_PROPERTY(coverURL)
WCDB_PROPERTY(title)
WCDB_PROPERTY(updateStatus)
WCDB_PROPERTY(page)
WCDB_PROPERTY(updated)
WCDB_PROPERTY(chapter)
WCDB_PROPERTY(lastChapter)
WCDB_PROPERTY(addTime)
WCDB_PROPERTY(id)

@end
