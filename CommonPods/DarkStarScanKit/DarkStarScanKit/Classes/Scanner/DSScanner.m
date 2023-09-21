//
//  DSScanner.m
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSScanner.h"
#import <DarkStarAuthorityKit/DarkStarAuthorityKit.h>
#import "DSScanEventLog.h"
@interface DSScanner() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, assign, readwrite) CGRect scanRect;
@property (nonatomic, assign) BOOL isConfig;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation DSScanner

- (instancetype)initWithDelegate:(id<DSScannerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.typeCode = DSScannerTypeQRCode;
    }
    return self;
}

- (NSError *)startScanner {
    if (!self.session) return [self configScanner];
    if (self.session.running)  {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
        [dict setObject:@"正在识别中" forKey:@"domain"];
        [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"正在识别中"];
        return [NSError errorWithDomain:@"正在识别中" code:10002 userInfo:nil];
    } else {
        [self.session startRunning];
    }
    return nil;
}

- (void)stopScanner {
    if (!self.session.running) return;
    [self.session stopRunning];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"停止扫码" forKey:@"domain"];
    [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"停止扫码"];
}

#pragma mark private

- (NSError *)configScanner {
    NSError *err = [self statusCheck];
    if (err) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
        [dict setObject:[NSString stringWithFormat:@"%@",err.domain] forKey:@"domain"];
        [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:err.domain];
        return err;
    };
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(dsScannerRectOfInterest)] || ![self.delegate respondsToSelector:@selector(dsScannerRectOfInterest)]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
        [dict setObject:@"未实现代理方法 dsScannerRectOfInterest 或者 dsScannerRectOfInterest 或者 未设置代理" forKey:@"domain"];
        [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"未实现代理"];
        return [NSError errorWithDomain:@"未实现代理" code:10004 userInfo:nil];
    }
    UIView *aView = [self.delegate dsScannerPreviewView];
    CGRect rect = [self.delegate dsScannerRectOfInterest];
    if (!aView || rect.size.width == 0 || rect.size.height == 0 || aView.frame.size.width == 0 || aView.frame.size.height == 0 ) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
        [dict setObject:[NSString stringWithFormat:@"代理返回数据错误 view:%@ rect:%@ viewFrame:%@",aView,NSStringFromCGRect(rect),NSStringFromCGRect(aView.frame)] forKey:@"domain"];
        [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"代理返回数据错误"];
        return [NSError errorWithDomain:@"代理返回数据错误" code:10003 userInfo:nil];
    }
    self.scanRect = rect;

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    if (inputError) return inputError;
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([device supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    } else {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    if ([self.session canAddInput:self.input]) [self.session addInput:self.input];
    if ([self.session canAddOutput:self.output]) [self.session addOutput:self.output];
    
    self.output.metadataObjectTypes = [self achiveMetadataObjectTypes];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(0, 0)];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = aView.bounds;
    [aView.layer insertSublayer:_previewLayer atIndex:0];
    [self.session startRunning];
    self.output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanRect];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"开始扫码" forKey:@"domain"];
    [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"开始扫码"];
    return nil;
}
- (NSArray *)achiveMetadataObjectTypes {
    NSArray *barCodeArr = @[AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    if (self.typeCode == DSScannerTypeQRCode) {
        return @[AVMetadataObjectTypeQRCode];
    } else if (self.typeCode == DSScannerTypeBarCode) {
        return barCodeArr;
    } else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:barCodeArr];
        [arr addObject:AVMetadataObjectTypeQRCode];
        return arr;
    }
}


- (NSError *)statusCheck {
    if (![self isCameraAvailable]) return [NSError errorWithDomain:@"设备无相机——设备无相机功能，无法进行扫描" code:10001 userInfo:nil];
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) return [NSError errorWithDomain:@"设备相机错误——无法启用相机，请检查" code:10001 userInfo:nil];
    return [self isCameraAuthStatusCorrect];
}


#pragma mark - 权限判断

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (NSError *)isCameraAuthStatusCorrect {
    DSMediaStatus authStatus = [DSMediaManger authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == DSMediaStatusNotDetermined) {
        return [NSError errorWithDomain:@"请先申请相机权限" code:10001 userInfo:nil];
    }
    if (authStatus != DSMediaStatusAuthorized) {
        return [NSError errorWithDomain:@"请打开设置->买单吧->打开相机权限。" code:10001 userInfo:nil];
    }
    return nil;
}


#pragma mark delegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[NSString stringWithFormat:@"扫码结束：%@",metadataObjects.firstObject] forKey:@"domain"];
    [DSScanEventLog scanLogWithType:(DSScanEventLogTypeScan) withSubType:self.typeCode withDict:dict withDesc:@"扫码结束"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dsScannerResult:withSuccess:)]) {
        if (metadataObjects.count == 0) {
            [self.delegate dsScannerResult:nil withSuccess:NO];
        } else {
            NSString *result = [metadataObjects.firstObject stringValue];
            [self.delegate dsScannerResult:result withSuccess:YES];
        }
    }
}


@end
