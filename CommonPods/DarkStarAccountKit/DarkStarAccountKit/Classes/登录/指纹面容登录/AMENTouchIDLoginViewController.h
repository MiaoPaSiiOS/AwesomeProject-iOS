//
//  AMENTouchIDLoginViewController.h
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <DarkStarUIKit/DarkStarUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENTouchIDLoginViewController : DSViewController
// 指纹登录 block
@property (nonatomic,copy) void (^touchIDLoginBlock)(BOOL success, NSString *error);
@end

NS_ASSUME_NONNULL_END
