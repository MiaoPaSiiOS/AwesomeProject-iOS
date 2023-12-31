//
//  REHomeViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "REHomeViewController.h"
#import <CTMediator/CTMediator.h>
#import <DarkStarFeedKit/DarkStarFeedKit.h>
#import <DarkStarAccountKit/DarkStarAccountKit.h>
#import <DarkStarWebKit/DarkStarWebKit.h>
#import <DarkStarAwesomeKit/DarkStarAwesomeKit.h>
#import <DarkStarEnjoyCameraKit/DarkStarEnjoyCameraKit.h>
#import <DarkStarShootVideoKit/DarkStarShootVideoKit.h>


@interface REHomeViewController ()

@end

@implementation REHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DS_CREATE_UI({
        DS_BUTTON_WITH_ACTION(@"登录方式：TouchID", TouchIDLogin)
        DS_BUTTON_WITH_ACTION(@"登录方式：AppleID", AppleIDLogin)
        DS_BUTTON_WITH_ACTION(@"微博、推特Feed流展示", goToFeed)
        DS_BUTTON_WITH_ACTION(@"webview相关", openWebView)
        DS_BUTTON_WITH_ACTION(@"Awesome", goAwesome)
        DS_BUTTON_WITH_ACTION(@"EnjoyCamera", goEnjoyCamera)
        DS_BUTTON_WITH_ACTION(@"ShootVideo", goShootVideo)
    }, self.dsView);

}
-(void)goShootVideo {
    [[CTMediator sharedInstance] mediator_ShowShootVideoViewController:@{}];
}
-(void)goEnjoyCamera {
    [[CTMediator sharedInstance] mediator_showQMCameraViewController:@{}];
}

-(void)goAwesome {
    [[CTMediator sharedInstance] mediator_pushAwesomeKitController:@{}];
}

- (void)goToFeed {
    [[CTMediator sharedInstance] mediator_showFeedViewController:@{}];
}

- (void)TouchIDLogin {
    NSDictionary *parameters = @{ @"touchIDType" : @"1",
                                  @"popStyle" : @"present",
    };
    [[CTMediator sharedInstance] mediator_TouchIDApp:parameters.mutableCopy completion:^(id response) {

    }];
}

- (void)AppleIDLogin {
    NSDictionary *parameters = @{ @"touchIDType" : @"1",
                                  @"popStyle" : @"present",
    };
    [[CTMediator sharedInstance] mediator_AppleIDApp:parameters.mutableCopy completion:^(id response) {

    }];
}

- (void)openWebView {
    [[CTMediator sharedInstance] mediator_pushWebViewDemoController:@{}];
}


@end
