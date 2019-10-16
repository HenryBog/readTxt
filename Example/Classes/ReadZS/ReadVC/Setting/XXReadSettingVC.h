//
//  XXReadSettingVC.h
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXReadSettingVC : BaseTableViewController

@property (nonatomic, copy) void(^transitionStyleBlock)(kTransitionStyle style);

@end

NS_ASSUME_NONNULL_END
