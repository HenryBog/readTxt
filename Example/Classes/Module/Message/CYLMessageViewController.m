//
//  CYLMessageViewController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLMessageViewController.h"
#import "CYLTabBarController.h"

#import "LSYReadViewController.h"
#import "LSYReadPageViewController.h"
#import "LSYReadUtilites.h"
#import "LSYReadModel.h"

#import "RTHaoKanRead.h"
#import "NSArray+YYAdd.h"
#import "RTBookCacheManager.h"
#import "RTReadTxtViewController.h"

@interface CYLMessageViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger count;

@end

@implementation CYLMessageViewController

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",NSHomeDirectory());
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    self.bookId = @"448";
    self.limit = @"1626";
    [self loadRTBookListData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray array];
        _dataArray = dataArray;
    }
    return _dataArray;
}

- (void)loadRTBookListData {
    __weak typeof(self) weakSelf=self;
    [RTHaoKanRead loadBookDirectoryWith:self.bookId sort:@"asc" limit:self.limit block:^(NSArray<RTBookDirectoryModel *> * _Nonnull array, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"出问题了");
            return ;
        }
        if (array.count > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
            __strong typeof(self) self = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Methods
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    RTBookDirectoryModel *model = [self.dataArray objectOrNilAtIndex:indexPath.row];
    if (model) {
        NSString *name = [NSString stringWithFormat:@"%@ ___ %@", model.chapter_title, model.chapter_id];
        [[cell textLabel] setText:name];
    }
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RTBookDirectoryModel *model = [self.dataArray objectOrNilAtIndex:indexPath.row];
    if (model) {
        self.count = 1;
        [self loadBookDetailReadWithBookid:self.bookId chapter_id:model.chapter_id];
    }
}

- (void)loadBookDetailReadWithBookid:(NSString *)bookId chapter_id:(NSString *)chapter_id {
    __weak typeof(self)weakSelf = self;
    [RTHaoKanRead loadBookDetailReadWithBookid:bookId chapter_id:chapter_id block:^(RTBookDirectoryModel *model, NSError * _Nonnull error) {
        __strong typeof(self)self = weakSelf;
        NSLog(@"%@",model.bookDetailModel.content);
        if (model && model.bookDetailModel && model.bookDetailModel.content > 0) {
            
            [weakSelf redBookWithModel:model];
//            self.count += 1;
//            if (model.book_id && model.bookDetailModel.nextChapter_id && self.count < 30) {
//                [self loadBookDetailReadWithBookid:model.book_id chapter_id:model.bookDetailModel.nextChapter_id];
//            }
        }
    }];
}

- (void)redBookWithModel:(RTBookDirectoryModel *)model {
    
    RTReadTxtViewController *pageView = [[RTReadTxtViewController alloc] init];
    
    NSString *fileName = [[RTBookCacheManager shareManager] bookFileWihtBookID:model.book_id];
    fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"%@/%@.plist",self.bookId,self.bookId]];
    NSURL *fileURL = [NSURL URLWithString:fileName];
    //文件位置
    pageView.resourceURL = fileURL;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:fileURL rtBookDirectoryModel:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

////    if (indexPath.row %3 == 0) {
//        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
//        pageView.resourceURL = fileURL;    //文件位置
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self presentViewController:pageView animated:YES completion:nil];
//            });
//        });
//    } else  if (indexPath.row %3 == 1) {
//        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
//        pageView.resourceURL = fileURL;    //文件位置
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self presentViewController:pageView animated:YES completion:nil];
//            });
//        });
//    } else {
//        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"细说明朝"withExtension:@"epub"];
//        pageView.resourceURL = fileURL;    //文件位置
//        pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];  //阅读模型
//        [self presentViewController:pageView animated:YES completion:nil];
//    }
//}

@end
