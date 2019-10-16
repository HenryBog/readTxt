//
//  BaseTableViewController.h
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewProtocol.h"
#import "BaseTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, BaseTableViewProtocol>

@property (nonatomic, strong) BaseTableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;


/** 分页 */
@property (nonatomic, assign) int page;


/** 初始页 一般0或者1 */
@property (nonatomic, assign) int initialPage;

/**
 初始化tableView，默认在init方法初始化了，样式默认UITableViewStylePlain，需要定制可以重写init方法
 - (instancetype)init {
 if (self) {
 //重写
 }
 return self;
 }
 
 @param style <#style description#>
 */
- (void)initTableViewStyle:(UITableViewStyle)style;


/**
 配置tableview的估算行高和注册的cell
 
 @param height 估算行高
 @param cellClass 注册cell class
 */
- (void)setupEstimatedRowHeight:(CGFloat)height registerCell:(Class)cellClass;

@end
