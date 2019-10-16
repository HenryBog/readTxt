//
//  xxBookShelfVC.m
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookShelfVC.h"
#import "XXBookShelfCell.h"
#import "XXUpdateChapterApi.h"
#import "XXBookReadingVC.h"
#import "XXBookUpdateModel.h"
#import "XXDatabase.h"
#import "XXBookModel.h"

@interface XXBookShelfVC ()

@end

@implementation XXBookShelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self configEmptyView];
    
    [self setupEstimatedRowHeight:AdaWidth(65) registerCell:[XXBookShelfCell class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelf:) name:kReloadBookShelfNotification object:nil];
}

#pragma mark - 接收通知，刷新界面
- (void)reloadSelf:(NSNotification *)sender {
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:[kDatabase getBooks]];
    [self.tableView reloadData];
    self.emptyView.hidden = self.datas.count;
}


- (void)configListDownpullRefresh {
    
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:[kDatabase getBooks]];
    self.emptyView.hidden = self.datas.count;
    
    MJWeakSelf;
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.initialPage;
        [weakSelf requestDataWithShowLoading:NO];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)configListOnpullRefresh {

}


- (void)configEmptyView {
    [super configEmptyView];
    [self.emptyView showImage:nil title:@"您还没有添加书籍，点击添加哦" message:nil];
    self.emptyView.titleMarginTop = -(self.view.height/2 - 100);
    self.emptyView.refreshDelegate = [RACSubject subject];
    [self.emptyView.refreshDelegate subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToRankingVC" object:nil];
    }];
}

- (NSString *)componentsJoineWithArrID:(NSArray *)array {
    
    if (!IsEmpty(array)) {
        NSMutableArray *temps = @[].mutableCopy;
        for (XXBookModel *model in array) {
            [temps addObject:model.id];
        }
        return [temps componentsJoinedByString:@","];
    } else {
        return @"";
    }
}

- (void)requestDataWithOffset:(NSUInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {

    XXUpdateChapterApi *api = [[XXUpdateChapterApi alloc] initWithParameter:@{@"view": @"updated", @"id": [self componentsJoineWithArrID:self.datas]} url:URL_bookShelf_update];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *updates = [NSArray yy_modelArrayWithClass:[XXBookUpdateModel class] json:request.responseString];
        
        for (int i = 0; i < updates.count; i++) {

            XXBookModel *m1 = self.datas[i];
            XXBookUpdateModel *m2 = updates[i];
            
            //status=0 -->NO 不显示  status=1 -->YES 显示
            if (![m1.lastChapter isEqualToString:m2.lastChapter]) {
                //有更新
                m1.updated = m2.updated;
                m1.lastChapter = m2.lastChapter;
                m1.updateStatus = YES;
                
                [kDatabase updateBook:m1];
            }
        }

        [self.tableView reloadData];
        [self endRefresh];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (self.datas.count == 0) {
            self.emptyView.hidden = NO;
        }
        else {
            [HUD showError:[api.error localizedDescription] inview:self.view];
        }
        [self endRefresh];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XXBookModel *model = self.datas[indexPath.row];

    XXBookReadingVC *vc = [[XXBookReadingVC alloc] initWithBookId:model.id bookTitle:model.title summaryId:model.summaryId];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];;
    nav.modalPresentationStyle = 0;
    [self.navigationController presentViewController:nav animated:YES completion:^{
        vc.presentComplete = YES;
    }];
}


- (void)configCellSubViewsCallback:(XXBookShelfCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    MJWeakSelf;
    cell.cellLongPress = ^(UILongPressGestureRecognizer *longPress) {
        switch (longPress.state) {
            case UIGestureRecognizerStateBegan: //开始
            {
                XXBookModel *model = self.datas[indexPath.row];
                
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:model.title message:@"删除所选书籍及缓存文件？" ];
                
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                }];
                
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                    if ([kDatabase deleteBookWithId:model.id]) {
                        //删除缓存的内容表
                        NSString *name = [kDatabase getTableNameWithType:kDataTablaNameType_body name:model.id];
                        [kDatabase dropTableName:name];
                        
                        [weakSelf.datas removeAllObjects];
                        [weakSelf.datas addObjectsFromArray:[kDatabase getBooks]];
                        [weakSelf.tableView reloadData];
                        
                        if (IsEmpty(weakSelf.datas)) {
                            [weakSelf showEmpty:@"书架空空如也" message:nil];
                        }
                        NSLog(@"%@--删除成功",model.title);
                    }
                    else {
                        [HUD showError:@"删除失败" inview:weakSelf.view];
                    }
                }];
                
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                
                [self presentViewController:alertVC animated:NO completion:nil];
            }
                
                break;
            case UIGestureRecognizerStateChanged: //移动
                
                break;
            case UIGestureRecognizerStateEnded: //结束
                
                break;
                
            default:
                break;
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
