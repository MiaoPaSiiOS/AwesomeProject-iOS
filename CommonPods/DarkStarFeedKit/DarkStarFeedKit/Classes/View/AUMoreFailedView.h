//
//  AUMoreFailedView.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/1/27.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AUMoreFailedView : UIView

/// 点击重试回调
@property (nonatomic, copy) void (^retryBlock)(void);

@end

NS_ASSUME_NONNULL_END
