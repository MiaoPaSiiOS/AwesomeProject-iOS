
#import "UITextField+UsefulMethod.h"
#import <objc/runtime.h>
#import <IU_Categories/UIView+Categorys.h>
#import <IU_Categories/UIButton+Categories.h>

@interface UITextField ()

@property (nonatomic) BOOL  secureTextEntryBecomeActive;

@end

@implementation UITextField (UsefulMethod)

- (void)addInputAccessoryViewButtonWithTitle:(NSString *)title {

    UIView *inputAccessoryView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 40)];
    inputAccessoryView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button       = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.right           = UIScreen.mainScreen.bounds.size.width;
    button.normalTitle     = title;
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button addTarget:self action:@selector(resignFirstResponder)];
    [inputAccessoryView addSubview:button];
    
    [button titleLabelHorizontalAlignment:UIControlContentHorizontalAlignmentRight
                        verticalAlignment:UIControlContentVerticalAlignmentCenter
                        contentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12.f)];
    
    [button titleLabelColorWithNormalStateColor:[UIColor blackColor]
                          highlightedStateColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]
                             disabledStateColor:nil];
    
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0.5f)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    line.top             = 0.f;
    [inputAccessoryView addSubview:line];
    
    self.inputAccessoryView = inputAccessoryView;
}

- (NSString *)changeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (string.length) {
        
        // 输入新字符状态
        self.currentString = [NSMutableString stringWithString:self.text];
        [self.currentString insertString:string atIndex:range.location];
        
        
        // 处理密码键盘的特殊情况
        if (self.secureTextEntryBecomeActive == YES && self.secureTextEntry == YES) {
            
            self.currentString               = [NSMutableString stringWithString:string];
            self.secureTextEntryBecomeActive = NO;
        }
        
    } else {
        
        // 删除字符状态
        
        if (self.text.length >= 1) {
            
            self.currentString = [NSMutableString stringWithString:self.text];
            [self.currentString deleteCharactersInRange:range];
        }
        
        // 处理密码键盘的特殊情况
        if (self.secureTextEntryBecomeActive == YES && self.secureTextEntry == YES) {
            
            self.currentString               = [NSMutableString stringWithFormat:@""];
            self.secureTextEntryBecomeActive = NO;
        }
    }
    
    return [NSString stringWithString:self.currentString];
}

- (void)secureTextFieldDidBeginEditing {

    // 处理密码键盘的特殊情况
    if (self.secureTextEntry == YES) {
        
        self.secureTextEntryBecomeActive = YES;
    }
}

#pragma mark - 添加的属性

- (void)setSecureTextEntryBecomeActive:(BOOL)secureTextEntryBecomeActive {

    objc_setAssociatedObject(self, @selector(secureTextEntryBecomeActive),
                             [NSNumber numberWithBool:secureTextEntryBecomeActive],
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)secureTextEntryBecomeActive {

    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCurrentString:(NSMutableString *)currentString {

    objc_setAssociatedObject(self, @selector(currentString), currentString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableString *)currentString {

    return objc_getAssociatedObject(self, _cmd);
}

@end
