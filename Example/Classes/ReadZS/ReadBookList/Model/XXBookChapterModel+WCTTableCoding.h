//
//  XXBookChapterModel+WCTTableCoding.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookChapterModel.h"
#import <WCDB/WCDB.h>

@interface XXBookChapterModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(title)
WCDB_PROPERTY(link)

@end
