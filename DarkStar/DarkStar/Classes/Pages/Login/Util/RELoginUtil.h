//
//  RELoginUtil.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RELoginUtil : NSObject

+ (void)loginFromVC:(UIViewController *)controller dealResult:(nullable void (^)(BOOL isSuccess))handle;
@end

NS_ASSUME_NONNULL_END
