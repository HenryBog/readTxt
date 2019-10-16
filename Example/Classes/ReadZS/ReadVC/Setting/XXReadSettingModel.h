//
//  XXReadSettingModel.h
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kReadSettingType) {
    kReadSettingType_transitionStyle,//翻页样式
    kReadSettingType_FullTap, //全屏翻页
};

NS_ASSUME_NONNULL_BEGIN

@interface XXReadSettingModel : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithTitle:(NSString *)title type:(kReadSettingType)type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) kReadSettingType type;

@end

NS_ASSUME_NONNULL_END
