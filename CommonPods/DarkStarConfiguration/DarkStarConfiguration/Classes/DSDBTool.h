//
//  DSDBTool.h
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDBTool : NSObject
/**初始化数据库*/
+(instancetype)shareDatabase;
/**删除数据库*/
-(void)deleteDaBaseInfo;
//储存首页数据
-(void)saveHomeData:(id)homeData;
//读取首页缓存
- (id)readHomeData;
//缓存搜索历史
- (void)saveSearchKeyWord:(NSString *)keyWord;
//读取搜索历史
- (NSArray *)readSearchKeyWord;
//删除某条搜索历史
- (void)deleteSearchKeyWord:(NSString *)keyWord;
//删除历史记录
- (BOOL)clearSearchHistory;

/**
 *  缓存数据到具体表
 *
 *  @param data  数据(NSArray,NSDictory)
 *  @param table 表名
 */
- (void)saveData:(id)data withTable:(NSString *)table;
/**
 *  从具体表读取全部数据
 *
 *  @param table 表名
 *
 *  @return 数据(NSArray,NSDictory)
 */

- (id)readDataWithTable:(NSString *)table;

/**
 删除某张表

 @param table <#table description#>
 */
- (BOOL)deleteDataWithTable:(NSString *)table;
/**
 *  @author Marshal, 16-08-11 18:08:01
 *
 *  @brief 缓存商品详情
 *
 *  @param product <#product description#>
 *  @param pid <#pid description#>
 */
- (void)cacheProductDetail:(NSDictionary *)product WithPid:(NSString *)pid;
/**
 *  @author Marshal, 16-08-11 18:08:53
 *
 *  @brief 读取商品详情
 *
 *  @param pid <#pid description#>
 *
 */
- (NSDictionary *)getProductDetail:(NSString *)pid;


/**
 键值对形式存储数据库

 @param value <#value description#>
 @param key <#key description#>
 */
- (void)saveValue:(id)value forKey:(NSString *)key;
- (id)readValueForkey:(NSString *)key;
- (void)deleteValueForkey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
