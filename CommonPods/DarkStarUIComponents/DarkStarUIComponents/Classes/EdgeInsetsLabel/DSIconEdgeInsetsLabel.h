//
//  DSIconEdgeInsetsLabel.h
//  DSEdgeInsetsLabel
//
//  Created by zhuyuhui on 2020/9/7.
//

#import <UIKit/UIKit.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    NrIconEdgeDirectionLeft,
    NrIconEdgeDirectionRight,
} NrIconEdgeDirection;
@interface DSIconEdgeInsetsLabel : UILabel
@property (nonatomic, strong) UIView             *iconView;
@property (nonatomic)   UIEdgeInsets        edgeInsets;
@property (nonatomic)   NrIconEdgeDirection  direction;
@property (nonatomic)   CGFloat             gap;

- (void)sizeToFitWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
