

#import "SRSTextField+Private.h"

@implementation SRSTextField (Private)

- (void)clearBtnClick {
    self.textField.text = @"";
    self.clearBtn.alpha = 0;
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidClickClear:)]) {
        [self.srsTextFieldDelegate textFieldDidClickClear:self];
    }
}

- (void)textFieldDidChange {
    [self changeTextFieldStatus:SRSTextFieldStatusNormal];
    self.clearBtn.alpha = self.textField.text.length ? 1 : 0;
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.srsTextFieldDelegate textFieldDidChange:self];
    }
}

@end
