

#import "SRSTextField.h"
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>

@class SRSMultiLineTextView;

NS_ASSUME_NONNULL_BEGIN


@protocol SRSMultiLineTextViewDelegate <UITextViewDelegate>

- (void)textViewDidChangeStatus:(SRSMultiLineTextView *)textView status:(SRSTextFieldStatus)status;

@end

@interface SRSMultiLineTextView : UIView

/// 不可以直接设置titleLabel.text， 只能使用title设置
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign, readonly) SRSTextFieldStatus textFieldStatus;

@property (nonatomic, weak) id <SRSMultiLineTextViewDelegate> srsMultiLineDelegate;

/// 标题 ，不设置默认没有
@property (nonatomic, strong) NSString *title;
/// 占位
@property (nonatomic, strong) NSString *placeholder;

/// 不要使用textField.text 应该使用这个设置默认值
- (void)configTextFieldDefaultText:(NSString *)defaultText;

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status;
/// 弹起键盘
- (void)showKeyboard;
/// 收起键盘
- (void)hidenKeyboard;
@end

NS_ASSUME_NONNULL_END
