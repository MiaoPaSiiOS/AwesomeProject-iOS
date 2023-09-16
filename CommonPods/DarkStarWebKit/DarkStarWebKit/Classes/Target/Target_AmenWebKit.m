//
//  Target_AmenWebKit.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "Target_AmenWebKit.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "AreaJsbWKWebViewController.h"

@implementation Target_AmenWebKit

- (void)Action_pushWebViewController:(nullable NSDictionary *)parameter;
{
    AreaJsbWKWebViewController *webController = [[AreaJsbWKWebViewController alloc] init];
    webController.closeWhiteList    = parameter[@"closeWhiteList"] ? [parameter[@"closeWhiteList"] boolValue] : NO;
    webController.isNeedReload      = parameter[@"isNeedReload"] ? [parameter[@"isNeedReload"] boolValue] : NO;
    webController.forbiddenGesture  = parameter[@"forbiddenGesture"] ? [parameter[@"forbiddenGesture"] boolValue] : NO;
    
    NSString *loadType = parameter[@"loadType"];
    if (isStringEmptyOrNil(loadType)) {
        if (isStringEmptyOrNil(parameter[@"url"])) return;
        webController.loadType          = AmenJsbWKWebViewLoadRequest;
        webController.requestFullURL    = parameter[@"url"];

    } else if ([loadType isEqualToString:@"1"]) {
        if (!parameter[@"fileURL"] || ![parameter[@"fileURL"] isKindOfClass:NSURL.class]) return;
        if (!parameter[@"readAccessURL"] || ![parameter[@"readAccessURL"] isKindOfClass:NSURL.class]) return;
        webController.loadType      = AmenJsbWKWebViewLoadFileURL;
        webController.fileURL       = parameter[@"fileURL"];
        webController.readAccessURL = parameter[@"readAccessURL"];

    } else if ([loadType isEqualToString:@"2"]) {
        if (isStringEmptyOrNil(parameter[@"htmlString"])) return;
        webController.loadType      = AmenJsbWKWebViewLoadHTMLString;
        webController.baseURL       = parameter[@"baseURL"];
        webController.htmlString    = parameter[@"htmlString"];

    } else if ([loadType isEqualToString:@"3"]) {
        if (!parameter[@"data"] || ![parameter[@"data"] isKindOfClass:NSData.class]) return;
        if (!parameter[@"baseURL"] || ![parameter[@"baseURL"] isKindOfClass:NSURL.class]) return;
        if (isStringEmptyOrNil(parameter[@"MIMEType"])) return;
        if (isStringEmptyOrNil(parameter[@"characterEncodingName"])) return;
        webController.loadType      = AmenJsbWKWebViewLoadData;
        webController.characterEncodingName = parameter[@"characterEncodingName"];
        webController.data          = parameter[@"data"];
        webController.MIMEType      = parameter[@"MIMEType"];
        webController.baseURL       = parameter[@"baseURL"];
    }

    [self.ds_topViewController.navigationController pushViewController:webController animated:YES];
}

@end
