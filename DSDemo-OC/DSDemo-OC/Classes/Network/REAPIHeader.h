//
//  REAPIHeader.h
//  REO2O
//
//  Created by 李朕 on 2018/10/15.
//  Copyright © 2018 RE. All rights reserved.
//

#ifndef REAPIHeader_h
#define REAPIHeader_h

/*=========================第三方登录==========================*/
//static const NSInteger showQQ = 1;
//static const NSInteger showWeChat = 1;
//static const NSInteger showWeibo = 1;
//static const NSInteger showApple = 1;

/*===========================用户线============================*/
////初始化登录
//static NSString * const RE_LOGIN_INIT = @"ouser-web/api/user/init.do";
////注册
//static NSString * const RE_REGISTER = @"ouser-web/api/user/register.do";

//获取公钥
static NSString * const RE_GET_Encryption = @"ouser-web/mobileLogin/getEncryption";
//登录
static NSString * const RE_LOGIN = @"ouser-web/mobileLogin/loginIdp";
//隐私协议
static NSString * const RE_GET_ENTRY_TERMS = @"ouser-web/entryTerms/getEntryTerms";
//获取用户权限店铺
static NSString * const RE_AuthStore= @"ouser-web/api/store/queryWlyStoreOrgPageByAuth.do";
//获取用户个人信息
static NSString * const RE_GET_USERINFO = @"ouser-web/api/user/info/getUserDetails.do";
//更新用户个人信息
static NSString * const RE_UPDATE_USERINFO = @"ouser-web/api/user/info/update.do";
//门店权益信息
static NSString * const RE_STORE_DIVIDENDS = @"oms-api/openApi2/wly/storeDividends.do";
//门店权益信息明细
static NSString * const RE_STORE_DIVIDENDS_DETAIL = @"oms-api/openApi2/wly/storeDividendsDetail.do";
//首页消息
static NSString * const RE_GET_MESSAGE_COUNT = @"social-web/frontapi/my/notifycenter/count";
//消息列表
static NSString * const RE_GET_MESSAGE_LIST = @"social-web/frontapi/my/notifycenter/message/listPage";
//获取待办列表
static NSString * const RE_GET_TODO_TASK_LIST = @"social-web/frontapi/my/notifycenter/task/listPage";
//
static NSString * const RE_GET_listMultiCode = @"ouser-web/public/config/listMultiCode";
//检测APP版本是否更新接口
static NSString * const RE_CHAECK_UPGRADE = @"api/app/upgrade";
//获取应用列表
static NSString * const RE_GET_LIST_APPLY = @"ouser-web/frontapi/my/application/list";
//首页轮播
static NSString * const RE_GET_AD_SOURCE = @"cms-web/frontapi/adMaterial/list";
//查询订单信息
static NSString * const RE_QueryOrderInfo = @"oms-api/order/query/get";


////校验员工号与手机号是否匹配
//static NSString * const RE_CHECK_WORKNUM_MOBILE_REPEAT = @"ouser-web/mobileRegister/checkMobileEmpNum";
////检测账号是否已注册
//static NSString * const RE_CHECK_MOBILE_REPEAT = @"ouser-web/api/user/checkAccountRepeat.do";
////校验验证码
//static NSString * const RE_CHECK_CAPTCHA = @"ouser-web/api/user/checkMobileCaptcha.do";
//
////忘记密码校验验证码
//static NSString * const REPWD_CHECK_CAPTCHA = @"ouser-web/mobileRegister/checkCaptchasForm.do";
//
///*===========================手机注册============================*/
////忘记密码
//static NSString * const RE_FORGET_PASSWORD = @"ouser-web/mobileRegister/modifyPasswordForm.do";
////获取图片验证码
//static NSString * const RE_GET_IMG_CAPTCHA = @"ouser-web/mobileRegister/checkImageForm.do";
////获取验证码
//static NSString * const RE_GET_CAPTCHA = @"ouser-web/mobileRegister/sendCaptchas.do";
//
///*===========================联合登录============================*/
////联合登录
//static NSString * const RE_UNIONLOGIN = @"ouser-web/api/union/appLogin.do";
//static NSString * const QQWB_UNIONLOGIN = @"ouser-web/api/union/forceLogin.do";
////账号设置密码
//static NSString * const RE_BIND_PASSWORD = @"ouser-web/api/union/bindUserPassword.do";
////查询用户是否设置了密码
//static NSString * const RE_CHECK_PASSWORD = @"ouser-web/api/union/checkPassword.do";
//
////apple 登录
//static NSString * const RE_UNION_IOSLOGIN = @"ouser-web/api/union/iosLogin";
//
///*===========================联合登录============================*/
////绑定手机
//static NSString * const RE_BIND_PHONE = @"ouser-web/api/union/bindUnionMobile.do";
//
//
////根据类型获取协议 1：商家入驻条款  2：店铺入驻条款 3：注册协议 4：签到规则 5：发票规则 6：评价规则 7：积分规则
////8：营销协议  9：拼团规则  10：软件使用许可协议
//static NSString * const ENTRY_TERMS = @"ouser-web/entryTerms/getEntryTerms.do";
//
////退出登录
//static NSString * const USER_LOGOUT = @"ouser-web/mobileLogin/exit.do";

#endif /* REAPIHeader_h */
