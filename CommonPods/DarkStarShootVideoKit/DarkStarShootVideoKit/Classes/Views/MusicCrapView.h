//
//  MusicCrapView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/20.
//  Copyright © 2018 mh. All rights reserved.
//  背景音乐裁剪

#import <UIKit/UIKit.h>
#import "GKDYHeader.h"

typedef void(^CrapBGMStartTimeCallBack)(NSInteger startTime);

@interface MusicCrapView : UIView

+(void)showCrapBGMName:(NSString *)bgmName startTime:(NSInteger)startTime callBack:(CrapBGMStartTimeCallBack)callBack;

@end

