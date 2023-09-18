
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>
#import "UIButton+SRSTimeMinus.h"
@class SRSMessageRectangleTextField;

NS_ASSUME_NONNULL_BEGIN

@protocol SRSMessageRectangleTextFieldDelegate <NSObject>

/// 默认不自动倒计时，需要调用 [sendBtn start] 方法
- (void)messageRectangleSendBtnClick:(SRSMessageRectangleTextField *)textField;

@end

@interface SRSMessageRectangleTextField : UIView
<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIButton *clearBtnImage;
@property (nonatomic, weak) id <SRSMessageRectangleTextFieldDelegate> delegate;

/// 获取输入的内容
- (NSString *)achiveMessageText;
/// 设置error状态
- (void)changeToErrorStatus;

/// 弹起键盘
- (void)showKeyboard;
/// 收起键盘
- (void)hidenKeyboard;


@property (nonatomic, strong) UIView *bottomContentView;
@property (nonatomic, strong) UILabel *bottomLabel;
/// 展示底部提示
- (void)showBottomView;
/// 隐藏底部提示
- (void)hidenBottomView;


@end

NS_ASSUME_NONNULL_END
