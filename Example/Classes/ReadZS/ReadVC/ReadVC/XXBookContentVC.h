//
//  XXBookContentVC.h
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadingManager.h"

@protocol XXBookContentVCDelegate <NSObject>



@end

@interface XXBookContentVC : UIViewController

@property (nonatomic, strong) XXBookChapterModel *bookModel;

/** 第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 第几页 */
@property (nonatomic, assign) NSUInteger page;

@end
