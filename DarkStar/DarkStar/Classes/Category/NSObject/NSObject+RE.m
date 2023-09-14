//
//  NSObject+REm
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 RE. All rights reserved.
//

#import "NSObject+RE.h"
#import "NSDictionary+RE.h"
@implementation NSObject (RE)

- (NSNumber *)toNumberIfNeeded
{
    if ([self isKindOfClass:[NSNumber class]])
    {
        return (NSNumber *)self;
    }
    
    if ([self isKindOfClass:[NSString class]])
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *myNumber = [f numberFromString:(NSString *)self];
        return myNumber;
    }
    
    return nil;
}

- (NSString *)toString
{
    if ([self isKindOfClass:[NSString class]])
    {
        return (NSString *)self;
    }
    
    if ([self isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber *)self;
        if ([number compare:[NSNumber numberWithBool:NO]] == NSOrderedSame)
        {
            return @"0";
        }
        else if ([number compare:[NSNumber numberWithBool:YES]] ==
                 NSOrderedSame)
        {
            return @"1";
        }
        
        return [number description];
    }
    
    if ([self isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if ([self respondsToSelector:@selector(description)])
    {
        id tmpValue = [self description];
        if ([tmpValue isKindOfClass:[NSString class]])
        {
            return tmpValue;
        }
    }
    
    return @"";
}

- (NSArray *)toArray
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return (NSArray *)self;
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)self;
        if ([dict hasKey:@"items"])
        {
            return [dict getArray:@"items"];
        }
    }
    
    return [NSArray array];
}



#pragma mark -----  block  操作 --------

- (NSException *)tryCatch:(void (^)(void))block
{
    NSException *result = nil;
    
    @try
    {
        block();
    }
    @catch (NSException *e)
    {
        result = e;
    }
    
    return result;
}

- (NSException *)tryCatch:(void (^)(void))block finally:(void (^)(void))aFinisheBlock
{
    NSException *result = nil;
    
    @try
    {
        block();
    }
    @catch (NSException *e)
    {
        result = e;
    }
    @finally
    {
        aFinisheBlock();
    }
    
    return result;
}

- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
        
    });
}

- (void)performInThreadBlock:(void (^)(void))aInThreadBlock
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       aInThreadBlock();
                       
                   });
}

- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock
                     afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        aInMainBlock();
        
    });
}

- (void)performInThreadBlock:(void (^)(void))aInThreadBlock
                 afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(
                   popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
                       
                       aInThreadBlock();
                       
                   });
}

#pragma mark -----  notification -------
- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleNotification:)
     name:name
     object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name
{
    [self postNotification:name withObject:nil userInfo:nil];
}

- (void)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [self postNotification:name withObject:object userInfo:nil];
}

- (void)postNotification:(NSString *)name
              withObject:(NSObject *)object
                userInfo:(NSDictionary *)info
{
    [self performInMainThreadBlock:^{
        @try
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                                object:object
                                                              userInfo:info];
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
    }];
}

#pragma mark ------  runtime  操作 ----------

static char associatedObjectNamesKey;

- (void)setAssociatedObjectNames:(NSMutableArray *)associatedObjectNames
{
    objc_setAssociatedObject(self, &associatedObjectNamesKey,
                             associatedObjectNames,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)associatedObjectNames
{
    NSMutableArray *array =
    objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array)
    {
        array = [NSMutableArray array];
        [self setAssociatedObjectNames:array];
    }
    return array;
}

- (void)objc_setAssociatedObject:(NSString *)propertyName
                           value:(id)value
                          policy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, (__bridge void *)(propertyName), value,
                             policy);
    [self.associatedObjectNames addObject:propertyName];
}

- (id)objc_getAssociatedObject:(NSString *)propertyName
{
    return objc_getAssociatedObject(self, (__bridge void *)(propertyName));
}

- (void)objc_removeAssociatedObjects
{
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (void)setNilValueForKey:(NSString *)key
{
}

#pragma mark ------  生成二维码 ----------

/**
 *  生成二维码
 *
 *  param   string      将要转成二维码的字段
 *  param   scale       二维码清晰度
 */
+ (UIImage *)barImageWithString:(NSString*)string scale:(CGFloat)scale
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.0
                                   orientation:UIImageOrientationUp];
    
    UIImage *resized =nil;
    CGFloat width = image.size.width*scale;
    CGFloat height = image.size.height*scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context1 =UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context1,kCGInterpolationNone);
    [image drawInRect:CGRectMake(0,0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return resized;
}

+ (CAShapeLayer *)configRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

+ (dispatch_source_t)queryGCDWithTimeout:(NSInteger)Timeout
              handleChangeCountdownBlock:(void (^)(NSInteger timeout))handleChangeCountdownBlock
                handleStopCountdownBlock:(void (^)(void))handleStopCountdownBlock
{
    __block NSInteger timeout = Timeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (handleStopCountdownBlock)
                {
                    handleStopCountdownBlock();
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (handleChangeCountdownBlock)
                {
                    handleChangeCountdownBlock(timeout);
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}
@end

