
#import <UIKit/UIKit.h>

@interface UILabel (SizeToFit)

- (void)sizeToFitWithText:(NSString *)text config:(void (^)(UILabel *label))configBlock;
- (void)sizeToFitWithAttributedText:(NSAttributedString *)text config:(void (^)(UILabel *label))configBlock;


@end
