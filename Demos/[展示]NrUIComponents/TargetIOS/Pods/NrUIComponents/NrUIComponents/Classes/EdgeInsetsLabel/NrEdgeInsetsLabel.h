//
//  NrEdgeInsetsLabel.h
//  NrEdgeInsetsLabel
//
//  Created by zhuyuhui on 2020/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NrEdgeInsetsLabel : UILabel
@property(nonatomic, assign) UIEdgeInsets edgeInsets;

- (void)sizeToFitWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
