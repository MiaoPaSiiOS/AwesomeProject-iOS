//
//  NrBTScaleHelp.m
//  BTHelpExample
//
//  Created by apple on 2021/1/15.
//  Copyright © 2021 stonemover. All rights reserved.
//

#import "NrBTScaleHelp.h"

static NrBTScaleHelp * help = nil;

@implementation NrBTScaleHelp

+ (instancetype)share{
    if (help == nil) {
        help = [NrBTScaleHelp new];
    }
    return help;
}


+ (CGFloat)scaleViewSize:(CGFloat)value{
    return NrBTScaleHelp.share.scaleViewBlock(value);
}
+ (CGFloat)scaleViewSize:(CGFloat)value uiDesignWidth:(CGFloat)uiDesignWidth{
    return NrBTScaleHelp.share.scaleViewFullBlock(value,uiDesignWidth);
}

+ (CGFloat)scaleFontSize:(CGFloat)fontSize{
    return NrBTScaleHelp.share.scaleFontSizeBlock(fontSize);
}
+ (CGFloat)scaleFontSize:(CGFloat)fontSize uiDesignWidth:(CGFloat)uiDesignWidth{
    return NrBTScaleHelp.share.scaleFontSizeFullBlock(fontSize,uiDesignWidth);
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
