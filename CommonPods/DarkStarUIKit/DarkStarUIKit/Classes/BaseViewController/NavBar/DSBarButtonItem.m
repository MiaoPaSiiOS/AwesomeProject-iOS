//
//  NrBarButtonItem.m
//  DSViewController
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "DSBarButtonItem.h"
#import <DarkStarResourceKit/DarkStarResourceKit.h>
@implementation DSBarButtonItem

- (instancetype)init {
    if (self = [super init]) {
        self.style = DSBarButtonItemStyleBordered;
        self.customView = nil;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)nTitle target:(id)nTarget action:(SEL)nAction {
    if (self = [self init]) {
        self.title = nTitle;
        self.target = nTarget;
        self.action = nAction;
        self.style = DSBarButtonItemStyleBordered;
        @try {
            NSArray *imgs = [self borderImages];
            if (imgs && imgs.count == 2) {
                if ([[imgs objectAtIndex:0] isKindOfClass:[UIImage class]]) {
                    self.img = [imgs objectAtIndex:0];
                }
                if ([[imgs objectAtIndex:1] isKindOfClass:[UIImage class]]) {
                    self.imgH = [imgs objectAtIndex:1];
                }
            }
        }
        @catch (NSException *exception) {
            self.img = nil;
            self.imgH = nil;
        }
    }
    return self;
}

- (instancetype)initBackWithTarget:(id)nTarget action:(SEL)nAction {
    if (self = [self init]) {
        self.target = nTarget;
        self.action = nAction;
        self.style = DSBarButtonItemStyleBack;
        self.img = [DSResourceTool imageNamed:@"nr_nav_goBack_black"];
        @try {
            NSArray *imgs = [self backImages];
            if (imgs && imgs.count == 2) {
                if ([[imgs objectAtIndex:0] isKindOfClass:[UIImage class]]) {
                    self.img = [imgs objectAtIndex:0];
                }
                if ([[imgs objectAtIndex:1] isKindOfClass:[UIImage class]]) {
                    self.imgH = [imgs objectAtIndex:1];
                }
            }
        }
        @catch (NSException *exception) {
            self.img = nil;
            self.imgH = nil;
        }
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)nCustomView {
    if (self = [self init]) {
        self.style = DSBarButtonItemStyleCustom;
        self.customView = nCustomView;
    }
    return self;
}

- (NSArray *)borderImages{
    return nil;
}

- (NSArray *)backImages{
    return nil;
}


@end
