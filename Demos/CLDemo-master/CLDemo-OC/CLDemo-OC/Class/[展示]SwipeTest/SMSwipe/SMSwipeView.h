//
//  SMSwipeView.h
//  Base
//
//  Created by whbt_mac on 15/12/28.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSwipeView;

@protocol SMSwipeDelegate <NSObject>

@required
-(UITableViewCell*)SMSwipeGetView:(SMSwipeView*)swipe withIndex:(int)index;
-(NSInteger)SMSwipeGetTotaleNum:(SMSwipeView*)swipe;
@end

@interface SMSwipeView : UIView

@property(nonatomic,weak)id<SMSwipeDelegate> delegate;
//层叠透明方式显示 默认YES
@property(nonatomic, assign) BOOL isStackCard;

@property(nonatomic, assign) UIEdgeInsets padding;
//前后两个View差值 默认10
@property(nonatomic, assign) CGFloat itemOffSetX;
@property(nonatomic, assign) CGFloat itemOffSetY;

-(void)reloadData;//加载方法
-(UITableViewCell*)dequeueReusableUIViewWithIdentifier:(NSString*)identifier;//根据id获取缓存的cell

@end
