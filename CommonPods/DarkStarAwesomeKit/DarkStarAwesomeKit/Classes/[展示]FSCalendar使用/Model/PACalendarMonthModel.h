//
//  PACalendarMonthModel.h
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACalendarDayModel.h"
@interface PACalendarMonthModel : NSObject
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, assign) NSInteger numberOfDaysInMonth;
@property(nonatomic, assign) NSInteger numberOfPlaceholdersForPrev;
@property(nonatomic, assign) NSInteger numberOfRows;
// 总共有多少个Item
@property(nonatomic, assign) NSInteger headDayCount;
@property(nonatomic, strong) NSMutableArray *headDays;
@end
