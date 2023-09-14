
#import "HJKeychain.h"
#import "KeychainItemWrapper.h"

//FIXME:define your app keyidentity
#define HJ_KEYCHAIN_IDENTITY @"HJ"

#define HJ_KEYCHAIN_GROUP @""

#define HJ_KEYCHAIN_DICT_ENCODE_KEY_VALUE @"HJ_KEYCHAIN_DICT_ENCODE_KEY_VALUE"

@interface HJKeychain ()
@property (nonatomic, strong) KeychainItemWrapper *HJItem;
@property (nonatomic, strong) NSArray *commonClasses;

@end

@implementation HJKeychain
//DEF_SINGLETON(HJKeychain);
+ (instancetype)shareInstance
{
    static HJKeychain *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HJKeychain alloc] init];
    });
    
    return helper;
}
- (id)init
{
    if (self = [super init]) {
        self.commonClasses = @[[NSNumber class],
                               [NSString class],
                               [NSMutableString class],
                               [NSData class],
                               [NSMutableData class],
                               [NSDate class],
                               [NSValue class]];
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:HJ_KEYCHAIN_IDENTITY accessGroup:nil];
    self.HJItem = wrapper;
}

+ (void)setKeychainValue:(id<NSCopying, NSObject>)value forType:(NSString *)type
{
    HJKeychain *keychain = [HJKeychain shareInstance];
    
    __block BOOL find = NO;
    [keychain.commonClasses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = obj;
        if ([value isKindOfClass:class]) {
            find = YES;
            *stop = YES;
        }
        
    }];
    
    if (!find && value) {
//        HJLogE(@"error set keychain type [%@], value [%@]",type ,value);
        return ;
    }
    
    if (!type || !keychain.HJItem) {
        return ;
    }
    
    id data = [keychain.HJItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[type] = value;
    data = [keychain encodeDict:dict];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.HJItem setObject:HJ_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.HJItem setObject:data forKey:(__bridge id)kSecValueData];
    }
}

+ (id)getKeychainValueForType:(NSString *)type
{
    HJKeychain *keychain = [HJKeychain shareInstance];
    if (!type || !keychain.HJItem) {
        return nil;
    }
    
    id data = [keychain.HJItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    return dict[type];
}

+ (void)reset
{
    HJKeychain *keychain = [HJKeychain shareInstance];
    if (!keychain.HJItem) {
        return ;
    }
    
    id data = [keychain encodeDict:[NSMutableDictionary dictionary]];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.HJItem setObject:HJ_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.HJItem setObject:data forKey:(__bridge id)kSecValueData];
    }
}

- (NSMutableData *)encodeDict:(NSMutableDictionary *)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:HJ_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
    [archiver finishEncoding];
    return data;
}

- (NSMutableDictionary *)decodeDictWithData:(NSMutableData *)data
{
    NSMutableDictionary *dict = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if ([unarchiver containsValueForKey:HJ_KEYCHAIN_DICT_ENCODE_KEY_VALUE]) {
        @try {
            dict = [unarchiver decodeObjectForKey:HJ_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
        }
        @catch (NSException *exception) {
//            HJLogE(@"keychain 解析错误");
            [HJKeychain reset];
        }
    }
    [unarchiver finishDecoding];
    
    return dict;
}

@end
