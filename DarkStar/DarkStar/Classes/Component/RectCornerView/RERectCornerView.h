//
//  RERectCornerView.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RERectCornerView : UIView
@property(nonatomic, assign) UIRectCorner reCorner;
@property(nonatomic, assign) CGFloat reRadius;
@property(nonatomic, strong) UIColor *reBackgroundColor;
//渐变
@property(nonatomic, strong) UIColor *startColor;
@property(nonatomic, strong) UIColor *endColor;
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@end

NS_ASSUME_NONNULL_END
