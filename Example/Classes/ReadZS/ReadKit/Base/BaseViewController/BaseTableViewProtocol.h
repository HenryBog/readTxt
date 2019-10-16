//
//  BaseTableViewProtocol.h
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#ifndef BaseTableViewProtocol_h
#define BaseTableViewProtocol_h

@protocol BaseTableViewProtocol <NSObject>

/**
 配置list控件 位置
 */
- (void)configListView;


/**
 配置list控件 下拉刷新
 */
- (void)configListDownpullRefresh;


/**
 配置list控件 上拉刷新
 */
- (void)configListOnpullRefresh;


/**
 当cell里的子控件需要些block回调时重载该方法
 
 @param cell <#cell description#>
 @param indexPath <#indexPath description#>
 */
- (void)configCellSubViewsCallback:(id)cell
                         indexPath:(NSIndexPath *)indexPath;


/**
 必须重写该方法，请求列表数据
 
 @param page 页数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)requestDataWithOffset:(NSUInteger)page
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure;


/**
 停止刷新和隐藏loading
 */
- (void)endRefresh;


@end

#endif /* BaseTableViewProtocol_h */
