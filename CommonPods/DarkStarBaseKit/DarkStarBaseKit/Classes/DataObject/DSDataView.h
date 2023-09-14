//
//  DSDataView.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDataView : UIView
/// 自定义数据.
@property (nonatomic, strong) id userinfo;

/// 内填充 ,默认UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets inset;

@end

NS_ASSUME_NONNULL_END
