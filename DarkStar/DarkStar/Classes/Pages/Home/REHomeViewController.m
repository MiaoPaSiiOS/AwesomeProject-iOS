//
//  REHomeViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "REHomeViewController.h"
#import <DarkStarFeedKit/DarkStarFeedKit.h>
#import <DarkStarAccountKit/DarkStarAccountKit.h>
#import <CTMediator/CTMediator.h>

@interface REHomeViewController ()

@end

@implementation REHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DS_CREATE_UI({
        DS_BUTTON_WITH_ACTION(@"登录方式：TouchID", TouchIDLogin)
        DS_BUTTON_WITH_ACTION(@"登录方式：AppleID", AppleIDLogin)
        DS_BUTTON_WITH_ACTION(@"goToFeed", goToFeed)
        DS_BUTTON_WITH_ACTION(@"openWebOfBaidu", openWebOfBaidu)
        DS_BUTTON_WITH_ACTION(@"openWebOfLocalHtml", openWebOfLocalHtml)
        DS_BUTTON_WITH_ACTION(@"openWebOfLocalHtml_SRSJSTest2", openWebOfLocalHtml_SRSJSTest2)
    }, self.nrView);

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



- (void)loadCacheData {
//    [AMENUIDataManager achieveJSONCacheDataWithJsonUrl:@"https://gitee.com/api/v5/repos/tuay-orn/amen-data-mock/contents/json%2Fjd_browseHistory_1.json" completeHandler:^(BOOL success, NSDictionary * _Nonnull datas) {
//        if (success) {
//            NSLog(@"获取缓存数据-成功 \n%@",datas);
//            [AMENShareUtil showMessageWithTitle:[NSString stringWithFormat:@"%@",datas]];
//        } else {
//            NSLog(@"获取缓存数据-失败");
//        }
//    }];
}

- (void)loadDataFromServer {
//    [AMENUIDataManager achieveJSONDataWithJsonUrl:@"https://gitee.com/api/v5/repos/tuay-orn/amen-data-mock/contents/json%2Fjd_browseHistory_1.json" completeHandler:^(BOOL success, NSDictionary * _Nonnull datas) {
//        if (success) {
//            NSLog(@"获取服务器数据-成功 \n%@",datas);
//            [AMENShareUtil showMessageWithTitle:[NSString stringWithFormat:@"%@",datas]];
//        } else {
//            NSLog(@"获取服务器数据-失败");
//        }
//    }];
}

- (void)openWebOfBaidu {
//    [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//        @"url":@"https://www.baidu.com"
//    }];
}

- (void)openWebOfLocalHtml {
//    NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] bundlePath], @"www.amen.com"];
//    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//    NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//    NSURL *fileUrl = [NSURL URLWithString:filePath];
//    [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//        @"closeWhiteList":@"1",
//        @"loadType":@"1",
//        @"fileURL":fileUrl,
//        @"readAccessURL":baseUrl
//    }];
//
    
}

- (void)openWebOfLocalHtml_SRSJSTest2 {
//    NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] bundlePath], @"SRSJSTest2"];
//    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//    NSString *filePath = [NSString stringWithFormat: @"file://%@/test.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//    NSURL *fileUrl = [NSURL URLWithString:filePath];
//    [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//        @"closeWhiteList":@"1",
//        @"loadType":@"1",
//        @"fileURL":fileUrl,
//        @"readAccessURL":baseUrl
//    }];
//    NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] bundlePath], @"SDBridgeOCTest"];
//    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//    NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//    NSURL *fileUrl = [NSURL URLWithString:filePath];
//    [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//        @"closeWhiteList":@"1",
//        @"loadType":@"1",
//        @"fileURL":fileUrl,
//        @"readAccessURL":baseUrl
//    }];
}


@end
