
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 alert点击
 */
typedef void(^TmallAlertClickIndexBlock)(NSInteger clickNumber);

/**
 alert 取消
 */
typedef void(^LDZFAlertCancleBlock)(void);

@interface UIViewController (NrAlert)

#pragma mark - Alert
/// Alert系统提示
/// @param title 标题
/// @param message 内容
/// @param btnTitleArr 按钮标题数组
/// @param btnColorArr 按钮颜色数组，传入1个颜色默认全部按钮为该颜色
/// @param clickBlock 点击回调
- (void)nr_showAlertControllerWithTitle:(nullable id)title message:(nullable id)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(nullable NSArray *)btnColorArr  alertClick:(TmallAlertClickIndexBlock)clickBlock;

/// Alert系统提示，无colors
- (void)nr_showAlertControllerWithTitle:(nullable id)title message:(nullable id)message buttonTitles:(NSArray *)btnTitleArr alertClick:(TmallAlertClickIndexBlock)clickBlock;

/// Alert系统提示，无button，无colors，默认取消确定按钮
- (void)nr_showAlertControllerWithTitle:(nullable id)title message:(nullable id)message alertClick:(TmallAlertClickIndexBlock)clickBlock;

#pragma mark - Alert Sheet
/// AlertSheet系统提示，默认带取消按钮
/// @param title 标题
/// @param message 内容
/// @param btnTitleArr 按钮标题数组
/// @param btnColorArr 按钮颜色数组
/// @param clickBlock 点击回调
/// @param cancleBlock 取消回调，为nil时不显示默认取消按钮
- (void)nr_showAlertSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(nullable NSArray *)btnColorArr  alertClick:(TmallAlertClickIndexBlock)clickBlock alertCancle:(LDZFAlertCancleBlock)cancleBlock;

/// AlertSheet系统提示，无message
- (void)nr_showAlertSheetWithTitle:(nullable NSString *)title buttonTitles:(NSArray *)btnTitleArr buttonColors:(nullable NSArray *)btnColorArr  alertClick:(TmallAlertClickIndexBlock)clickBlock alertCancle:(LDZFAlertCancleBlock)cancleBlock;

/// AlertSheet系统提示，无message，无colors
- (void)nr_showAlertSheetWithTitle:(nullable NSString *)title buttonTitles:(NSArray *)btnTitleArr alertClick:(TmallAlertClickIndexBlock)clickBlock alertCancle:(LDZFAlertCancleBlock)cancleBlock;

/// AlertSheet系统提示，无title，无message
- (void)nr_showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr buttonColors:(nullable NSArray *)btnColorArr  alertClick:(TmallAlertClickIndexBlock)clickBlock alertCancle:(LDZFAlertCancleBlock)cancleBlock;

/// AlertSheet系统提示，无title，无message，无colors
- (void)nr_showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr   alertClick:(TmallAlertClickIndexBlock)clickBlock alertCancle:(LDZFAlertCancleBlock)cancleBlock;

@end

NS_ASSUME_NONNULL_END
