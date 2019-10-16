//
//  XXBookBodyModel.h
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBookBodyModel : NSObject

/** 章节标题 */
@property (nonatomic, copy) NSString *title;

/** 章节内容 */
@property (nonatomic, copy) NSString *body;

/** 追书源章节内容 */
@property (nonatomic, copy) NSString *cpContent;

@property (nonatomic, assign) BOOL isVip;

/** 章节链接 */
@property (nonatomic, copy) NSString *link;


@end
