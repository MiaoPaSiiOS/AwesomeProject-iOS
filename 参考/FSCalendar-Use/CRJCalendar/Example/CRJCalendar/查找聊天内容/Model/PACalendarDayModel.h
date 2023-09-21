//
//  PACalendarDayModel.h
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PACalendarDayModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) BOOL dateIsToday;
@property (nonatomic, assign) BOOL selected; /**< 是否被选择 */
@property (nonatomic, assign) BOOL hasEvent; /**< 是否有事件*/
@end
