//
//  DSDetectorQRImage.m
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSDetectorQRImage.h"
#import "DSScanEventLog.h"
#import <ZBarSDK/ZBarSDK.h>

@implementation DSDetectorQRImage

+ (void)detectorImage:(UIImage *)image withHandle:(NrDetectorImageHandle)handle {
    if (!image) {
        if (handle) {
            handle(@"");
        } else {
            return;
        }
    }
    ZBarReaderController *zbarReader =[[ZBarReaderController alloc] init];
    id<NSFastEnumeration> results  =[zbarReader scanImage: image.CGImage];
    ZBarSymbol *symbol = nil;
    NSString *stringValue;
    for(symbol in results) {
        //二维码字符串
         stringValue = symbol.data;
        //处理汉字乱码
        if([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]){
            stringValue=[NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        break;
    }
    if (handle) {
        handle(stringValue ?: @"");
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[NSString stringWithFormat:@"识别结束：%@",stringValue] forKey:@"domain"];
    [DSScanEventLog scanLogWithType:(DSScanEventLogTypeDetector) withSubType:0 withDict:dict withDesc:@"识别结束"];
}
@end
