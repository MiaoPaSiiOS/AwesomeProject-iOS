//
//  NrEdgeInsetsLabel.m
//  NrEdgeInsetsLabel
//
//  Created by zhuyuhui on 2020/9/7.
//

#import "NrEdgeInsetsLabel.h"

@implementation NrEdgeInsetsLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect         = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                            limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (void)sizeToFitWithText:(NSString *)text {
    
    self.text = text;
    [self sizeToFit];
}

@end
