//
//  NrLOTGIFImageView.m
//  NrLottieMixView
//
//  Created by zhuyuhui on 2023/1/9.
//

#import "NrLOTGIFImageView.h"
#import <SDWebImage/SDWebImage.h>
@interface NrLOTGIFImageView()
@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) NSMutableArray *gifImgArray;
@end


@implementation NrLOTGIFImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.gifView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gifView.frame = self.bounds;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self loadImage];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.gifView.image = image;
}

- (void)loadImage {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:self.url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            SDImageFormat format = [NSData sd_imageFormatForImageData:data];
            if(format == SDImageFormatGIF){
                self.imgData = data;
                [self createImgArray];
            } else {
                [self.gifView sd_setImageWithURL:[NSURL URLWithString:self.url]];
            }
        }
    }];
}


/// 创建 gif 每一帧数组, 生成动画, 第一帧赋值给 normalImgView, 最后一帧赋值给 highlightedImgView
- (void)createImgArray {
    // 1.获取CFDataRef类型
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)self.imgData, nil);
    // 3.获取gif图片中图片的个数
    NSInteger frameCount = CGImageSourceGetCount(imageSource);
    // 记录播放时间
    float duration = 0;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < frameCount; i++) {
        // 3.1.获取图片
        CGImageRef cgImgae = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
        // 3.2.获取时长
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
        NSDictionary *gifDict = (__bridge_transfer NSDictionary *)properties;
        NSDictionary *gifInfo = [gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSNumber *frameDuration = [gifInfo objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
        duration += frameDuration.doubleValue;

        UIImage *frameImg = [UIImage imageWithCGImage:cgImgae];
        CFRelease(cgImgae);
        [images addObject:frameImg];

        // 设置停止播放时显示的图片
        if (i == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.gifView.image = frameImg;
            });
        }
    }
    CFRelease(imageSource);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 4.播放图片
        self.gifView.animationImages = images;
        // 播放总时间
        self.gifView.animationDuration = duration;
        // 播放次数, 0为无限循环
        self.gifView.animationRepeatCount = 0;
        // 开始播放
        self.gifImgArray = images;
        
        [self.gifView startAnimating];
    });
}


#pragma mark - getter setter
- (UIImageView *)gifView {
    if (!_gifView) {
        _gifView = [[UIImageView alloc] init];
    }
    return _gifView;
}


@end
