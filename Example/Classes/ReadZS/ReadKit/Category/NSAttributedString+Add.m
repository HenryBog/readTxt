//
//  NSAttributedString+Add.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "NSAttributedString+add.h"

@implementation NSAttributedString (Add)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size color:(nullable UIColor *)color lineSpace:(CGFloat)lineSpace {
    
    if (string == nil) {
        return nil;
    }
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:string];
    attributes.yy_font = fontSize(size);
    attributes.yy_color = color ? color : [UIColor blackColor];
    attributes.yy_lineSpacing = lineSpace ? lineSpace : 2;
    
    return attributes;
}

@end
