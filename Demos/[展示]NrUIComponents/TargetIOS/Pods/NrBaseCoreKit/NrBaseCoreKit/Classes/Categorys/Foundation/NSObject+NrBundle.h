//
//  NSObject+NrBundle.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2020/9/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define Nr_BUNDLE(_bundleName,_podName) [NSObject nr_bundleName:_bundleName inPod:_podName]
#define Nr_IMAGE(_name) [UIImage imageNamed:_name]
#define NrPOD_IMAGE(_name,_bundle) [NSObject nr_imageNamed:_name inBundle:_bundle]

@interface NSObject (NrBundle)
/// 获取Pod库中的指定NSBundle（Pod库中可能存在多个.bundle文件）
/// @param bundleName bundle名
/// @param podName pod名
+ (nullable NSBundle *)nr_bundleName:(NSString *)bundleName inPod:(NSString *)podName;


/// 获取指定bundle中的图片
/// @param name 图片名
/// @param bundle bundle
+ (nullable UIImage *)nr_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
