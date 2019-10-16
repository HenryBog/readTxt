//
//  XXBookDetailVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookDetailVC.h"
#import "XXBookDetailApi.h"
#import "BookDetailModel.h"
#import "XXBookDetailView.h"
#import "XXRankingApi.h"
#import "XXBookReadingVC.h"
#import "XXBookListVC.h"
#import "XXDatabase.h"
#import "XXBookModel.h"

@interface XXBookDetailVC ()

@property (nonatomic, strong) XXBookDetailView *container;

@property (nonatomic, strong) BookDetailModel *model;

@property (nonatomic, strong) NSArray *recommends;

@end

@implementation XXBookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configEmptyView];
    
    [self requestDataWithShowLoading:YES];
    
    [self configEvent];
}

- (void)setupViews {
    
    _container = [[XXBookDetailView alloc] init];
    [self.view addSubview:_container];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)configEmptyView {
    [super configEmptyView];
    
    self.emptyView.refreshDelegate = [RACSubject subject];
    
    MJWeakSelf;
    [self.emptyView.refreshDelegate subscribeNext:^(id  _Nullable x) {
        [weakSelf requestDataWithShowLoading:YES];
    }];
}


- (void)configEvent {
    
    _container.didClickDelegate = [RACSubject subject];
    
    [_container.didClickDelegate subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[NSNumber class]]) {
            
            NSUInteger type = [x integerValue];
            
            switch (type) {
                case kBookDetailType_read: {
                    //开始阅读
                    XXBookReadingVC *vc = nil;
                    XXBookModel *model = [kDatabase getBookWithId:self.model._id];
                    if (model) {
                        //已加入书架
                        vc = [[XXBookReadingVC alloc] initWithBookId:self.model._id bookTitle:self.model.title summaryId:model.summaryId];
                    } else {
                        vc = [[XXBookReadingVC alloc] initWithBookId:self.model._id bookTitle:self.model.title summaryId:@""];
                    }
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];;
                    nav.modalPresentationStyle = 0;
                    [self.navigationController presentViewController:nav animated:YES completion:^{
                        vc.presentComplete = YES;
                    }];
                }
                    
                    break;
                case kBookDetailType_recommendMore: {
                    XXBookListVC *vc = [[XXBookListVC alloc] initWithType:kBookListType_recommend id:_id];
                    vc.navigationItem.title = @"你可能感兴趣";
                    [self pushViewController:vc];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
        } else if ([x isKindOfClass:[BooksListItemModel class]]) {
            
            BooksListItemModel *book = x;
            
            XXBookDetailVC *vc = [[XXBookDetailVC alloc] init];
            vc.title = book.title;
            vc.id = book._id;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (void)requestDataWithShowLoading:(BOOL)show {
    [super requestDataWithShowLoading:show];
    
    MJWeakSelf;
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        XXBookDetailApi *api = [[XXBookDetailApi alloc] initWithParameter:nil url:URL_bookDetail(weakSelf.id)];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            weakSelf.model = [BookDetailModel yy_modelWithDictionary:request.responseObject];
            
            [subscriber sendCompleted];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendError:request.error];
        }];
        
        return nil;
    }] then:^RACSignal * _Nonnull{
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            XXRankingApi *api = [[XXRankingApi alloc] initWithParameter:nil url:URL_recommend(_id)];
            
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                BooksListModel *model = [BooksListModel yy_modelWithDictionary:request.responseObject];
                
                weakSelf.recommends = model.books;
                
                [subscriber sendCompleted];
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [subscriber sendError:request.error];
            }];
            
            return nil;
        }];
    }] subscribeError:^(NSError * _Nullable error) {
        [HUD hide];
        [weakSelf showEmpty:[error localizedDescription] message:nil];
    } completed:^{
        [HUD hide];
        [weakSelf.container configWithModel:weakSelf.model];
        [weakSelf.container configRecommendDatas:weakSelf.recommends];
        weakSelf.emptyView.hidden = YES;
    }];
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
