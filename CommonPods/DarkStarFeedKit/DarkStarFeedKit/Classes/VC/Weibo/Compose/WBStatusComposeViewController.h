//
//  WBStatusComposeViewController.h
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/21.
/// 发布微博

#import <DarkStarUIKit/DarkStarUIKit.h>
typedef NS_ENUM(NSUInteger, WBStatusComposeViewType) {
    WBStatusComposeViewTypeStatus,  ///< 发微博
    WBStatusComposeViewTypeRetweet, ///< 转发微博
    WBStatusComposeViewTypeComment, ///< 发评论
};

NS_ASSUME_NONNULL_BEGIN

@interface WBStatusComposeViewController : DSViewController
@property (nonatomic, assign) WBStatusComposeViewType type;
@property (nonatomic, copy) void (^dismiss)(void);
@end

NS_ASSUME_NONNULL_END
