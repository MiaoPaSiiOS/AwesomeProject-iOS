//
//  FastSlowChooseView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/16.
//  Copyright © 2018 mh. All rights reserved.
//  视频拍摄速度

#import <UIKit/UIKit.h>
#import "GKDYHeader.h"

@protocol FastSlowChooseDelegate;
@interface FastSlowChooseView : UIView

@property(nonatomic,weak)id <FastSlowChooseDelegate> delegate;
@property(nonatomic,assign,readonly)MHShootSpeedType speedType;

@end


@protocol FastSlowChooseDelegate <NSObject>

@optional
-(void)fastSlowChooseCallBack:(MHShootSpeedType)speedType;

@end
