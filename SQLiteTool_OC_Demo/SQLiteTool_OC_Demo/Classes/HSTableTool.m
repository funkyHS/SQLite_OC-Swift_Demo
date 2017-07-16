//
//  HSTableTool.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/5.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import "HSTableTool.h"
#import "HSModelTool.h"
#import "HSSqliteTool.h"


@implementation HSTableTool

// 取出排序好的表的字段 cls 是确定表的。uid 是确定数据库的
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid {
    
    // 1. 根据类名 获取表名
    NSString *tableName = [HSModelTool tableName:cls];
    
    // 2. 取出表的字段名称
    // sqlite_master 这个表是专门管理和记录其他表的。select * from sqlite_master 可以查询到很多表的表名，以及创建表的sql语句
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableDictionary *dic = [HSSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    // CREATE TABLE HSStudent(age integer,stuNum integer,score real,name text, primary key(stuNum))
    //NSString *createTableSql = [dic[@"sql"] lowercaseString]; 转成小写字母
    NSString *createTableSql = dic[@"sql"];
    if (createTableSql.length == 0) {
        return nil;
    }
    
    // 3. 过滤 \ 及 "
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    

    // 4. 取出主要字段  age integer,stuNum integer,score real,name text, primary key
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        
        if ([nameType containsString:@"primary"]||[nameType containsString:@"PRIMARY"]) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        
        // age integer
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [names addObject:name];
        
        
    }
    
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    // ( age, name, score, stuNum )
    return names;
}



+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [HSModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    NSMutableArray *result = [HSSqliteTool querySql:queryCreateSqlStr uid:uid];
    
    return result.count > 0;
}

@end
