//
//  NSString+DarkStarSize.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import "NSString+DarkStarSize.h"
#import <CoreText/CoreText.h>

@implementation NSString (DarkStarSize)
#pragma mark - Size计算
- (CGFloat)ds_heightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute
                        fixedWidth:(CGFloat)width
{
    NSParameterAssert(attribute);
    CGFloat height = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        
        height = rect.size.height;
    }
    return height;
}

- (CGFloat)ds_widthWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute
{
    NSParameterAssert(attribute);
    CGFloat width = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        width = rect.size.width;
    }
    return width;
}

- (CGFloat)ds_heightWithFont:(UIFont *)font fixedWidth:(CGFloat)width
{
    NSParameterAssert(font);
    CGFloat height = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
        height = rect.size.height;
    }    
    return height;
}

- (CGFloat)ds_widthWithFont:(UIFont *)font
{
    NSParameterAssert(font);
    CGFloat width = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
        width = rect.size.width;
    }
    return width;
}

+ (CGFloat)ds_oneLineOfTextHeightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute
{
    NSParameterAssert(attribute);
    CGFloat height = 0;
    CGRect rect    = [@"One" boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    height = rect.size.height;
    return height;
}

+ (CGFloat)ds_oneLineOfTextHeightWithFont:(UIFont *)font
{
    NSParameterAssert(font);
    CGFloat height = 0;
    CGRect rect    = [@"One" boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    
    height = rect.size.height;
    return height;
}

+ (CGSize)ds_calculateSizeWithHandleBlock:(void (^)(UILabel *))handleBlock {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (handleBlock) {
        handleBlock(lab);
    }
    [lab sizeToFit];
    return lab.frame.size;
}


@end


@implementation NSAttributedString (DarkStarSize)

- (CGFloat)ds_heightWithFixedWidth:(CGFloat)width {
    CGFloat height = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                         context:nil];
        height = rect.size.height;
    }
    return height;
}

- (CGFloat)ds_width {
    CGFloat width = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                         context:nil];
        width = rect.size.width;
    }
    return width;
}

- (CGFloat)ds_coreTextHeightWithFixedWidth:(CGFloat)width {
    int maxValue = 20000;
    int total_height = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    // 这里的高要设置足够大
    CGRect           drawingRect = CGRectMake(0, 0, width, maxValue);
    CGMutablePathRef path        = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    
    CTFrameRef textFrame  = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    NSArray   *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    // 最后一行line的原点y坐标
    int line_y = (int) origins[[linesArray count] -1].y;
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef)[linesArray objectAtIndex:[linesArray count] - 1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    // +1为了纠正descent转换成int小数点后舍去的值
    total_height = maxValue - line_y + (int) descent + 1;
    
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(textFrame);
    
    return total_height;
}

@end
