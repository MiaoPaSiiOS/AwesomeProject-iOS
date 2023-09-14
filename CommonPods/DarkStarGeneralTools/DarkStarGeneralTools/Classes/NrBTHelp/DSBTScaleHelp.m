//
//  DSBTScaleHelp.m
//  BTHelpExample
//
//  Created by apple on 2021/1/15.
//  Copyright © 2021 stonemover. All rights reserved.
//

#import "DSBTScaleHelp.h"

static DSBTScaleHelp * help = nil;

@implementation DSBTScaleHelp

+ (instancetype)share{
    if (help == nil) {
        help = [DSBTScaleHelp new];
    }
    return help;
}


+ (CGFloat)scaleViewSize:(CGFloat)value{
    return DSBTScaleHelp.share.scaleViewBlock(value);
}
+ (CGFloat)scaleViewSize:(CGFloat)value uiDesignWidth:(CGFloat)uiDesignWidth{
    return DSBTScaleHelp.share.scaleViewFullBlock(value,uiDesignWidth);
}

+ (CGFloat)scaleFontSize:(CGFloat)fontSize{
    return DSBTScaleHelp.share.scaleFontSizeBlock(fontSize);
}
+ (CGFloat)scaleFontSize:(CGFloat)fontSize uiDesignWidth:(CGFloat)uiDesignWidth{
    return DSBTScaleHelp.share.scaleFontSizeFullBlock(fontSize,uiDesignWidth);
}

- (instancetype)init{
    self = [super init];
    [self iniSelf];
    return self;
}

- (void)iniSelf{
    self.uiDesignWidth = 375;
    self.scaleViewBlock = ^CGFloat(CGFloat value) {
        return [[UIScreen mainScreen] bounds].size.width / self.uiDesignWidth * value;
    };
    
    self.scaleViewFullBlock = ^CGFloat(CGFloat value, CGFloat uiDesignWidth) {
        return [[UIScreen mainScreen] bounds].size.width / uiDesignWidth * value;
    };
    
    self.scaleFontSizeBlock = ^CGFloat(CGFloat fontSize) {
        return [[UIScreen mainScreen] bounds].size.width / self.uiDesignWidth  * fontSize;
    };
    
    self.scaleFontSizeFullBlock = ^CGFloat(CGFloat fontSize, CGFloat uiDesignWidth) {
        return [[UIScreen mainScreen] bounds].size.width / uiDesignWidth  * fontSize;
    };
    
}

@end
