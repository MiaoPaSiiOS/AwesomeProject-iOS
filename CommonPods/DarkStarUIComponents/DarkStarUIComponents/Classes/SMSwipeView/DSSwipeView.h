//
//  DSSwipeView.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/15.
//

#import <UIKit/UIKit.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@class DSSwipeView;

@protocol DSSwipeViewDelegate <NSObject>

@required
//获取显示数据内容
-(UITableViewCell*)SMSwipeGetView:(DSSwipeView*)swipe withIndex:(int)index;
//获取数据源总量
-(NSInteger)SMSwipeGetTotaleNum:(DSSwipeView*)swipe;
@end

@interface DSSwipeView : UIView

@property(nonatomic,weak)id<DSSwipeViewDelegate> delegate;

//层叠透明方式显示 默认YES
@property(nonatomic,assign)BOOL isStackCard;
//当前view距离父view的顶部的值 默认16
@property(nonatomic,assign)CGFloat TOP_MARGTIN;
//当前view距离父View左右的距离 默认10
@property(nonatomic,assign)CGFloat LEFT_RIGHT_MARGIN;
//前后两个View差值 默认10
@property(nonatomic,assign)CGFloat itemOffSetSpacing;

//加载方法
-(void)reloadData;
//根据id获取缓存的cell
-(UITableViewCell*)dequeueReusableUIViewWithIdentifier:(NSString*)identifier;

@end
