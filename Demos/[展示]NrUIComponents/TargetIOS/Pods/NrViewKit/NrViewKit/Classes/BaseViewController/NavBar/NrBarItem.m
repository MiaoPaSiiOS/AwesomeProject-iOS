//
//  NrBarItem.m
//  NrViewController
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "NrBarItem.h"

@implementation NrBarItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.title = nil;
        self.img = nil;
        self.imgH = nil;
        self.imgBg = nil;
        self.imgBgH = nil;
        self.titleColor = [UIColor whiteColor];
        self.titleColorH = [UIColor whiteColor];
        self.titleFont = [UIFont systemFontOfSize:15];
        self.contentInset = UIEdgeInsetsZero;
        
        self.strokeColor = [UIColor darkTextColor];
        self.strokeWidth = 0;
        self.edgeStroke = NrEdgeStrokeNone;

    }
    return self;
}
@end
