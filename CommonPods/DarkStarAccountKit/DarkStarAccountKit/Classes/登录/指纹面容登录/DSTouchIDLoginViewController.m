//
//  DSTouchIDLoginViewController.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "DSTouchIDLoginViewController.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "DSTouchIDInfoUtil.h"
#import "DSAccountTool.h"

typedef enum {// 按钮tag
    buttonTagTouchID = 1,       // 中间指纹按钮
    buttonTagTouchIDCheck,      // 切换登录方式
    buttonTagTouchIDRegister    // 注册
}MybuttonTag;



@interface DSTouchIDLoginViewController ()
// 判断设备是FaceID设备而不是指纹
@property (nonatomic, assign) BOOL isFaceIDDevice;
@end

@implementation DSTouchIDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
    self.dsView.backgroundColor = [DSHelper colorWithHexString:@"0xffffff"];
    _isFaceIDDevice = [DSTouchIDInfoUtil returnTheResultOfFaceID];
    if (_isFaceIDDevice) {
        self.title = @"面容ID登录";
        [self initFaceIDLoginView];
        [self verifyMyFaceID];
    } else {
        self.title = @"指纹登录";
        [self initTouchIDLoginView];
        [self verifyMyTouchID];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)backToPrev {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化TouchID界面
- (void)initTouchIDLoginView {
    // 用户头像，截取圆形
    UIImageView *userHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    userHead.clipsToBounds = YES;
    userHead.layer.cornerRadius = userHead.width / 2;
    userHead.center = CGPointMake(DSDeviceInfo.screenWidth / 2, userHead.height / 2 + 20 + 40);
    //用户头像，根据userId获取用户头像
    userHead.image = [DSAccountTool imageNamed:@"gestureHead"];
    [self.dsView addSubview:userHead];

    // 用户名
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DSDeviceInfo.screenWidth, 16)];
    nameLb.center = CGPointMake(DSDeviceInfo.screenWidth / 2, userHead.centerY + userHead.height / 2 + 15 + nameLb.height / 2);
    nameLb.font = [UIFont systemFontOfSize:15];
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.textColor = [UIColor blackColor];
    nameLb.text = @"176****6897";
    [self.dsView addSubview:nameLb];

    // 中间指纹按钮
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:touchBtn frame:CGRectMake((DSDeviceInfo.screenWidth - 75) / 2, nameLb.bottom + 70, 75, 86) title:nil font:nil image:[DSAccountTool imageNamed:@"touchId"]  tag:buttonTagTouchID changeColor:NO];

    // 提示话术按钮
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:tipButton frame:CGRectMake(0, touchBtn.bottom + 10, DSDeviceInfo.screenWidth, 20) title:@"点击使用指纹登录" font:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f] image:nil tag:buttonTagTouchID changeColor:NO];

    // 初始化“切换登录方式”按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:checkButton frame:CGRectMake(0, DSDeviceInfo.screenHeight - 90, DSDeviceInfo.screenWidth, 30) title:@"更多登录方式" font:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f] image:nil tag:buttonTagTouchIDCheck changeColor:NO];
}

#pragma mark - 初始化FaceID界面
- (void)initFaceIDLoginView {
    // 用户头像，截取圆形
    UIImageView *userHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    userHead.clipsToBounds = YES;
    userHead.layer.cornerRadius = userHead.width / 2;
    userHead.center = CGPointMake(DSDeviceInfo.screenWidth / 2, userHead.height / 2 + 20 + 40);
    //用户头像，根据userId获取用户头像
    userHead.image = [DSAccountTool imageNamed:@"gestureHead"];
    [self.dsView addSubview:userHead];

    // 用户名
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DSDeviceInfo.screenWidth, 16)];
    nameLb.center = CGPointMake(DSDeviceInfo.screenWidth / 2, userHead.centerY + userHead.height / 2 + 15 + nameLb.height / 2);
    nameLb.font = [UIFont systemFontOfSize:15];
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.textColor = [UIColor blackColor];
    nameLb.text = @"176****6897";
    [self.dsView addSubview:nameLb];

    // 中间指纹按钮
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:touchBtn frame:CGRectMake((DSDeviceInfo.screenWidth - 75) / 2, nameLb.bottom + 70, 75, 86) title:nil font:nil image:[DSAccountTool imageNamed:@"touchId.png"]  tag:buttonTagTouchID changeColor:NO];

    // 提示话术按钮
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:tipButton frame:CGRectMake(0, touchBtn.bottom + 10, DSDeviceInfo.screenWidth, 20) title:@"点击使用指纹登录" font:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f] image:nil tag:buttonTagTouchID changeColor:NO];

    // 初始化“切换登录方式”按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:checkButton frame:CGRectMake(0, DSDeviceInfo.screenHeight - 90, DSDeviceInfo.screenWidth, 30) title:@"更多登录方式" font:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f] image:nil tag:buttonTagTouchIDCheck changeColor:NO];
}


#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title font:(UIFont *)font image:(UIImage *)image tag:(NSInteger)tag changeColor:(BOOL)changeColor {
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if (changeColor) {
        [btn setTitleColor:[DSHelper colorWithHexString:@"0x4586ff"] forState:UIControlStateNormal];
    }
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn addTarget:self action:@selector(clickButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.dsView addSubview:btn];
}

#pragma mark - button点击事件
- (void)clickButtonWithSender:(UIButton *)sender {
    switch (sender.tag) {
        case buttonTagTouchID:// 点击验证指纹
        {
            // 数据采集
            if (_isFaceIDDevice) {
                [self verifyMyFaceID];
            } else {
                [self verifyMyTouchID];
            }

            break;
        }

        case buttonTagTouchIDRegister:// 点击注册
        {
            break;
        }

        case buttonTagTouchIDCheck://点击切换登录方式
        {
            break;
        }

        default:
            break;
    }
}


#pragma mark - 验证FaceID
- (void)verifyMyFaceID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *result = @"面容ID验证失败，可切换登录方式";
    context.localizedFallbackTitle = @"切换登录方式";
//    context.localizedCancelTitle = @"cancel";
    // 值在block中有变动，属性前加__block(此为int型，注意赋初值)
    // static静态变量，未初始化时，默认赋值为0
    static LAPolicy temp;

    // 指纹验证，排除设备Touch ID被锁情况
    // iOS9之后系统使用LAPolicyDeviceOwnerAuthenticationWithBiometrics方法验证，当Touch ID被锁时，将验证方法改为LAPolicyDeviceOwnerAuthentication
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    } else {
        if (error.code == LAErrorTouchIDLockout) {
            temp = LAPolicyDeviceOwnerAuthentication;
        }
    }

    if (!temp) {
        temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }

    if ([context canEvaluatePolicy:temp error:&error]) {
        // 内外验证方法LAPolicy值保持一致
        [context evaluatePolicy:temp
                localizedReason:result
                          reply:^(BOOL success, NSError *_Nullable error) {
                              if (success) {
                                  // 指纹验证成功，切换主线程处理
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (temp == LAPolicyDeviceOwnerAuthentication) {
                                                         // 新方法只需输入设备密码可以不验证指纹，这里再次调用方法让用户必须验证面容通过
                                                         temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
                                                         [self verifyMyFaceID];
                                                     } else {
                                                         temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
                                                         // 面容验证成功，发送登录接口
                                                         [self doTouchOrFaceLogin];
                                                     }
                                                 });
                              } else {
                                  switch (error.code) {
                                      case LAErrorAuthenticationFailed: {
                                          // 身份验证失败
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              // 切换主线程处理
                                              if (DSDeviceInfo.isIOS9Later) {
                                                  temp = LAPolicyDeviceOwnerAuthentication;
                                              }
                                          }];
                                          break;
                                      }

                                      case LAErrorUserCancel: { // 用户点击取消按钮
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //  数据采集
                                              NSLog(@"验证识别FaceID弹框的取消按钮");
                                          }];
                                          break;
                                      }

                                      case LAErrorUserFallback: {
                                          // 用户点击输入密码
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //用户选择输入密码，切换主线程处理
                                              NSLog(@"验证识别FaceID弹框的切换登录方式按钮");
                                          }];
                                          break;
                                      }

                                      case LAErrorSystemCancel:
                                          // 另一个应用程序去前台

                                          break;

                                      case LAErrorPasscodeNotSet:
                                          // 密码在设备上没有设置

                                          break;

                                      case LAErrorTouchIDNotAvailable:
                                          // 触摸ID在设备上不可用

                                          break;

                                      case LAErrorTouchIDNotEnrolled:
                                          // 没有登记的手指触摸ID

                                          break;

                                      case LAErrorTouchIDLockout:
                                          // 指纹验证已锁定

                                          break;

                                      default: {
                                          // Touch ID没配置
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //其他情况，切换主线程处理
                                          }];
                                          break;
                                      }
                                  }
                              }
                          }];
    } else {
        // 设备不支持指纹
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled: {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                    [self dealWithClosedFaceID];
                }];
                break;
            }

            case LAErrorPasscodeNotSet: {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                    [self dealWithClosedFaceID];
                }];
                break;
            }

            case LAErrorTouchIDNotAvailable: {
                // 触摸ID在设备上不可用
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                    [self dealWithClosedFaceID];
                }];
                break;
            }

            default: {// 设备不支持TouchID
                // TouchID not available
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                }];
                break;
            }
        }
    }
}

#pragma mark - 验证指纹
- (void)verifyMyTouchID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *result = @"通过Home键验证已有手机指纹";
    context.localizedFallbackTitle = @"切换登录方式";

    // 值在block中有变动，属性前加__block(此为int型，注意赋初值)
    // static静态变量，未初始化时，默认赋值为0
    static LAPolicy temp;

    // 指纹验证，排除设备Touch ID被锁情况
    // iOS9之后系统使用LAPolicyDeviceOwnerAuthenticationWithBiometrics方法验证，当Touch ID被锁时，将验证方法改为LAPolicyDeviceOwnerAuthentication
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    } else {
        if (error.code == LAErrorTouchIDLockout) {
            temp = LAPolicyDeviceOwnerAuthentication;
        }
    }

    if (!temp) {
        temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }

    if ([context canEvaluatePolicy:temp error:&error]) {
        // 内外验证方法LAPolicy值保持一致
        [context evaluatePolicy:temp
                localizedReason:result
                          reply:^(BOOL success, NSError *_Nullable error) {
                              if (success) {
                                  // 指纹验证成功，切换主线程处理
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (temp == LAPolicyDeviceOwnerAuthentication) {
                                                         // 新方法只需输入设备密码可以不验证指纹，这里再次调用方法让用户必须验证指纹通过
                                                         temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
                                                         [self verifyMyTouchID];
                                                     } else {
                                                         temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
                                                         // 指纹验证成功，发送登录接口
                                                         [self doTouchOrFaceLogin];
                                                     }
                                                 });
                              } else {
                                  switch (error.code) {
                                      case LAErrorAuthenticationFailed: {
                                          // 身份验证失败
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              // 切换主线程处理
//                                              [SRSToast toastWithMessage:@"指纹不匹配"];
                                              if (DSDeviceInfo.isIOS9Later) {
                                                  temp = LAPolicyDeviceOwnerAuthentication;
                                              }
                                          }];
                                          break;
                                      }

                                      case LAErrorUserCancel: {
                                          // 用户点击取消按钮,数据采集
                                          break;
                                      }

                                      case LAErrorUserFallback: {
                                          // 用户点击输入密码
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //用户选择输入密码，切换主线程处理
                                          }];
                                          break;
                                      }

                                      case LAErrorSystemCancel:
                                          // 另一个应用程序去前台

                                          break;

                                      case LAErrorPasscodeNotSet:
                                          // 密码在设备上没有设置

                                          break;

                                      case LAErrorTouchIDNotAvailable:
                                          // 触摸ID在设备上不可用

                                          break;

                                      case LAErrorTouchIDNotEnrolled:
                                          // 没有登记的手指触摸ID

                                          break;

                                      case LAErrorTouchIDLockout:
                                          // 指纹验证已锁定

                                          break;

                                      default: {
                                          // Touch ID没配置
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //其他情况，切换主线程处理
                                          }];
                                          break;
                                      }
                                  }
                              }
                          }];
    } else {
        // 设备不支持指纹
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled: {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                    [DSHelper showAlertControllerWithTitle:nil message:@"指纹信息发生变更，请重新添加指纹后返回解锁或直接使用密码登录" buttonTitles:@[@"取消", @"切换登录方式"] alertClick:^(int clickNumber) {
                        if (clickNumber == 1) {
                            // 切换普通方式登录
                        }
                    }];
                }];
                break;
            }

            case LAErrorPasscodeNotSet: {
                //NSLog(@"Authentication could not start, because passcode is not set on the device");
                break;
            }

            default: {// 设备不支持TouchID
                // TouchID not available
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                }];
                break;
            }
        }
    }
}

#pragma mark - 发起登录
- (void)doTouchOrFaceLogin {
    [DSHelper showAlertControllerWithTitle:nil message:@"发起登录" alertClick:nil];
}


- (void)dealWithClosedFaceID {
    // 根据用户登录模式，清空指纹token信息,存储关闭指纹登录标识
    //面容ID功能已关闭，请使用密码\n登录
    [DSHelper showAlertControllerWithTitle:nil message:@"面容ID功能已关闭，请使用密码\n登录" buttonTitles:@[@"取消", @"密码登录"] alertClick:^(int clickNumber) {
        if (clickNumber == 1) {
            // 切换普通方式登录
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
