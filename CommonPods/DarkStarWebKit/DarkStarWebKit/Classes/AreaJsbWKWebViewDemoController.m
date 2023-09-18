//
//  AreaJsbWKWebViewDemoController.m
//  DarkStarWebKit
//
//  Created by zhuyuhui on 2023/9/16.
//

#import "AreaJsbWKWebViewDemoController.h"
#import <MJExtension/MJExtension.h>
#import "CTMediator+AmenWebKit.h"
#import "DSWebKitGlobal.h"
@interface AreaJsbWKWebViewDemoController ()

@end

@implementation AreaJsbWKWebViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WKWebViewDemo";
    self.templates = [DSTemplate mj_objectArrayWithKeyValuesArray:@[
        @{
            @"title":@"加载网址",@"classStr":@"",@"extParmers":@{@"type":@"0"}
        },
        @{
            @"title":@"加载Bundle中的资源文件(文件夹：'www.amen.com')",@"classStr":@"",@"extParmers":@{@"type":@"1"}
        },
        @{
            @"title":@"加载Bundle中的资源文件(文件夹：SRSJSTest2)",@"classStr":@"",@"extParmers":@{@"type":@"2"}
        },
        @{
            @"title":@"加载Bundle中的资源文件(文件夹：SDBridgeOCTest)",@"classStr":@"",@"extParmers":@{@"type":@"3"}
        },
    ]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isArrayEmptyOrNil(self.templates)) {
        DSTemplate *model = [self.templates ds_objectWithIndex:indexPath.row];
        if (!isDictEmptyOrNil(model.extParmers)) {
            NSString *type = [model.extParmers valueForKey:@"type"];
            if ([type isEqualToString:@"0"]) {
                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
                    @"url":@"https://www.baidu.com/",
                }];
            }
            else if ([type isEqualToString:@"1"]) {
                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"www.amen.com"];
                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
                NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
                NSURL *fileUrl = [NSURL URLWithString:filePath];
                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
                    @"closeWhiteList":@"1",
                    @"loadType":@"1",
                    @"fileURL":fileUrl,
                    @"readAccessURL":baseUrl
                }];

            }
            else if ([type isEqualToString:@"2"]) {
                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"SRSJSTest2"];
                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
                NSString *filePath = [NSString stringWithFormat: @"file://%@/test.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
                NSURL *fileUrl = [NSURL URLWithString:filePath];
                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
                    @"closeWhiteList":@"1",
                    @"loadType":@"1",
                    @"fileURL":fileUrl,
                    @"readAccessURL":baseUrl
                }];
            }
            else if ([type isEqualToString:@"3"]) {
                NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[DSWebKitGlobal AssetsBundle] bundlePath], @"SDBridgeOCTest"];
                NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
                NSString *filePath = [NSString stringWithFormat: @"file://%@/index.html#/?xxx=%@&sss=%@", basePath, @"xxx", @"sss"];
                NSURL *fileUrl = [NSURL URLWithString:filePath];
                [[CTMediator sharedInstance] mediator_pushWebViewController:@{
                    @"closeWhiteList":@"1",
                    @"loadType":@"1",
                    @"fileURL":fileUrl,
                    @"readAccessURL":baseUrl
                }];

            }
        }
    }
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
