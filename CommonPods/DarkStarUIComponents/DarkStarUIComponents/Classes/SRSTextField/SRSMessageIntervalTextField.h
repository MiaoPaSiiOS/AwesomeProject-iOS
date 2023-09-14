

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "UIButton+SRSTimeMinus.h"
@class SRSMessageIntervalTextField;

NS_ASSUME_NONNULL_BEGIN


@protocol SRSMessageIntervalTextFieldDelegate <NSObject>

/// 默认不自动倒计时，需要调用 [sendBtn start] 方法
- (void)messageIntervalSendBtnClick:(SRSMessageIntervalTextField *)textField;

@end

@interface SRSMessageIntervalTextField : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id <SRSMessageIntervalTextFieldDelegate> delegate;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextField *textField;

/// 初始化可以传一个默认字符串
/// SRSMessageBaseTextField 的固定宽高是 750*196 只需要设置中心点即可
- (instancetype)initWithText:(NSString *)text;
/// 弹起键盘
- (void)showKeyboard;
/// 收起键盘
- (void)hidenKeyboard;
/// 获取输入的内容
- (NSString *)achiveMessageText;
/// 设置error状态
- (void)changeToErrorStatus;


@end

NS_ASSUME_NONNULL_END
