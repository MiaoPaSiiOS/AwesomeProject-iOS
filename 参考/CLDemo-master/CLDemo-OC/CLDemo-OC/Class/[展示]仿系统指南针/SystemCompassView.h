//
//  ScaleView.h
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 http://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemCompassView : UIView

//重置刻度标志的方向
- (void)resetDirection:(CGFloat)heading;

@end

NS_ASSUME_NONNULL_END
