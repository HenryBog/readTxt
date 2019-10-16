//
//  YYTextLayout+Add.m
//  xx
//
//  Created by th on 2017/5/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import "YYTextLayout+Add.h"

@implementation YYTextLayout (Add)

+ (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_font = font;
    text.yy_color = color;
    text.yy_lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (lineSpace > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        
        paragraphStyle.lineSpacing = lineSpace;
        
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    }
    
    YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
    container.maximumNumberOfRows = maximumNumberOfRows;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    return layout;
}


+ (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows lineSpace:(CGFloat)lineSpace range:(NSRange)range rangeColor:(UIColor *)rangeColor {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_font = font;
    text.yy_color = color;
    text.yy_lineBreakMode = NSLineBreakByTruncatingTail;
    
    [text yy_setColor:rangeColor range:range];
    
    if (lineSpace > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        
        paragraphStyle.lineSpacing = lineSpace;
        
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    }
    
    YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
    container.maximumNumberOfRows = maximumNumberOfRows;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    return layout;
}

@end
