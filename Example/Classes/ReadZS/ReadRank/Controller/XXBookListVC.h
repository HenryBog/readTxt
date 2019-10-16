//
//  XXBookListVC.h
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseTableViewController.h"
#import "XXApi.h"

@interface XXBookListVC : BaseTableViewController


- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithType:(kBookListType)booklist_type id:(NSString *)id;

@end
