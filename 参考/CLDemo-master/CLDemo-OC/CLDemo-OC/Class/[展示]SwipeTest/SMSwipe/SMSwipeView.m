//
//  SMSwipeView.m
//  Base
//
//  Created by whbt_mac on 15/12/28.
//  Copyright © 2015年 StoneMover. All rights reserved.
//
//  淘宝滑动特效效果
#import "SMSwipeView.h"

#define degreeTOradians(x) (M_PI * (x)/180)

#ifndef SMSwipeViewFrameInset
#define SMSwipeViewFrameInset(frame,inset) CGRectMake(inset.left, inset.top, frame.size.width - inset.left - inset.right, frame.size.height - inset.top - inset.bottom)
#endif


@interface SMSwipeView()
//已经划动到边界外的一个view
@property(nonatomic,weak)UITableViewCell * viewRemove;
//放当前显示的子View的数组
@property(nonatomic,strong)NSMutableArray * cacheViews;
//view总共的数量
@property(nonatomic,assign)int totalNum;
//当前的下标
@property(nonatomic,assign)int nowIndex;
//触摸开始的坐标
@property(nonatomic,assign)CGPoint pointStart;
//上一次触摸的坐标
@property(nonatomic,assign)CGPoint pointLast;
//最后一次触摸的坐标
@property(nonatomic,assign)CGPoint pointEnd;
//正在显示的cell
@property(nonatomic,weak)UITableViewCell * nowCell;
//下一个cell
@property(nonatomic,weak)UITableViewCell * nextCell;
//第三个cell
@property(nonatomic,weak)UITableViewCell * thirdCell;

@property(nonatomic, strong) UIPanGestureRecognizer * pan;

@end

@implementation SMSwipeView

//直接用方法初始化
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initSelf];
    return self;
}

//进行一些自身的初始化和设置
-(void)initSelf{
    self.clipsToBounds=YES;
    self.isStackCard = YES;
    self.padding = UIEdgeInsetsMake(16, 10, 16, 10);
    self.itemOffSetX = 10;
    self.itemOffSetY = 10;
    self.cacheViews=[[NSMutableArray alloc]init];
    //手势识别
    self.pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:self.pan];
}

- (void)resetAll {
    //放当前显示的子View的数组
    self.cacheViews=[[NSMutableArray alloc]init];

    //已经划动到边界外的一个view
    [self.viewRemove removeFromSuperview];
    self.viewRemove = nil;
    //正在显示的cell
    [self.nowCell removeFromSuperview];
    self.nowCell = nil;
    //下一个cell
    [self.nextCell removeFromSuperview];
    self.nextCell = nil;
    //第三个cell
    [self.thirdCell removeFromSuperview];
    self.thirdCell = nil;
}


- (void)setDelegate:(id<SMSwipeDelegate>)delegate {
    _delegate = delegate;
    if ([self countOfCard]) {
        [self reloadData];
    }
}

- (void)setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    if ([self countOfCard]) {
        [self resetAll];
        [self reloadData];
    }
}

- (void)setIsStackCard:(BOOL)isStackCard {
    _isStackCard = isStackCard;
    if ([self countOfCard]) {
        if (isStackCard) {
            [self.thirdCell setAlpha:0.3f];
            [self.nextCell setAlpha:0.5f];
            [self.nowCell setAlpha:1];
        } else {
            [self.thirdCell setAlpha:1];
            [self.nextCell setAlpha:1];
            [self.nowCell setAlpha:1];
        }
    }
}

- (NSInteger)countOfCard{
    if (_delegate && [_delegate respondsToSelector:@selector(SMSwipeGetTotaleNum:)]) {
        return [_delegate SMSwipeGetTotaleNum:self];
    }
    return 0;
}


/// 计算frame
/// @param index 所在位置
- (CGRect)_calculateFrame:(NSInteger)index {
    UIEdgeInsets insert = UIEdgeInsetsZero;
    if (index == 0) {//最前cell的frame
        insert =UIEdgeInsetsMake(
                                 self.padding.top + self.itemOffSetY * 2,
                                 self.padding.left + self.itemOffSetX * 0,
                                 self.padding.bottom + self.itemOffSetY * 0,
                                 self.padding.right + self.itemOffSetX * 0
                                 );
    }
    else if (index == 1) {//中间cell的frame
        insert =UIEdgeInsetsMake(
                                 self.padding.top + self.itemOffSetY * 1,
                                 self.padding.left + self.itemOffSetX * 1,
                                 self.padding.bottom + self.itemOffSetY * 1,
                                 self.padding.right + self.itemOffSetX * 1
                                 );
    }
    else if (index == 2) {//最后一个cell的frame
        insert =UIEdgeInsetsMake(
                                 self.padding.top + self.itemOffSetY * 0,
                                 self.padding.left + self.itemOffSetX * 2,
                                 self.padding.bottom + self.itemOffSetY * 2,
                                 self.padding.right + self.itemOffSetX * 2
                                 );
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    frame = SMSwipeViewFrameInset(frame, insert);
    return frame;
}



//重新加载数据方法，会再首次执行layoutSubviews的时候调用
-(void)reloadData{
    if (!self.delegate||![self.delegate respondsToSelector:@selector(SMSwipeGetView:withIndex:)]||![self.delegate respondsToSelector:@selector(SMSwipeGetTotaleNum:)]) {
        return;
    }
    self.totalNum=(int)[self.delegate SMSwipeGetTotaleNum:self];
    self.viewRemove=nil;
    UITableViewCell * nowCell=[self.delegate SMSwipeGetView:self withIndex:self.nowIndex];
    
    UITableViewCell * nextCell=[self.delegate SMSwipeGetView:self withIndex:self.nowIndex+1<self.totalNum?self.nowIndex+1:0];
    
    UITableViewCell * thirdCell=[self.delegate SMSwipeGetView:self withIndex:self.nowIndex+2<self.totalNum?self.nowIndex+2:self.nowIndex+2-self.totalNum];
    
#warning 先设置锚点，再设置frame!!!
    [thirdCell removeFromSuperview];
    thirdCell.layer.anchorPoint=CGPointMake(1, 1);//设置锚点，使得旋转时绕右下角旋转
    thirdCell.frame = [self _calculateFrame:2];
    [self addSubview:thirdCell];
    self.thirdCell=thirdCell;
    
    [nextCell removeFromSuperview];
    nextCell.layer.anchorPoint=CGPointMake(1, 1);
    nextCell.frame = [self _calculateFrame:1];
    [self addSubview:nextCell];
    self.nextCell=nextCell;
    
    [nowCell removeFromSuperview];
    nowCell.layer.anchorPoint=CGPointMake(1, 1);
    nowCell.frame = [self _calculateFrame:0];
    [self addSubview:nowCell];
    self.nowCell=nowCell;
    
    if (self.isStackCard) {
        [self.thirdCell setAlpha:0.3f];
        [self.nextCell setAlpha:0.5f];
        [self.nowCell setAlpha:1];
    }
}


#pragma mark swipe触摸的相关手势处理
-(void)swipe:(UISwipeGestureRecognizer*)sender{
    NSLog(@"swipe");
}

-(void)pan:(UIPanGestureRecognizer*)sender{
    CGPoint translation = [sender translationInView: self];
    //CGPoint speed=[sender velocityInView:self];//获取速度
    if (sender.state==UIGestureRecognizerStateBegan) {
        self.pointStart=translation;
        self.pointLast=translation;
    }
    
    if (sender.state==UIGestureRecognizerStateChanged) {
        CGFloat xTotalMove=translation.x - self.pointStart.x;
        NSLog(@"xTotalMove %f",xTotalMove);
        if (xTotalMove < 0) {//左滑：滑到下一页
            CGFloat nowCellangle = degreeTOradians(90*xTotalMove/self.frame.size.width);//偏转角度
            CGFloat nextCellangle = degreeTOradians(90*xTotalMove/self.frame.size.width/2);//偏转角度
            self.nowCell.transform = CGAffineTransformMakeRotation(nowCellangle);
            self.nextCell.transform= CGAffineTransformMakeRotation(nextCellangle);
        }else {//右滑：滑到上一页
            self.nowCell.transform = CGAffineTransformMakeRotation(degreeTOradians(0));
            self.nextCell.transform= CGAffineTransformMakeRotation(degreeTOradians(0));
        }
    }
    
    if (sender.state==UIGestureRecognizerStateEnded) {
        [self removeGestureRecognizer:self.pan];//移除手势
        CGFloat xTotalMove = translation.x - self.pointStart.x;
        if (xTotalMove<0) {
            [self swipeNext];       //滑到下一页
        }else{
            [self swipePrevious];   //滑到上一页
        }
    }
}

/**
 *  @author StoneMover, 16-12-29 14:12:33
 *
 *  @brief 获取为显示的cell,复用机制
 *
 *  @param identifier id标志
 *
 *  @return 返回的cell,如果缓存中没有则返回空
 */
-(UITableViewCell*)dequeueReusableUIViewWithIdentifier:(NSString *)identifier{
    for (UITableViewCell * cell in self.cacheViews) {
        if ([identifier isEqualToString:cell.reuseIdentifier]) {
            [self.cacheViews removeObject:cell];
            return cell;
        }
    }
    return nil;
}

//滑动到下一个界面
-(void)swipeNext{
    //将位于中间的cell恢复正常，不旋转，让它充当第一个
    [UIView animateWithDuration:0.3 animations:^{
        self.nextCell.transform= CGAffineTransformMakeRotation(degreeTOradians(0));
    }];

    CGPoint center=self.nowCell.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.nowCell.center=CGPointMake(center.x-self.frame.size.width, center.y);
        self.nowCell.transform= CGAffineTransformMakeRotation(degreeTOradians(0));
    } completion:^(BOOL finished) {
        self.nowIndex++;
        self.nowIndex=self.nowIndex<self.totalNum?self.nowIndex:0;
        if (self.viewRemove&&[self isNeedAddToCache:self.viewRemove]) {
            [self.cacheViews addObject:self.viewRemove];
            [self.viewRemove removeFromSuperview];
        }
        self.viewRemove=self.nowCell;
        
        
        self.nowCell=self.nextCell;
        self.nextCell=self.thirdCell;
        
        
        UITableViewCell * thirdCell=[self.delegate SMSwipeGetView:self withIndex:self.nowIndex+2<self.totalNum?(int)self.nowIndex+2:(int)self.nowIndex+2-(int)self.totalNum];
        [thirdCell removeFromSuperview];
        self.thirdCell=thirdCell;
        
        
        
        if (self.isStackCard) {
            [self.thirdCell setAlpha:0.3f];
            [self.nextCell setAlpha:0.5f];
            [self.nowCell setAlpha:1];
        }
        
        [self insertSubview:thirdCell belowSubview:self.nextCell];
        
        [UIView animateWithDuration:0.2 animations:^{
#warning 先设置锚点，再设置frame!!!
            self.nowCell.layer.anchorPoint=CGPointMake(1, 1);
            self.nextCell.layer.anchorPoint=CGPointMake(1, 1);
            self.thirdCell.layer.anchorPoint=CGPointMake(1, 1);

            self.nowCell.frame = [self _calculateFrame:0];
            self.nextCell.frame = [self _calculateFrame:1];
            self.thirdCell.frame = [self _calculateFrame:2];
            
        } completion:^(BOOL finished) {
            [self addGestureRecognizer:self.pan];//添加手势
        }];
    }];
}

//滑动到上一个界面
-(void)swipePrevious{
    if (!self.viewRemove) {
        NSLog(@"!viewRemove");
        [self addGestureRecognizer:self.pan];//添加手势
        return;
    }
    
    if (self.nowIndex == 0) {
        NSLog(@"!viewRemove+index");
        [self addGestureRecognizer:self.pan];//添加手势
        return;
    }
        
    self.nowIndex --;
    
    //最后一个cell移除
    [self.thirdCell removeFromSuperview];
    
    self.thirdCell=self.nextCell;
    self.nextCell=self.nowCell;
    self.nowCell=self.viewRemove;
    
    if (self.isStackCard) {
        [self.thirdCell setAlpha:0.3f];
        [self.nextCell setAlpha:0.5f];
        [self.nowCell setAlpha:1];
    }

    if (self.nowIndex==0) {
        self.viewRemove = nil;
    }else{
        UITableViewCell * cell = [self.delegate SMSwipeGetView:self withIndex:(int)self.nowIndex-1];
        [cell removeFromSuperview];
        [self insertSubview:cell aboveSubview:self.nowCell];
        cell.layer.anchorPoint=CGPointMake(1, 1);
        cell.frame=self.viewRemove.frame;
        self.viewRemove=cell;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
#warning 先设置锚点，再设置frame!!!
        self.nowCell.layer.anchorPoint=CGPointMake(1, 1);
        self.nextCell.layer.anchorPoint=CGPointMake(1, 1);
        self.thirdCell.layer.anchorPoint=CGPointMake(1, 1);

        self.nowCell.frame = [self _calculateFrame:0];
        self.nextCell.frame = [self _calculateFrame:1];
        self.thirdCell.frame = [self _calculateFrame:2];
        
    } completion:^(BOOL finished) {
        [self addGestureRecognizer:self.pan];//添加手势
    }];
}

//是否需要加入到缓存中去
-(BOOL)isNeedAddToCache:(UITableViewCell*)cell{
    for (UITableViewCell * cellIn in self.cacheViews) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}

@end
