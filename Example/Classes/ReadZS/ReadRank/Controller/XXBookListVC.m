//
//  XXBookListVC.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookListVC.h"
#import "BooksListModel.h"
#import "XXBookDetailVC.h"
#import "XXRankingListCell.h"

@interface XXBookListVC ()

@property (nonatomic, assign) kBookListType booklist_type;

@property (nonatomic, copy) NSString *id;

@end

@implementation XXBookListVC

static NSString *cellId = @"XXRankingListCellID";


- (instancetype)initWithType:(kBookListType)booklist_type id:(NSString *)id {
    if (self = [super init]) {
        _booklist_type = booklist_type;
        _id = id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configEmptyView];
    [self requestDataWithShowLoading:YES];
}


- (void)configEmptyView {
    [super configEmptyView];
    self.emptyView.refreshDelegate = [RACSubject subject];
    MJWeakSelf;
    [self.emptyView.refreshDelegate subscribeNext:^(id  _Nullable x) {
        [weakSelf requestDataWithShowLoading:YES];
    }];
}


- (void)configListOnpullRefresh {

}


- (void)configListDownpullRefresh {
    
}


- (void)requestDataWithOffset:(NSUInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    
    [XXApi getBookListWithListType:self.booklist_type id:self.id success:^(NSArray<XXRankingListLayout *> *list) {
        success(list);
    } failure:^(NSString *errString) {
        failure(errString);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXRankingListLayout *layout = self.datas[indexPath.row];
    return layout.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[XXRankingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLayout:self.datas[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XXRankingListLayout *layout = self.datas[indexPath.row];
    
    XXBookDetailVC *vc = [[XXBookDetailVC alloc] init];
    vc.navigationItem.title = layout.model.title;
    vc.id = layout.model._id;
    
    [self pushViewController:vc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
