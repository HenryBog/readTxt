//
//  XXReadSettingVC.m
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import "XXReadSettingVC.h"
#import "XXReadSettingCell.h"


@interface XXReadSettingVC () <XXReadSettingCellDelegate>

@end

@implementation XXReadSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多设置";
    
    [self setupEstimatedRowHeight:54 registerCell:XXReadSettingCell.class];
    
    XXReadSettingModel *m1 = [[XXReadSettingModel alloc] initWithTitle:@"翻页方式" type:kReadSettingType_transitionStyle];
    NSString *title;
    if (kReadingManager.transitionStyle == kTransitionStyle_default) {
        title = @"无动画";
    }
    else if (kReadingManager.transitionStyle == kTransitionStyle_PageCurl) {
        title = @"仿真翻页";
    }
    else if (kReadingManager.transitionStyle == kTransitionStyle_Scroll) {
        title = @"左右翻页";
    }
    
    m1.desc = title;
    [self.datas addObject:m1];
    
    XXReadSettingModel *m2 = [[XXReadSettingModel alloc] initWithTitle:@"点击全屏翻下页" type:kReadSettingType_FullTap];
    m2.isOpen = kReadingManager.isFullTapNext;
    [self.datas addObject:m2];
}


- (void)configListOnpullRefresh {
    
}


- (void)configListDownpullRefresh {
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"XXReadSettingCellID";
    XXReadSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[XXReadSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.delegate = self;
    cell.model = self.datas[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XXReadSettingModel __block *model = self.datas[indexPath.row];
    if (model.type == kReadSettingType_transitionStyle) {
        MJWeakSelf;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"仿真翻页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BookSettingModel *setting = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            setting.transitionStyle = kTransitionStyle_PageCurl;
            [BookSettingModel encodeModel:setting key:[BookSettingModel className]];
            kReadingManager.transitionStyle = kTransitionStyle_PageCurl;
            if (weakSelf.transitionStyleBlock) {
                weakSelf.transitionStyleBlock(kTransitionStyle_PageCurl);
            }
            model.desc = @"仿真翻页";
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"左右翻页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BookSettingModel *setting = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            setting.transitionStyle = kTransitionStyle_Scroll;
            [BookSettingModel encodeModel:setting key:[BookSettingModel className]];
            kReadingManager.transitionStyle = kTransitionStyle_Scroll;
            if (weakSelf.transitionStyleBlock) {
                weakSelf.transitionStyleBlock(kTransitionStyle_Scroll);
            }
            model.desc = @"左右翻页";
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"无动画" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BookSettingModel *setting = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            setting.transitionStyle = kTransitionStyle_default;
            [BookSettingModel encodeModel:setting key:[BookSettingModel className]];
            kReadingManager.transitionStyle = kTransitionStyle_default;
            if (weakSelf.transitionStyleBlock) {
                weakSelf.transitionStyleBlock(kTransitionStyle_default);
            }
            model.desc = @"无动画";
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:a1];
        [alert addAction:a2];
        [alert addAction:a3];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - XXReadSettingCellDelegate

- (void)didClickSwitchByModel:(XXReadSettingModel *)model isOpen:(BOOL)isOpen cell:(XXReadSettingCell *)cell {
    
    kReadingManager.isFullTapNext = isOpen;
    
    BookSettingModel *setting = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    setting.isFullTapNext = isOpen;
    [BookSettingModel encodeModel:setting key:[BookSettingModel className]];
}


@end
