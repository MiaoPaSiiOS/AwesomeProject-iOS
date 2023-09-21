//
//  GKDYHeader.h
//  Pods
//
//  Created by zhuyuhui on 2021/6/22.
//

#ifndef GKDYHeader_h
#define GKDYHeader_h
#import <GPUImage/GPUImage.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarUIComponents/DarkStarUIComponents.h>

#import "AmShViUtils.h"
#import "MyFilter.h"
#import "MHVideoTool.h"
#import "MHGetPermission.h"
#import "MAlertView.h"




typedef enum : NSInteger  {
    MHShootSpeedTypeMoreSlow       = 0, //极慢
    MHShootSpeedTypeaSlow          = 1, //慢
    MHShootSpeedTypeNomal          = 2, //标准
    MHShootSpeedTypeFast           = 3, //快
    MHShootSpeedTypeMorefast       = 4, //极快
}MHShootSpeedType;//视频拍摄速度类型

typedef enum : NSInteger  {
    MHPostVideoOpenTypeOpen          = 0, //公开
    MHPostVideoOpenTypeOnlyFriend    = 1, //仅好友可见
    MHPostVideoOpenTypeUnOpen        = 2, //不公开
}MHPostVideoOpenType;//视频发布 公开类型

#endif /* GKDYHeader_h */
