//
//  DSAwesomeKitViewController.m
//  Pods
//
//  Created by zhuyuhui on 2023/9/18.
//

#import "DSAwesomeKitViewController.h"
#import <MJExtension/MJExtension.h>
@interface DSAwesomeKitViewController ()

@end

@implementation DSAwesomeKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AwesomeKitDemo";
    self.templates = [DSTemplate mj_objectArrayWithKeyValuesArray:@[
        @{
            @"title":@"[展示]自定义tabbar",
            @"classStr":@"ESTabBarController",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]断点续传",
            @"classStr":@"DisplayHWDownloadRootScreen",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]标签-宽度不固定",
            @"classStr":@"DisplayCustomCollectionTagScreen",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]NrCardSwitch",
            @"classStr":@"DisplayNrCardSwitchScreen",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]SwipeTest",
            @"classStr":@"CLSwipeViewController",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]ScrollView线性滚动",
            @"classStr":@"CLScrollerViewLinerController",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]仿系统指南针",
            @"classStr":@"CLSystemCompassViewController",
            @"extParmers":@{}
        },
        @{
            @"title":@"[展示]锤子时钟效果",
            @"classStr":@"CLXLClockViewController",
            @"extParmers":@{}
        },
        

    ]];
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    if (!isArrayEmptyOrNil(self.templates)) {
//        DSTemplate *model = [self.templates ds_objectWithIndex:indexPath.row];
//        if (!isDictEmptyOrNil(model.extParmers)) {
//            NSString *type = [model.extParmers valueForKey:@"type"];
//            if ([type isEqualToString:@"0"]) {
//                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//                    @"url":@"https://www.baidu.com/",
//                }];
//            }
//            else if ([type isEqualToString:@"1"]) {
//                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"www.amen.com"];
//                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//                NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//                NSURL *fileUrl = [NSURL URLWithString:filePath];
//                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//                    @"closeWhiteList":@"1",
//                    @"loadType":@"1",
//                    @"fileURL":fileUrl,
//                    @"readAccessURL":baseUrl
//                }];
//
//            }
//            else if ([type isEqualToString:@"2"]) {
//                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"SRSJSTest2"];
//                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//                NSString *filePath = [NSString stringWithFormat: @"file://%@/test.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//                NSURL *fileUrl = [NSURL URLWithString:filePath];
//                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//                    @"closeWhiteList":@"1",
//                    @"loadType":@"1",
//                    @"fileURL":fileUrl,
//                    @"readAccessURL":baseUrl
//                }];
//            }
//            else if ([type isEqualToString:@"3"]) {
//                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"SDBridgeOCTest"];
//                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
//                NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
//                NSURL *fileUrl = [NSURL URLWithString:filePath];
//                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
//                    @"closeWhiteList":@"1",
//                    @"loadType":@"1",
//                    @"fileURL":fileUrl,
//                    @"readAccessURL":baseUrl
//                }];
//
//            }
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
