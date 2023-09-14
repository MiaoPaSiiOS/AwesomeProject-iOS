//
//  NrDragButton.h
//  BankOfCommunications
//
//  Created by wdp on 2017/5/27.
//  Copyright © 2017年 P&C Information. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  代理按钮的点击事件
 */
@protocol NrDragButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;

@end

@interface NrDragButton : UIButton

/**
 *  悬浮窗所依赖的根视图
 */
@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, assign) UIEdgeInsets areaInset;
/**
 *  NrDragButton的点击事件代理
 */
@property (nonatomic, weak) id<NrDragButtonDelegate>buttonDelegate;

@end
