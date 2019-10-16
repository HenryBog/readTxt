//
//  XXReadSettingCell.h
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "XXReadSettingModel.h"
@class XXReadSettingCell;

NS_ASSUME_NONNULL_BEGIN

@protocol XXReadSettingCellDelegate <NSObject>

- (void)didClickSwitchByModel:(XXReadSettingModel *)model isOpen:(BOOL)isOpen cell:(XXReadSettingCell *)cell;

@end

@interface XXReadSettingCell : BaseTableViewCell

@property (nonatomic, strong) XXReadSettingModel *model;

@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, strong) UIView *lineView;

@property(nonatomic, weak) id<XXReadSettingCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
