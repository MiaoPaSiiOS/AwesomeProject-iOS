
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>

@class SRSTextField;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SRSTextFieldStatusNormal,
    SRSTextFieldStatusInput,
    SRSTextFieldStatusError,
    SRSTextFieldStatusDisable
} SRSTextFieldStatus;

@protocol SRSTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidChange:(SRSTextField *)textField;
- (void)textFieldDidClickClear:(SRSTextField *)textField;
- (void)textFieldDidChangeStatus:(SRSTextField *)textField status:(SRSTextFieldStatus)status;

@end

@interface SRSTextField : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, weak) id <SRSTextFieldDelegate> srsTextFieldDelegate;
@property (nonatomic, assign, readonly) SRSTextFieldStatus textFieldStatus;


/// 不要使用textField.text 应该使用这个设置默认值
- (void)configTextFieldDefaultText:(NSString *)defaultText;
/// 弹起键盘
- (void)showKeyboard;
/// 收起键盘
- (void)hidenKeyboard;

/// 子类可以重写
- (void)changeTextFieldStatus:(SRSTextFieldStatus)status;

@end

NS_ASSUME_NONNULL_END
