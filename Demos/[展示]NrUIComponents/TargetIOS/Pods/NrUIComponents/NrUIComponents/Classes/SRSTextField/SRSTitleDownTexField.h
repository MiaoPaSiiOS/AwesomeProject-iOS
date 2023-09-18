
#import "SRSTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRSTitleDownTexField : SRSTextField

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *flagLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, assign, readonly) SRSTextFieldStatus status;

/// 底部按钮点击
@property (nonatomic, copy) void(^btnClickBlock)(void);
@property (nonatomic, strong) NSString *flagText;
@property (nonatomic, strong) NSMutableAttributedString *attributeString;

@end

NS_ASSUME_NONNULL_END
