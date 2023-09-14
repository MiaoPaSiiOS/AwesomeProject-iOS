//
//  UIDevice+IdentifierAddition.m
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "HJKeychain.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define KeyDeviceCode @"KeychainKeyDeviceCode"

@implementation UIDevice (IdentifierAddition)
////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *)macaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    return outstring;
}

- (NSString *)uniqueDeviceIdentifier
{
    NSString *code = nil;
    NSString *keyChainDeviceCode = [HJKeychain getKeychainValueForType:KeyDeviceCode];
    // 若keychain里面没有或者长度因为什么原因很短的话，重新获取一次再储存
    if (keyChainDeviceCode == nil || keyChainDeviceCode.length < 10)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            code = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        else
        {
            code = [self macaddress];
        }

        code = [code stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        [HJKeychain setKeychainValue:code forType:KeyDeviceCode];
    }
    else
    {
        code = keyChainDeviceCode;
    }

    return code;
}

@end
