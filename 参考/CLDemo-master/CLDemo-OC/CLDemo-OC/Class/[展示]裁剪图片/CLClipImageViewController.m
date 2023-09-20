//
//  CLClipImageViewController.m
//  CLDemo-OC
//
//  Created by zhuyuhui on 2022/8/31.
//

#import "CLClipImageViewController.h"

@interface CLClipImageViewController ()
@property(nonatomic, strong) UIImageView *orignalImgView;
@property(nonatomic, strong) UIImageView *clipImgView;
@end

@implementation CLClipImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = 120;
    CGFloat height = 120;
    // Do any additional setup after loading the view.
    self.orignalImgView = [[UIImageView alloc] init];
    [self.view addSubview:self.orignalImgView];
    [self.orignalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNaviBarHeight);
        make.left.mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
    self.clipImgView = [[UIImageView alloc] init];
    [self.view addSubview:self.clipImgView];
    [self.clipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orignalImgView.mas_bottom).offset(10);
        make.left.mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    self.clipImgView.layer.borderColor = [UIColor redColor].CGColor;
    self.clipImgView.layer.borderWidth = 2;
    
    //
    self.orignalImgView.image = [UIImage imageNamed:@"one"];
    // 异步子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image1 = [self clipImageWithImage:[UIImage imageNamed:@"one"]
                                              rect:CGRectMake(width * 0.25, -height * 0.25, width, height)
                                        startAngle:-90 endAngle:(30)];
        UIImage *image2 = [self clipImageWithImage:[UIImage imageNamed:@"two"]
                                              rect:CGRectMake(0, height * 0.25, width, height)
                                        startAngle:30 endAngle:(150)];
        UIImage *image3 = [self clipImageWithImage:[UIImage imageNamed:@"three"]
                                              rect:CGRectMake(-width * 0.25, -height * 0.25, width, height)
                                        startAngle:150 endAngle:(270)];
        UIImage *image = [self mergeImgaeWithImageArray:@[
            image1,
            image2,
            image3
        ] size:CGSizeMake(width, height)];
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.clipImgView.image = image;
        });
    });
}

- (UIImage *)clipImageWithImage:(UIImage *)image rect:(CGRect)rect startAngle:(CGFloat)startAngle endAngle:(CGFloat )endAngle {
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width * 0.5, size.height * 0.5)
                                                         radius:size.width * 0.5
                                                     startAngle:(M_PI * (startAngle) / 180.0)
                                                       endAngle:(M_PI * (endAngle) / 180.0)
                                                      clockwise:YES];//按照顺时针方向
    [path1 addLineToPoint:CGPointMake(size.width * 0.5, size.height * 0.5)];
    [path1 addClip];
    [image drawInRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), size.width, size.height)];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipImage;
}
- (UIImage *)mergeImgaeWithImageArray:(NSArray<UIImage *> *)imageArray size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    for (UIImage *image in imageArray) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
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
