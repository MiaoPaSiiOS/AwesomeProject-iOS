//
//  FWHudsonFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "GPUImageFourInputFilterEx.h"
#import "GKDYHeader.h"
@interface FWFilter5 : GPUImageFourInputFilterEx

@end

@interface FWHudsonFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@end
