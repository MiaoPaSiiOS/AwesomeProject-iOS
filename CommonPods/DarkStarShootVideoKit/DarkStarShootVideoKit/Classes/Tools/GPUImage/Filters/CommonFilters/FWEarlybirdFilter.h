//
//  FWEarlybirdFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "GPUImageSixInputFilterEx.h"
#import "GKDYHeader.h"
@interface FWFilter13 : GPUImageSixInputFilterEx

@end

@interface FWEarlybirdFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
    GPUImagePicture *imageSource4;
    GPUImagePicture *imageSource5;
}

@end