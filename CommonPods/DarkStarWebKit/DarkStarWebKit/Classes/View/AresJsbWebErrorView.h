//
//  AresJsbWebErrorView.h
//  DarkStarWebKit
//
//  Created by zhuyuhui on 2023/9/16.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AresJsbWebErrorViewType) {
    AresJsbWebErrorViewNoData = 0,               //无数据
    AresJsbWebErrorViewServerError = 1,          //服务器错误
    AresJsbWebErrorViewNetworkNotReachable = 2,  //无网络连接
};

@class AresJsbWebErrorView;

typedef void(^RefreshBlock)(AresJsbWebErrorView *loadErrorView);

@interface AresJsbWebErrorView : UIScrollView

@property(nonatomic, strong) RefreshBlock refreshHandle;

@property(nonatomic, assign) AresJsbWebErrorViewType type;

//设置视图内部内容偏移
- (void)setMOffset:(CGFloat)offset;


@end

NS_ASSUME_NONNULL_END
