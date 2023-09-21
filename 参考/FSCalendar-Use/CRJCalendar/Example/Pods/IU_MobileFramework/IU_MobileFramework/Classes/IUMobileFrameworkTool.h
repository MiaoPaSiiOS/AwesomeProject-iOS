//
//  IUMobileFrameworkTool.h
//  IU_MobileFramework
//
//  Created by zhuyuhui on 2021/6/10.
//

#import <Foundation/Foundation.h>
#import "IU_Categories/IU_Categories.h"
NS_ASSUME_NONNULL_BEGIN

@interface IUMobileFrameworkTool : NSObject
+ (UIImage *)imageFromBundle:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
