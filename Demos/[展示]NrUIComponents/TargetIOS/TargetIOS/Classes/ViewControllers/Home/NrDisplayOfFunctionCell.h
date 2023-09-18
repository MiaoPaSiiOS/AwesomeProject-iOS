//
//  NrDisplayOfFunctionCell.h
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NrDisplayOfFunction;
@interface NrDisplayOfFunctionCell : UITableViewCell
@property(nonatomic, strong) NrDisplayOfFunction *displayOf;
- (void)loadContent;


+ (CGFloat)heightForRowAtIndexPath:(NrDisplayOfFunction *)displayOf;
@end

NS_ASSUME_NONNULL_END
