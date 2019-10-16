//
//  BaseTableViewController.m
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) Class cellClass;

@end

@implementation BaseTableViewController


- (instancetype)init {
    self = [super init];
    if (self){
        [self initTableViewStyle:UITableViewStylePlain];
    }
    return self;
}


- (void)initTableViewStyle:(UITableViewStyle)style {
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:style];
    _tableView.backgroundColor = kclearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (void)viewDidLoad {
    
    _initialPage = 1;
    _page = _initialPage;
    
    _datas = [[NSMutableArray alloc] init];
    
    [self configListView];
    
    [self configListDownpullRefresh];
    
    [self configListOnpullRefresh];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setupEstimatedRowHeight:(CGFloat)height registerCell:(Class)cellClass {
    _tableView.estimatedRowHeight = height;
    self.cellClass = cellClass;
    [_tableView registerClass:self.cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellClass isSubclassOfClass:[BaseTableViewCell class]]) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
        [cell configWithModel:self.datas[indexPath.row]];
        [self configCellSubViewsCallback:cell indexPath:indexPath];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellClass isSubclassOfClass:[BaseTableViewCell class]]) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.cellClass) cacheByIndexPath:indexPath configuration:^(BaseTableViewCell *cell) {
            [cell configWithModel:self.datas[indexPath.row]];
        }];
    }
    return 0;
}


- (void)configEmptyView {
    [super configEmptyView];
    [self.emptyView configEdgesSuperView:self.tableView];
}


#pragma mark - BaseTableViewProtocol

- (void)configListView {
    if (_tableView) {
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}


/**
 配置list控件 下拉刷新
 */
- (void)configListDownpullRefresh {
    MJWeakSelf;
    _tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.initialPage;
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf requestDataWithShowLoading:NO];
    }];
}


/**
 配置list控件 上拉刷新
 */
- (void)configListOnpullRefresh {
    MJWeakSelf;
    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        if (IsEmpty(weakSelf.datas)) {
            weakSelf.page = weakSelf.initialPage;
        } else {
            weakSelf.page++;
        }
        [weakSelf requestDataWithShowLoading:NO];
    }];
}


- (void)endRefresh {
    if (self.tableView.mj_header.refreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    else if (self.tableView.mj_footer.refreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)showEmpty:(NSString *)errorTitle message:(NSString *)errorMessage {
    
    dispatch_async_on_main_queue(^{
        [HUD hide];
        self.errorTitle = errorTitle;
        if (self.page == self.initialPage) {
            if (!IsEmpty(self.datas) && errorTitle.length > 0) {
                //不为空
                self.emptyView.hidden = YES;
                if (errorTitle.length > 0) {
                    [HUD showError:errorTitle inview:self.view];
                }
                //            self.tableView.hidden = NO;
                return;
            }
            
            [self.emptyView updateTitle:errorTitle message:errorMessage];
            self.emptyView.hidden = NO;
            //        self.tableView.hidden = YES;
            
        } else {
            if (errorTitle.length > 0) {
                [HUD showError:errorTitle inview:self.view];
            }
            self.emptyView.hidden = YES;
            //        self.tableView.hidden = NO;
        }
    });
}


- (void)requestDataWithShowLoading:(BOOL)show {
    [super requestDataWithShowLoading:show];
    
    MJWeakSelf;
    [self requestDataWithOffset:self.page success:^(NSArray *dataArr) {
        [HUD hide];
        [weakSelf endRefresh];
        weakSelf.tableView.hidden = NO;
        weakSelf.emptyView.hidden = YES;
        if (weakSelf.page == weakSelf.initialPage && IsEmpty(dataArr)) {
            //没有数据的时候
            [weakSelf showEmpty:@"没有数据..." message:nil];
            return;
        }
        else if (weakSelf.page == weakSelf.initialPage) {
            //第一次加载数据
            [weakSelf.datas removeAllObjects];
            [weakSelf.datas addObjectsFromArray:dataArr];
            dispatch_async_on_main_queue(^{
                [weakSelf.tableView reloadData];
            });
            
            return;
        }
        else if (weakSelf.page > weakSelf.initialPage && IsEmpty(dataArr)) {
            //加载没有更多数据的时候
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        else if (weakSelf.page > weakSelf.initialPage && !IsEmpty(dataArr)) {
            //上拉刷新
            
            [weakSelf.datas addObjectsFromArray:dataArr];
            
            dispatch_async_on_main_queue(^{
                weakSelf.tableView.hidden = YES;
                [weakSelf.tableView reloadData];
                weakSelf.tableView.hidden = NO;
            });
            
            return;
        }
    } failure:^(NSString *msg) {
        [weakSelf endRefresh];
        [weakSelf showEmpty:msg message:nil];
    }];
}


- (void)configCellSubViewsCallback:(id)cell
                         indexPath:(NSIndexPath *)indexPath {
    
}


- (void)requestDataWithOffset:(NSUInteger)page
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
