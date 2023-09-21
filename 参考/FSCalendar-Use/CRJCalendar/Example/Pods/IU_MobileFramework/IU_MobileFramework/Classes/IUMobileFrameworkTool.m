//
//  IUMobileFrameworkTool.m
//  IU_MobileFramework
//
//  Created by zhuyuhui on 2021/6/10.
//

#import "IUMobileFrameworkTool.h"
@implementation IUMobileFrameworkTool
+ (UIImage *)imageFromBundle:(NSString *)name {
    //当前文件所在bundle
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    //获取bundle name
    NSString *bundleName = currentBundle.infoDictionary[@"CFBundleExecutable"];
    

    UIImage *image = [UIImage imageNamed:name
                                inBundle:[NSBundle bundleWithBundleName:bundleName podName:nil]
           compatibleWithTraitCollection:nil];

    return image;
}
@end
