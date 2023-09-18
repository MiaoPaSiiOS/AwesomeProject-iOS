//
//  SRSAlertController.h
//  SiriusCoreKit
//
//  Created by zhaoyang on 2019/3/27.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

typedef void(^ClickActionBlock)(NSInteger index);


@interface SRSAlertController : UIView

/**
 Alert View, 点击后自动消失

 @param title 标题(可以为空)
 @param message 提示信息
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 */
+ (void)alertWithTitle:(nullable NSString *)title
               message:(nonnull NSString *)message
           actionNames:(nonnull NSArray<NSString *> *)actionNames
            clickAcion:(_Nullable ClickActionBlock)clickAction;



/**
 Alert View, 点击后不自动消失

 @param title 标题(可以为空)
 @param message 提示信息
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 @return SRSAlertController对象
 */
+ (nonnull instancetype)alertCustomDismissWithTitle:(nullable NSString *)title
                                    message:(nonnull NSString *)message
                                actionNames:(nonnull NSArray<NSString *> *)actionNames
                                 clickAcion:(_Nullable ClickActionBlock)clickAction;


/**
 包含图片的 Alert View, 富文本信息, 点击后自动消失

 @param iconName 图片名称
 @param attrMessage 提示信息(富文本)
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 */
+ (void)alertWithIconName:(nonnull NSString *)iconName
              attrMessage:(nonnull NSAttributedString *)attrMessage
              actionNames:(nonnull NSArray<NSString *> *)actionNames
               clickAcion:(_Nullable ClickActionBlock)clickAction;



/**
 包含图片的 Alert View, 点击后自动消失
 
 @param iconName 图片名称
 @param message 提示信息
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 */
+ (void)alertWithIconName:(nonnull NSString *)iconName
                  message:(nonnull NSString *)message
              actionNames:(nonnull NSArray<NSString *> *)actionNames
               clickAcion:(_Nullable ClickActionBlock)clickAction;


/**
 包含图片的 Alert View, 富文本信息, 点击后不自动消失

 @param iconName 图片名称
 @param attrMessage 提示信息(富文本)
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 @return SRSAlertController对象
 */
+ (nonnull instancetype)alertCustomDismissWithIconName:(nonnull NSString *)iconName
                                   attrMessage:(nonnull NSAttributedString *)attrMessage
                                   actionNames:(nonnull NSArray<NSString *> *)actionNames
                                    clickAcion:(_Nullable ClickActionBlock)clickAction;


/**
 包含图片的 Alert View, 点击后不自动消失
 
 @param iconName 图片名称
 @param message 提示信息
 @param actionNames 选项内容数组
 @param clickAction 点击后回调
 @return SRSAlertController对象
 */
+ (nonnull instancetype)alertCustomDismissWithIconName:(nonnull NSString *)iconName
                                       message:(nonnull NSString *)message
                                   actionNames:(nonnull NSArray<NSString *> *)actionNames
                                    clickAcion:(_Nullable ClickActionBlock)clickAction;


/**
 移除方法
 */
- (void)dismissAlertController;

/**
 移除上一个弹框
 */
+ (void)dismissLastAlertController;

@end
