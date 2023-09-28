//
//  REUIConfig.h
//  REWLY
//
//  Created by zhuyuhui on 2023/5/24.
//

#ifndef REUIConfig_h
#define REUIConfig_h
///  ==========================   字体
///
#define FONT_REGULAR(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
#define FONT_MEDIUM(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s]
#define FONT_SEMIBOLD(s) [UIFont fontWithName:@"PingFangSC-Semibold" size:s]

///  ==========================   颜色
///
#define APP_MAIN_COLOR    [DSHelper colorWithHexString:@"0xE00514"] // App 主色调  红色
// 各种灰色。
#define Gray00 [DSHelper colorWithHexString:@"0x000000"]  // 全黑。
#define Gray22 [DSHelper colorWithHexString:@"0x222222"]
#define Gray33 [DSHelper colorWithHexString:@"0x333333"]
#define Gray55 [DSHelper colorWithHexString:@"0x555555"]
#define Gray66 [DSHelper colorWithHexString:@"0x666666"]
#define Gray88 [DSHelper colorWithHexString:@"0x888888"]
#define Gray99 [DSHelper colorWithHexString:@"0x999999"]
#define GrayCC [DSHelper colorWithHexString:@"0xCCCCCC"]
#define GrayC9 [DSHelper colorWithHexString:@"0xC9C9C9"]
#define GrayD8 [DSHelper colorWithHexString:@"0xD8D8D8"]
#define GrayDD [DSHelper colorWithHexString:@"0xDDDDDD"]
#define GrayED [DSHelper colorWithHexString:@"0xEDEDED"]
#define GrayEE [DSHelper colorWithHexString:@"0xEEEEEE"]
#define GrayFF [DSHelper colorWithHexString:@"0xFFFFFF"]  // 白色。
#define Gray50 [DSHelper colorWithHexString:@"0xFF5050"]
#define Gray80 [DSHelper colorWithHexString:@"0x808080"]
#define GrayB2 [DSHelper colorWithHexString:@"0xB2B2B2"]
#define GrayB4 [DSHelper colorWithHexString:@"0xB4B4B4"]
#define GrayB7 [DSHelper colorWithHexString:@"0xB7B7B7"]
#define GrayE5 [DSHelper colorWithHexString:@"0xE5E5E5"]
#define GrayE4 [DSHelper colorWithHexString:@"0xE4E4E4"]
#define GrayF0 [DSHelper colorWithHexString:@"0xF0F0F0"]
#define GrayF3 [DSHelper colorWithHexString:@"0xF3F3F3"]
#define GrayF4 [DSHelper colorWithHexString:@"0xF4F4F4"]
#define GrayF5 [DSHelper colorWithHexString:@"0xF5F5F5"]
#define GrayF6 [DSHelper colorWithHexString:@"0xF6F6F6"]
#define GrayF5 [DSHelper colorWithHexString:@"0xF5F5F5"]
#define GrayF8 [DSHelper colorWithHexString:@"0xF8F8F8"]
#define GrayF9 [DSHelper colorWithHexString:@"0xF9F9F9"]
#define GrayFA [DSHelper colorWithHexString:@"0xFAFAFA"]
#define GrayFD [DSHelper colorWithHexString:@"0xFDFDFD"]
#define Gray6C [DSHelper colorWithHexString:@"0X6C6C6C"]
#define Gray26 [DSHelper colorWithHexString:@"0X262626"]
#define Gray46 [DSHelper colorWithHexString:@"0X464646"]
#define Gray2b2b2b [DSHelper colorWithHexString:@"0X2b2b2b"]

#endif /* REUIConfig_h */
