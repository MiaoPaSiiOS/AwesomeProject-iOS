//
//  DSErrorView.h
//  REWLY
//
//  Created by zhuyuhui on 2023/6/1.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DSErrorType) {
    DSErrorTypeDefault,
    DSErrorTypeUnavailableNetwork,
    DSErrorTypeEmptyData,
    DSErrorTypeSeverError,
};

@interface DSErrorView : UIView
/**
 当前错误类型【默认为Default】
 */
@property (nonatomic, assign) DSErrorType errorType;
/**
 要显示的文案【为nil使用默认文案】
 */
@property (nonatomic, copy) NSString *customText;


- (void)addTarget:(id)target action:(SEL)action;
@end

