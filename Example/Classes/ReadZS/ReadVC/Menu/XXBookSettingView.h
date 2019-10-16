//
//  XXBookSettingView.h
//  Novel
//
//  Created by app on 2018/1/22.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseView.h"

@interface XXBookSettingView : BaseView


/**
 设置白天背景颜色

 @param bgColor <#bgColor description#>
 */
- (void)changeLightbgColorSeleted:(kBgColor)bgColor;

- (void)changeNight;


/** 字体缩小 */
@property (nonatomic, copy) void(^changeSmallerFontBlock)();

/** 字体放大 */
@property (nonatomic, copy) void(^changeBiggerFontBlock)();

/** 横竖屏切换 */
//@property (nonatomic, copy) void(^landspaceBlock)();

/** 更多设置 */
@property (nonatomic, copy) void(^moreSettingBlock)();

@end
