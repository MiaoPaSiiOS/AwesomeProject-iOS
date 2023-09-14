//
//  RELoginViewController.h
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import <DarkStarUIKit/DarkStarUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RELoginViewController : DSTableViewController
/// 登录 block
@property (nonatomic,copy) void (^loginBlock)(BOOL success, NSError * _Nullable error);

@property(nonatomic, assign) NSInteger fromFlag;

@end

NS_ASSUME_NONNULL_END
