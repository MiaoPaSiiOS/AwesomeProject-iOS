//
//  Target_AmenWebKit.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "Target_AmenWebKit.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <MJExtension/MJExtension.h>
#import "AreaJsbWKWebViewController.h"
#import "AreaJsbWKWebViewDemoController.h"

@implementation Target_AmenWebKit

- (void)Action_pushWebViewController:(nullable NSDictionary *)parameter;
{
    AreaJsbRequestModel *reqModel = [[AreaJsbRequestModel alloc] init];
    reqModel.closeWhiteList    = parameter[@"closeWhiteList"] ? [parameter[@"closeWhiteList"] boolValue] : NO;
    reqModel.isNeedReload      = parameter[@"isNeedReload"] ? [parameter[@"isNeedReload"] boolValue] : NO;
    reqModel.forbiddenGesture  = parameter[@"forbiddenGesture"] ? [parameter[@"forbiddenGesture"] boolValue] : NO;
    
    NSString *loadType = parameter[@"loadType"];
    if (isStringEmptyOrNil(loadType)) {
        if (isStringEmptyOrNil(parameter[@"url"])) return;
        reqModel.loadType          = AresJsbWKWebViewLoadRequest;
        reqModel.requestFullURL    = parameter[@"url"];

    } else if ([loadType isEqualToString:@"1"]) {
        if (!parameter[@"fileURL"] || ![parameter[@"fileURL"] isKindOfClass:NSURL.class]) return;
        if (!parameter[@"readAccessURL"] || ![parameter[@"readAccessURL"] isKindOfClass:NSURL.class]) return;
        reqModel.loadType      = AresJsbWKWebViewLoadFileURL;
        reqModel.fileURL       = parameter[@"fileURL"];
        reqModel.readAccessURL = parameter[@"readAccessURL"];

    } else if ([loadType isEqualToString:@"2"]) {
        if (isStringEmptyOrNil(parameter[@"htmlString"])) return;
        reqModel.loadType      = AresJsbWKWebViewLoadHTMLString;
        reqModel.baseURL       = parameter[@"baseURL"];
        reqModel.htmlString    = parameter[@"htmlString"];

    } else if ([loadType isEqualToString:@"3"]) {
        if (!parameter[@"data"] || ![parameter[@"data"] isKindOfClass:NSData.class]) return;
        if (!parameter[@"baseURL"] || ![parameter[@"baseURL"] isKindOfClass:NSURL.class]) return;
        if (isStringEmptyOrNil(parameter[@"MIMEType"])) return;
        if (isStringEmptyOrNil(parameter[@"characterEncodingName"])) return;
        reqModel.loadType      = AresJsbWKWebViewLoadData;
        reqModel.characterEncodingName = parameter[@"characterEncodingName"];
        reqModel.data          = parameter[@"data"];
        reqModel.MIMEType      = parameter[@"MIMEType"];
        reqModel.baseURL       = parameter[@"baseURL"];
    }



    AreaJsbWKWebViewController *webController = [[AreaJsbWKWebViewController alloc] init];
    webController.reqModel = reqModel;
    [self.ds_topViewController.navigationController pushViewController:webController animated:YES];
}

- (void)Action_pushWebViewDemoController:(nullable NSDictionary *)parameter {
    AreaJsbWKWebViewDemoController *webController = [[AreaJsbWKWebViewDemoController alloc] init];
    [self.ds_topViewController.navigationController pushViewController:webController animated:YES];
}
@end
