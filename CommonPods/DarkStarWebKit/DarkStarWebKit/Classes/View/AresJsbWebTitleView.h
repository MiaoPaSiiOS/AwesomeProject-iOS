//
//  AresJsbWebTitleView.h
//  Amen
//
//  Created by zhuyuhui on 2022/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AresJsbWebTitleView : UIView
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 记录让标题显示的url
@property (nonatomic, strong, nullable) NSString *showUrl;

- (void)configWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
