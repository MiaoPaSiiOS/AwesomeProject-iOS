//
//  DSDBTool.m
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import "DSDBTool.h"
#import "FMDB.h"
#import "MJExtension.h"

static FMDatabaseQueue *_queue;
static DSDBTool *_shareDatabase = nil;
#define kDSDBFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"REDataBase.sqlite"]


@implementation DSDBTool
/**
 *  初始化数据库
 */

+ (instancetype)shareDatabase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"---------\n%@\n------",kDSDBFile);
        _queue = [FMDatabaseQueue databaseQueueWithPath:kDSDBFile];
        _shareDatabase = [[self alloc] init];
    });
    
    return _shareDatabase;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareDatabase = [super allocWithZone:zone];
        
    });
    
    return _shareDatabase;
}
/**
 *  删除数据库
 */
- (void)deleteDaBaseInfo
{
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:kDSDBFile])
    {
        [fileManager removeItemAtPath:kDSDBFile error:nil];
    }
}
/**
 *  向数据库中插入或更新首页数据
 *
 */
- (void)saveHomeData:(id)homeData;
{

    [self saveData:homeData withTable:@"HomeData"];
}
- (id)readHomeData{

    return  [self readDataWithTable:@"HomeData"];
}

#pragma mark - saveData

- (void)saveData:(id)data withTable:(NSString *)table{
    if (data == nil || !table.length) {
        return;
    }
    NSData *dat = [self toDataWithObj:data];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(content blob)",table];
//    BOOL success = [__db executeUpdate:createTableSql];
//    if (success) {
        [_queue inDatabase:^(FMDatabase *db) {
            BOOL success = [db executeUpdate:createTableSql];
            if (success){
                [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",table]];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (content)VALUES(?)",table];
                [db executeUpdate:sql,dat];
            }
        }];
//    }
}
#pragma mark - readData
- (id)readDataWithTable:(NSString *)table{
    if (!table.length) return nil;
    
    __block NSData *content;
    [_queue inDatabase:^(FMDatabase *db) {
        if ([db tableExists:table]){
            FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",table]];
            while ([set next])
            {
                content = [set dataForColumn:@"content"];
            }
            [set close];
        }
        
    }];
    return [self toArrayOrNSDictionaryFromData:content];
}
#pragma mark - 删除表
- (BOOL)deleteDataWithTable:(NSString *)table{
    __block BOOL deleteSuccess = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        deleteSuccess = [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",table]];
    }];
    return deleteSuccess;
}

- (void)saveSearchKeyWord:(NSString *)keyWord{
    if (keyWord == nil) return;
    NSString *createSearchKeyWordTableSql = @"create table if not exists SearchKeyWord(id INTEGER PRIMARY KEY AUTOINCREMENT,keyWords text)";
//    if (success) {
        [_queue inDatabase:^(FMDatabase *db) {
            BOOL success = [db executeUpdate:createSearchKeyWordTableSql];
            if (!success) return ;
            
            FMResultSet *set = [db executeQuery:@"SELECT * FROM SearchKeyWord"];
            while ([set next])
            {
                NSString *key_Word = [set stringForColumn:@"keyWords"];
                if ([key_Word isEqualToString:keyWord]){
                    [db executeUpdate:@"DELETE FROM SearchKeyWord WHERE keyWords = ?",keyWord];
                    [db executeUpdate:@"INSERT INTO SearchKeyWord (keyWords)VALUES(?)",keyWord];
                    [set close];
                    return;
                };
            }
            [set close];
            [db executeUpdate:@"INSERT INTO SearchKeyWord (keyWords)VALUES(?)",keyWord];
            
        }];
//    }
}
- (NSArray *)readSearchKeyWord{
    NSMutableArray *arr = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        if ([db tableExists:@"SearchKeyWord"]) {
            FMResultSet *set = [db executeQuery:@"SELECT * FROM SearchKeyWord order by id desc "];
            while ([set next])
            {
                NSString *keyWord = [set stringForColumn:@"keyWords"];
                [arr addObject:keyWord];
            }
            [set close];
        }
    }];
    return arr;
}
- (void)deleteSearchKeyWord:(NSString *)keyWord{
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM SearchKeyWord"];
        while ([set next])
        {
            NSString *key_Word = [set stringForColumn:@"keyWords"];
            if ([key_Word isEqualToString:keyWord]){
                [db executeUpdate:@"DELETE FROM SearchKeyWord WHERE keyWords = ?",keyWord];
                [set close];
                return;
            };
        }
        
    }];
}
- (BOOL)clearSearchHistory{
   __block BOOL deleteSuccess = NO;
    [_queue inDatabase:^(FMDatabase *db) {
         deleteSuccess = [db executeUpdate:@"DROP TABLE IF EXISTS SearchKeyWord"];
    }];
    return deleteSuccess;
}
- (void)cacheProductDetail:(NSDictionary *)product WithPid:(NSString *)pid{
    if (pid == nil || ![product isKindOfClass:[NSDictionary class]]) return;
    
    NSData *productData = product.mj_JSONData;
    
    NSString *createTableSql = @"create table if not exists ProductList(id INTEGER PRIMARY KEY AUTOINCREMENT,p_id text,product blob)";
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:createTableSql];
        if (!success) return ;
        
        FMResultSet *set = [db executeQuery:@"SELECT * FROM ProductList WHERE p_id = ?",pid];
        if ([set next]) {//存在,更新
            
            [db executeUpdate:@"UPDATE ProductList SET product = ? WHERE p_id = ?",productData,pid];
            
        }else{//不存在,插入
            
            [db executeUpdate:@"INSERT INTO ProductList (product,p_id)VALUES(?,?)",productData,pid];
        }
        [set close];
    }];
}
- (NSDictionary *)getProductDetail:(NSString *)pid{
    __block NSDictionary *dict = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        if ([db tableExists:@"ProductList"]) {
            FMResultSet *set = [db executeQuery:@"SELECT * FROM ProductList WHERE p_id = ?",pid];
            while ([set next])
            {
                NSData  *pdata = [set dataForColumn:@"product"];
                dict = pdata.mj_JSONObject;
            }
            [set close];
        }
    }];
    return dict;
}
- (id)readValueForkey:(NSString *)key{
    __block id object = nil;
    __weak __typeof(self)weakSelf = self;
    [_queue inDatabase:^(FMDatabase *db) {
        if ([db tableExists:@"APPInfoPlist"]) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            FMResultSet *set = [db executeQuery:@"SELECT * FROM APPInfoPlist WHERE k_str = ?",key];
            while ([set next])
            {
                NSData  *pdata = [set dataForColumn:@"infoData"];
                object = [strongSelf toArrayOrNSDictionaryFromData:pdata];
            }
            [set close];
        }
    }];
    return object;
}
- (void)saveValue:(id)value forKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]] && value != nil, @"不能设置空键对哦");
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists APPInfoPlist(id INTEGER PRIMARY KEY AUTOINCREMENT,k_str text,infoData blob)"];
    NSData *infoData = [self toDataWithObj:value];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:createTableSql];
        if (!success) return ;
        FMResultSet *set = [db executeQuery:@"SELECT * FROM APPInfoPlist WHERE k_str = ?",key];
        if ([set next]) {//存在,更新
            [db executeUpdate:@"UPDATE APPInfoPlist SET infoData = ? WHERE k_str = ?",infoData,key];
            
        }else{//不存在,插入
            [db executeUpdate:@"INSERT INTO APPInfoPlist (infoData,k_str)VALUES(?,?)",infoData,key];
        }
        [set close];
    }];
}
- (void)deleteValueForkey:(NSString *)key{
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM APPInfoPlist"];
        while ([set next])
        {
            NSString *k_str = [set stringForColumn:@"k_str"];
            if ([k_str isEqualToString:key]){
                [db executeUpdate:@"DELETE FROM APPInfoPlist WHERE k_str = ?",key];
                [set close];
                return;
            };
        }
        
    }];
}
#pragma mark - public
/**
 *  字典或者数组转data
 *
 *
 */
- (NSData *)toDataWithObj:(id)object{
    if (!object) return nil;
    if ([object isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([object isKindOfClass:[NSData class]]) {
        return object;
    }
    NSError *error = nil;
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
}
/**
 *  data转字典或数组
 *
 *
 */
- (id)toArrayOrNSDictionaryFromData:(NSData *)data{
    if (data == nil) return nil;
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
}

@end
