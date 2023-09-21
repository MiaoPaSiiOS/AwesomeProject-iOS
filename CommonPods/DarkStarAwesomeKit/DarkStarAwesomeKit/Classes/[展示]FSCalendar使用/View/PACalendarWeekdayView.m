//
//  PACalendarWeekdayView.m
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import "PACalendarWeekdayView.h"

@interface PACalendarWeekdayView()

@property (strong, nonatomic) NSMutableArray *weekdayLabels;
@property (weak  , nonatomic) UIView *contentView;
- (void)commonInit;

@end

@implementation PACalendarWeekdayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:contentView];
    _contentView = contentView;
    
    _weekdayLabels = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:weekdayLabel];
        [_weekdayLabels addObject:weekdayLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    for (NSInteger i = 0; i < _weekdayLabels.count; i++) {
        CGFloat width = self.frame.size.width / _weekdayLabels.count;
        UILabel *label = _weekdayLabels[i];
        label.frame = CGRectMake(width * i, 0, width, self.contentView.frame.size.height);
    }
}

- (void)configureAppearance
{
    NSArray *weekdaySymbols = self.gregorian.veryShortStandaloneWeekdaySymbols;

    for (NSInteger i = 0; i < self.weekdayLabels.count; i++) {
        NSInteger index = (i + self.firstWeekday-1) % 7;
        UILabel *label = [self.weekdayLabels objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = weekdaySymbols[index];
    }
}

@end
