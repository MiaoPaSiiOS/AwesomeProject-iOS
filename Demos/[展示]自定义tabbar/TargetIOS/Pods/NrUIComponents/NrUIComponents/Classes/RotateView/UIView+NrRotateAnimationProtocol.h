//
//  UIView+NrRotateAnimationProtocol.h
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import <UIKit/UIKit.h>

@interface UIView (NrRotateAnimationProtocol)

/**
 *  在初始化的时候保存transform的值
 */
@property (nonatomic) CGAffineTransform  tmDefaultTransform;

/**
 *  旋转的动画时间
 */
@property (nonatomic) CGFloat            tmRotateDuration;

@end

