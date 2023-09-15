//
//  AULoadErrorView.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2021/11/19.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AULoadErrorType) {
    AULoadNoData = 0,               //无数据
    AULoadServerError = 1,          //服务器错误
    AULoadNetworkNotReachable = 2,  //无网络连接
};

@class AULoadErrorView;

typedef void(^RefreshBlock)(AULoadErrorView *loadErrorView);

@interface AULoadErrorView : UIScrollView

@property(nonatomic, strong) RefreshBlock refreshHandle;

@property(nonatomic, assign) AULoadErrorType type;

//设置视图内部内容偏移
- (void)setMOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
