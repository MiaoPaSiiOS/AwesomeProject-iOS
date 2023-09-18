
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>

@interface NrActionSheet : UIView


/**
  类初始化方法, 包含说明性文字

 @param message 说明性文字
 @param actionArray Action Sheet 选择内容
 @param cancelTitle 取消显示内容, 点击回调值: 0
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetWithMessage:(nonnull NSString *)message
                   actionArray:(nonnull NSArray<NSString *>*)actionArray
                   cancelTitle:(nonnull NSString *)cancelTitle
                    clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 包含说明性文字、毁灭性操作

 @param message 说明性文字
 @param actionArray Action Sheet 选择内容, 第一项为毁灭性操作显示内容
 @param cancelTitle 取消显示内容, 点击回调值: 0
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetDestructiveWithMessage:(nonnull NSString *)message
                              actionArray:(nonnull NSArray<NSString *>*)actionArray
                              cancelTitle:(nonnull NSString *)cancelTitle
                               clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 没有说明性文字, 有毁灭性操作

 @param actionArray Action Sheet 选择内容, 第一项为毁灭性操作显示内容
 @param cancelTitle 取消显示内容, 点击回调值: 0
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetDestructiveWithActionArray:(nonnull NSArray<NSString *>*)actionArray
                                  cancelTitle:(nonnull NSString *)cancelTitle
                                   clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 没有说明性文字、毁灭性操作

 @param actionArray Action Sheet 选择内容
 @param cancelTitle 取消显示内容, 点击回调值: 0
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetWithActionArray:(nonnull NSArray<NSString *>*)actionArray
                       cancelTitle:(nonnull NSString *)cancelTitle
                        clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
类初始化方法, 包含说明性文字, 取消显示内容默认为: 取消, 取消点击回调值: 0

 @param message 说明性文字
 @param actionArray Action Sheet 选择内容
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetWithMessage:(nonnull NSString *)message
                   actionArray:(nonnull NSArray<NSString *>*)actionArray
                    clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 包含说明性文字、毁灭性操作, 取消显示内容默认为: 取消, 取消点击回调值: 0

 @param message 说明性文字
 @param actionArray Action Sheet 选择内容, 第一项为毁灭性操作显示内容
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetDestructiveWithMessage:(nonnull NSString *)message
                              actionArray:(nonnull NSArray<NSString *>*)actionArray
                               clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 没有说明性文字, 有毁灭性操作, 取消显示内容默认为: 取消, 取消点击回调值: 0

 @param actionArray Action Sheet 选择内容, 第一项为毁灭性操作显示内容
 @param clickIndexBlock Action Sheet 回调
 */
+ (void)actionSheetDestructiveWithActionArray:(nonnull NSArray<NSString *>*)actionArray
                                   clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


/**
 类初始化方法, 没有说明性文字、毁灭性操作, 取消显示内容默认为: 取消, 取消点击回调值: 0
 
 @param actionArray Action Sheet 选择内容
 @param clickIndexBlock Action Sheet
 */
+ (void)actionSheetWithActionArray:(nonnull NSArray<NSString *>*)actionArray
                        clickIndex:(void(^ _Nullable)(NSInteger index))clickIndexBlock;


@end
