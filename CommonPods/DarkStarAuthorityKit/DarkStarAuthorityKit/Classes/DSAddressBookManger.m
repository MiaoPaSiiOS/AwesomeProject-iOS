#import "DSAddressBookManger.h"
#import "DSAuthorityLog.h"



@implementation DSAddressBookManger

+ (DSContactStatus)getAddressBookAuthorizationStatus {
    DSContactStatus status = (DSContactStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:1 withDict:dict withDesc:@"iOS_9以上获取当前通讯录权限状态"];
    return status;
    /*
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        if (@available(iOS 9.0, *)) {
            DSContactStatus status = (DSContactStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];
            [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:1 withDict:dict withDesc:@"iOS_9以上获取当前通讯录权限状态"];
            return status;
        } else {
            return DSContactStatusNotDetermined;
        }
    } else {
        DSContactStatus status = (DSContactStatus)ABAddressBookGetAuthorizationStatus();
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];
        [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:1 withDict:dict withDesc:@"iOS_9以下获取当前通讯录权限状态"];
        return status;
    }
     */
}


+ (void)requestAddressBookAuthorizationCompletion:(nullable void(^)(BOOL granted, NSError * _Nullable error))completionHandler {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(granted) forKey:kDSAuthorityLogRequestStatus];
        if (error) {
            [dict setObject:error.localizedDescription forKey:kDSAuthorityLogError];
        }
        [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:2 withDict:dict withDesc:@"iOS_9以上申请通讯录权限"];
        if (completionHandler) {
            completionHandler(granted, error);
        }
    }];
    /*
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        if (@available(iOS 9.0, *)) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@(granted) forKey:kDSAuthorityLogRequestStatus];
                if (error) {
                    [dict setObject:error.localizedDescription forKey:kDSAuthorityLogError];
                }
                [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:2 withDict:dict withDesc:@"iOS_9以上申请通讯录权限"];
                if (completionHandler) {
                    completionHandler(granted, error);
                }
            }];
        }
    } else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            CFRelease(addressBook);
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(granted) forKey:kDSAuthorityLogRequestStatus];
            NSError *aError = (__bridge NSError * _Nullable)error;
            if (aError) {
                [dict setObject:aError.localizedDescription forKey:kDSAuthorityLogError];
            }
            [DSAuthorityLog authorityLogWithType:DSAuthorityLogAddressBook withSubType:2 withDict:dict withDesc:@"iOS_9以下申请通讯录权限"];
            if (completionHandler) {
                completionHandler(granted, aError);
            }
            
        });
    }
     */
}


@end
