//
//  FWNashvilleFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/8.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//
#import <GPUImage/GPUImage.h>
#import "GKDYHeader.h"
@interface FWFilter1 : GPUImageTwoInputFilter



@end

@interface FWNashvilleFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource ;
}

@end
