//
//  UIStyleConfig.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/7.
//

#ifndef UIStyleConfig_h
#define UIStyleConfig_h

#pragma mark - 全局定义的宏

//域名配置
#define DEFAULTINTERFACEURLHOST [DSAppConfiguration shareConfiguration].environment.url
#define H5HOST [DSAppConfiguration shareConfiguration].environment.H5Host
#define SCHEME [DSAppConfiguration shareConfiguration].environment.scheme

#define kAppStoreChannel [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.oudianyun.DarkStar"]
#define CFBundleShortVersionString  @"CFBundleShortVersionString"
#define CONSTANT @"prodcf"    //router常量




#endif /* UIStyleConfig_h */
