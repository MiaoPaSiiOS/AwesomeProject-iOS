//
//  SRSFlipScrollView.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2021/12/21.
//

#import "SRSFlipScrollView.h"

@interface SRSFlipScrollView()<UIScrollViewDelegate>
@property(nonatomic, assign) CGFloat itemSpacing;//间距
@property(nonatomic, assign) CGFloat previewWidth;//预览宽度
@end

@implementation SRSFlipScrollView
- (instancetype)initWithFrame:(CGRect)frame itemSpacing:(CGFloat)itemSpacing previewWidth:(CGFloat)previewWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSpacing = itemSpacing;
        self.previewWidth = previewWidth;
        self.scrollView.frame = CGRectMake(itemSpacing, 0, frame.size.width - itemSpacing * 2 - previewWidth, frame.size.height);
        [self addSubview:self.scrollView];
        self.clipsToBounds = YES;
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView *subview in self.scrollView.subviews) {
            CGFloat offset_X = point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subview.frame.origin.x;
            CGFloat offset_Y = point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subview.frame.origin.y;
            CGPoint offset = CGPointMake(offset_X,offset_Y);
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return self.scrollView;
    }
    return view;
}

#pragma mark - 懒加载控件
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
    }
    return _scrollView;
}
@end

