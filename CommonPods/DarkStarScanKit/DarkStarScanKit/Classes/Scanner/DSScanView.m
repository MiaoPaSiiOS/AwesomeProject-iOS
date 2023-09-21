//
//  DSScanView.m
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSScanView.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSScannerTool.h"
#import "DSScanner.h"

static NSString *const scanLineAnimationName = @"scanLineAnimation";


@interface DSScanView()<DSScannerDelegate>

@property (nonatomic, strong) DSScanner *scanner;

/**
 扫描区域的Frame
 */
@property (nonatomic, assign) CGRect scanRect;


@property (nonatomic, assign) CGFloat scanTime;
@property (nonatomic, assign) CGFloat scanLineHeight;///扫描线高度

/// 扫码类型 默认 DSScannerTypeQRCode
@property (nonatomic, assign) DSScannerType scannerType;

@end

@implementation DSScanView


- (instancetype)initWithFrame:(CGRect)frame
                 withScanRect:(CGRect)scanRect
                 withScanTime:(CGFloat)scanTime
           withScanLineHeight:(CGFloat)scanLineHeight
                     withType:(DSScannerType)type {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.scanRect = scanRect;
        self.scanTime = scanTime;
        self.scannerType = type;
        self.scanLineHeight = scanLineHeight;
        self.showScanLine = YES;
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withType:(DSScannerType)type {
    CGSize scanSize;
    if (type == DSScannerTypeBarCode) {
        scanSize = CGSizeMake(265, 132);
    } else {
        scanSize = CGSizeMake(265, 265);
    }
    CGRect a = CGRectMake((kScreenWidth - scanSize.width)/2,(kScreenHeight - scanSize.width)/2, scanSize.width, scanSize.height);
    return [self initWithFrame:frame withScanRect:a withScanTime:3.0 withScanLineHeight:11 withType:type];
}
- (void)setupViews{
    [self addSubview:self.scanLine];
    [self addSubview:self.maskView];
    [self addScanBox];
}


- (void)showScanLine:(BOOL)showScanLine{
    if (showScanLine && self.isShowScanLine) {
        [self addScanLineAnimation];
    }else{
        [self removeScanLineAnimation];
    }
}

- (void)addScanLineAnimation{
    self.scanLine.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(self.scanRect.size.height - self.scanLineHeight);
    animation.duration = self.scanTime;
    animation.repeatCount = OPEN_MAX;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.scanLine.layer addAnimation:animation forKey:scanLineAnimationName];
}


- (void)removeScanLineAnimation{
    self.scanLine.hidden = YES;
    [self.scanLine.layer removeAnimationForKey:scanLineAnimationName];
}


- (void)addScanBox{
    // 扫描框
    _middleIcon = [[UIImageView alloc] init];
    self.middleIcon.frame = CGRectMake(self.scanRect.origin.x - 3,self.scanRect.origin.y - 3, self.scanRect.size.width + 6, self.scanRect.size.height + 6);
    if (self.scannerType == DSScannerTypeBarCode) {
        self.middleIcon.image = [DSScannerTool imageNamed:@"biankuang"];
    } else {
        self.middleIcon.image = [DSScannerTool imageNamed:@"Scan_Box_Blue"];
    }
    [self addSubview:self.middleIcon];
    
    _infolabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-250)/2,self.middleIcon.bottom+20,250,21)];
    if (self.scannerType == DSScannerTypeQRCode) {
        self.infolabel.text = @"将二维码放入框内进行扫描";
    } else if (self.scannerType == DSScannerTypeBarCode) {
        self.infolabel.text = @"将条形码放入框内进行扫描";
    } else {
        self.infolabel.text = @"将条形码/二维码放入框内进行扫描";
    }
    self.infolabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.infolabel.textAlignment = 1;
    self.infolabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.infolabel];
    
}

#pragma mark - 遮罩层

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        UIBezierPath *fullBezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *scanBezierPath = [UIBezierPath bezierPathWithRect:self.scanRect];
        [fullBezierPath appendPath:[scanBezierPath  bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = fullBezierPath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }
    return _maskView;
}

#pragma mark -- 扫描线
- (UIImageView *)scanLine{
    
    if (!_scanLine) {
        _scanLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.scanRect.origin.x+34/2.,self.scanRect.origin.y, self.scanRect.size.width - 34, self.scanLineHeight)];
        if (self.scannerType == DSScannerTypeBarCode) {
            _scanLine.image = [DSScannerTool imageNamed:@"saomiao"];
        } else {
            _scanLine.image = [DSScannerTool imageNamed:@"Scan_Line"];
        }
        _scanLine.hidden = YES;
        
    }
    return _scanLine;
}



- (NSError *)start {
    if (!self.scanner) {
        self.scanner = [[DSScanner alloc] initWithDelegate:self];
        self.scanner.typeCode = self.scannerType;
    }
    NSError *err = [self.scanner startScanner];
    if (err) return err;
    [self showScanLine:YES];
    return nil;
}
- (void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showScanLine:NO];
    });
    [self.scanner stopScanner];
}

#pragma mark - DSScannerDelegate
- (CGRect)dsScannerRectOfInterest {
    if (self.scanRect.size.width == 0 || self.scanRect.size.height == 0) {
        CGSize scanSize = CGSizeMake(265, 265);
        CGRect a = CGRectMake(([UIScreen mainScreen].bounds.size.width - scanSize.width)/2,([UIScreen mainScreen].bounds.size.height - scanSize.width)/2, scanSize.width, scanSize.height);
        return a;
    } else {
        return self.scanRect;
    }
}

- (UIView *)dsScannerPreviewView {
    return self;
}

- (void)dsScannerResult:(NSString * _Nullable)result withSuccess:(BOOL)isSuccess {
    [self stop];
    if (self.resultBlock) {
        self.resultBlock(result);
    }
}
@end
