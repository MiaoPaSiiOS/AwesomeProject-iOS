
#import "UILabel+SizeToFit.h"

@implementation UILabel (SizeToFit)

- (void)sizeToFitWithText:(NSString *)text config:(void (^)(UILabel *label))configBlock {

    self.text = text;
    [self sizeToFit];
    
    if (configBlock) {
        
        configBlock(self);
    }
}

- (void)sizeToFitWithAttributedText:(NSAttributedString *)text config:(void (^)(UILabel *label))configBlock {
    
    self.attributedText = text;
    [self sizeToFit];
    
    if (configBlock) {
        
        configBlock(self);
    }
}

@end
