//
//  SDMajletModel.m
//  DarkStarAwesomeKit
//
//  Created by zhuyuhui on 2023/10/7.
//

#import "SDMajletModel.h"

@implementation SDMajletModel

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
     return @{
               @"ID" : @"id",
//               @"desc" : @"desciption",
//               @"oldName" : @"name.oldName",
//               @"nowName" : @"name.newName",
//               @"nameChangedTime" : @"name.info.nameChangedTime",
//               @"bag" : @"other.bag"
              };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"child":[SDMajletModel class]};
}


@end
