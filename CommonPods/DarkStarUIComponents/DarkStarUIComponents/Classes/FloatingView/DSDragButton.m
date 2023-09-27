//
//  DSDragButton.m
//  BankOfCommunications
//
//  Created by wdp on 2017/5/27.
//  CopyNrFloatWindowDirectionRIGHT © 2017年 P&C Information. All NrFloatWindowDirectionRIGHTs reserved.
//



#import "DSDragButton.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@interface DSDragButton()

/**
 *  开始按下的触点坐标
 */
@property (nonatomic, assign)CGPoint touchStartPosition;

@end

@implementation DSDragButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setAreaInset:(UIEdgeInsets)areaInset {
    _areaInset = areaInset;
    [self reset];
}

- (void)setRootView:(UIView *)rootView {
    _rootView = rootView;
    [self reset];
}


- (void)reset {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (_rootView.width == [DSCommonMethods screenWidth] && _rootView.height == [DSCommonMethods screenHeight]) {
        inset = UIEdgeInsetsMake(kNaviBarHeight, 0, kTabBarHeight, 0);
    }
    inset = UIEdgeInsetsConcat(inset, self.areaInset);
    
    CGFloat centerX = inset.left + self.width/2;
    CGFloat centerY = inset.top + self.height/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(centerX, centerY);
    }];
}



/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    self.touchStartPosition = [touch locationInView:_rootView];
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.center = curPoint;
}

/**
 *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_touchStartPosition.x - curPoint.x),2) + pow((_touchStartPosition.y - curPoint.y),2) < 1) {
        if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(dragButtonClicked:)]) {
            [self.buttonDelegate dragButtonClicked:self];
        }
        // 点击后不吸附
        return;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (_rootView.width == [DSCommonMethods screenWidth] && _rootView.height == [DSCommonMethods screenHeight]) {
        inset = UIEdgeInsetsMake(kNaviBarHeight, 0, kTabBarHeight, 0);
    }
    inset = UIEdgeInsetsConcat(inset, self.areaInset);
    
    CGFloat W = _rootView.width;
    CGFloat H = _rootView.height;//622

    CGFloat centerX = 0;
    CGFloat centerY = 0;
    if (curPoint.x < _rootView.width/2) {
        centerX = inset.left + self.width/2;
        
    } else {
        centerX = W - self.width/2 - inset.right;
    }
    
    if (curPoint.y < (inset.top + self.height/2)) {
        centerY = inset.top + self.height/2;
        NSLog(@"超出顶部");
        
    } else if (curPoint.y > (H - self.height/2 - inset.bottom)) {
        centerY = H - self.height/2 - inset.bottom;
        NSLog(@"超出底部 %f - %f",curPoint.y,(H - self.height/2 - inset.bottom));
        
    } else {
        centerY = self.centerY;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(centerX, centerY);
    }];
}


@end
