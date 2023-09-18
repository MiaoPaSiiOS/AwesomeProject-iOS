//
//  XLFoldClock.m
//  翻页动画Demo
//
//  Created by MengXianLiang on 2018/5/28.
//  Copyright © 2018年 jwzt. All rights reserved.
//

#import "XLFoldClock.h"
#import "XLFoldClockItem.h"

@interface XLFoldClock () {
    XLFoldClockItem *_hourItem;
    
    XLFoldClockItem *_minuteItem;
    
    XLFoldClockItem *_secondItem;
}
@property (nonatomic, strong) NSDate *date;
@end

@implementation XLFoldClock

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor blackColor];
    _hourItem = [[XLFoldClockItem alloc] init];
    _hourItem.type = XLClockItemTypeHour;
    [self addSubview:_hourItem];
    
    _minuteItem = [[XLFoldClockItem alloc] init];
    _minuteItem.type = XLClockItemTypeMinute;
    [self addSubview:_minuteItem];
    
    _secondItem = [[XLFoldClockItem alloc] init];
    _secondItem.type = XLClockItemTypeSecond;
    [self addSubview:_secondItem];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 0.07*self.bounds.size.width;
    CGFloat itemW = (self.bounds.size.width - 4*margin)/3.0f;
    CGFloat itemY = (self.bounds.size.height - itemW)/2.0f;
    _hourItem.frame = CGRectMake(margin, itemY, itemW, itemW);
    _minuteItem.frame = CGRectMake(CGRectGetMaxX(_hourItem.frame) + margin, itemY, itemW, itemW);
    _secondItem.frame = CGRectMake(CGRectGetMaxX(_minuteItem.frame) + margin, itemY, itemW, itemW);
}


- (void)updateDate:(NSDate *)date animated:(BOOL)animated {
    _date = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    [_hourItem updateTime:dateComponent.hour animated:animated];
    [_minuteItem updateTime:dateComponent.minute animated:animated];
    [_secondItem updateTime:dateComponent.second animated:animated];
}


- (void)setFont:(UIFont *)font {
    _hourItem.font = font;
    _minuteItem.font = font;
    _secondItem.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _hourItem.textColor = textColor;
    _minuteItem.textColor = textColor;
    _secondItem.textColor = textColor;
}
@end
