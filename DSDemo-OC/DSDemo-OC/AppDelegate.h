//
//  AppDelegate.h
//  DSDemo-OC
//
//  Created by zhuyuhui on 2023/9/19.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

+ (AppDelegate *)sharedDelegate;

#pragma mark - 创建rootVC
- (void)changeWindowRootVC:(NSInteger)index;

/// 选中指定tab
/// @param idx tab的索引
- (void)goToTabWithIndex:(NSNumber*)idx;
@end


