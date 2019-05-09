//
//  RTReadTxtViewController.h
//  CYLTabBarController
//
//  Created by Henry on 2019/5/9.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LSYReadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTReadTxtViewController : UIViewController
@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic,strong) LSYReadModel *model;

@end

NS_ASSUME_NONNULL_END
