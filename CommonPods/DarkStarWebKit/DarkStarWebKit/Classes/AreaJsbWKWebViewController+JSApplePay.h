//
//  AreaJsbWKWebViewController+JSApplePay.h
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "AreaJsbWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AreaJsbWKWebViewController (JSApplePay)

@property(nonatomic, strong) NSString *applePayCallBack;//applePay支付回调方法
@property(nonatomic, strong) NSString *applePayResultUrl;//applePay支付结果页URL
@property(nonatomic, strong) NSString *applePayBindCard;//applePay 绑卡实体卡


/// 注册ApplePay相关
- (void)registerHandlerApplePay;

@end

NS_ASSUME_NONNULL_END
