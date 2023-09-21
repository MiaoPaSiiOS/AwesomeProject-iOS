//
//  PACalendarWeekdayView.h
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PACalendarWeekdayView : UIView
@property (strong, nonatomic) NSCalendar *gregorian;
@property (nonatomic, assign) NSUInteger firstWeekday;

- (void)configureAppearance;
@end

NS_ASSUME_NONNULL_END
