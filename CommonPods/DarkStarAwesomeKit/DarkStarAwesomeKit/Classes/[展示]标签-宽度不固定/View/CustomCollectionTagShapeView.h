//
//  CustomCollectionTagShapeView.h
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/6/17.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionTagShapeView : UIView
@property(nonatomic, assign) UIRectCorner corners;
@property(nonatomic, assign) CGSize cornerRadii;
@property(nonatomic, strong) CAShapeLayer *borderLayer;
@end

NS_ASSUME_NONNULL_END
