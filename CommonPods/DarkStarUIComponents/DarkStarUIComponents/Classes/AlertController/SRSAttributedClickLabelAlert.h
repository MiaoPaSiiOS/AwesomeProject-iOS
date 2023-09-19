

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BCMAttrClickAction)(NSInteger index);
typedef void (^BCMAttrConfigLable)(TTTAttributedLabel *lable);
typedef void (^BCMAttrClickLinkModel)(NSDictionary *components);

@interface SRSAttributedClickLabelAlert : UIView

/// 文字可点击的Alert
/// @param actionNameArray 操作按钮数组
/// @param clickAction 操作按钮点击回调
/// @param configLable 配置AttributedClickLabel
/// @param clickLinkModel 点击的指定文字回调
+ (void)alertWithConfigLable:(nullable BCMAttrConfigLable)configLable
              clickLinkModel:(nullable BCMAttrClickLinkModel)clickLinkModel
                 ActionNames:(nullable NSArray *)actionNameArray
                  clickAcion:(BCMAttrClickAction)clickAction;

/// 文字可点击的Alert + 自己控制消失！
/// @param actionNameArray 操作按钮数组
/// @param clickAction 操作按钮点击回调
/// @param configLable 配置AttributedClickLabel
/// @param clickLinkModel 点击的指定文字回调
+ (instancetype)alertCustomDismissConfigLable:(nullable BCMAttrConfigLable)configLable
                               clickLinkModel:(nullable BCMAttrClickLinkModel)clickLinkModel
                                  ActionNames:(nullable NSArray *)actionNameArray
                                   clickAcion:(nullable BCMAttrClickAction)clickAction;

/**
 移除方法
 */
- (void)dismissAlertController;

/**
 移除上一个弹框
 */
+ (void)dismissLastAlertController;

@end

NS_ASSUME_NONNULL_END
/*
 //隐私协议弹出提示框
 - (void)showPrivacyAgreementAlert {
     NSArray *linkArray = @[[NSString stringWithFormat:@"《%@》",safeString(self.privacyAgreementInfo[@"title"])]];
     NSString *full = [NSString stringWithFormat:@"请阅读并同意%@",linkArray.firstObject];;
     [SRSAttributedClickLabelAlert alertWithConfigLable:^(TTTAttributedLabel * _Nonnull lable) {
         //赋值
         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:full attributes: @{NSForegroundColorAttributeName: kHexColor(0x333333),NSFontAttributeName: FONT_REGULAR(16)}];
         for (NSString *url in linkArray) {
             NSRange text_range = [[attributedString string] rangeOfString:url];
             [attributedString setAttributes:@{
                 NSForegroundColorAttributeName:APP_MAIN_COLOR,
                 NSFontAttributeName:FONT_REGULAR(16)
             } range:text_range];
             [lable addLinkToTransitInformation:@{@"url":url} withRange:[full rangeOfString:url]];
         }
         lable.attributedText = attributedString;


     } clickLinkModel:^(NSDictionary *components) {
         if ([[components getString:@"url"] isEqualToString:linkArray.firstObject]) {
             [REEventHandler jumpWithUrl:[NSString getRouterUniUrlStringFromUrlString:nil andParams:@{@"path":kWLY_PAGE_AD_DETAIL_AGREE,@"entryType":@(11),@"id":safeString(self.privacyAgreementInfo[@"id"])}]];
         }
     } ActionNames:@[@"我再想想",@"同意"] clickAcion:^(NSInteger index) {
         if (index == 1) {
             [self certainBtnActionChange];
         }
     }];
 }

 */
