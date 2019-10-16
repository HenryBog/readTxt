//
//  XXBookUpdateModel.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBookUpdateModel : NSObject

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *referenceSource;

@property (nonatomic, copy) NSString *updated;

@property (nonatomic, copy) NSString *lastChapter;

@property (nonatomic, assign) NSInteger chaptersCount;

@end
