//
//  HSSqliteTool.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import "HSSqliteTool.h"
#import <sqlite3.h>


#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


@implementation HSSqliteTool

sqlite3 *ppDb = nil;

// 处理sql语句, 包括增删改记录, 创建删除表格等等无结果集操作
+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    
    // 1. 打开数据库
    if (![self openDB:uid]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    // 2. 执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    // 3. 关闭数据库
    [self closeDB];
    
    return result;
}

/**
 查询语句, 有结果集返回 
 (
     {
         age = 18;
         name = qq;
         score = 11;
         stuNum = 1;
     },..... )
 
 @param sql sql语句
 @param uid 用户的唯一标识
 @return 字典(一行记录)组成的数组
 */

+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid {
    [self openDB:uid];
    // 准备语句(预处理语句)
    
    // 1. 创建准备语句
    // 参数1: 一个已经打开的数据库
    // 参数2: 需要中的sql
    // 参数3: 参数2取出多少字节的长度 -1 自动计算 \0
    // 参数4: 准备语句
    // 参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        // 释放资源
        sqlite3_finalize(ppStmt);
        [self closeDB];
        return nil;
    }
    
    
    // 2. 执行
    NSMutableArray *rowDicArray = [NSMutableArray array];
    
    // 如果下一行有记录, 就会返回 SQLITE_ROW, 会自动移动指针, 到下一行
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -> 字典
        // 一条记录 , 都会执行这个循环
        // 解析一条记录 (列,  每一列的列名, 每一列的值)
        
        // 1. 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        // 2. 遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            // 2.1 获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 2.2 获取列值
            // 不同列的类型, 使用不同的函数, 进行获取
            // 2.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2 根据列的类型, 使用不同的函数, 进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER: // 整形
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT: // 浮点
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB: // 二进制
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT: // 文本
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            
            [rowDic setValue:value forKey:columnName];
            
        }
    }
    
    
    // 3. 释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDicArray;
}

// 事物 -- 处理多个语句  sqls 中存放多个语句
+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid {
    
    [self openDB:uid];
    
    // 1. 开始事务
    [self beginTransaction];
    
    // 2. 执行事务, 如果有一条执行失败, 则终止执行并执行回滚操作
    for (NSString *sql in sqls) {
        BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
        if (!result) {
            [self rollBackTransaction];
            return NO;
        }
    }
    // 3. 提交事务
    [self commitTransaction];
    
    [self closeDB];
    
    return YES;
}



#pragma mark - 私有方法

// 开始事务
+ (void)beginTransaction {
    sqlite3_exec(ppDb, "begin transaction", nil, nil, nil);
}

// 提交事务
+ (void)commitTransaction {
    sqlite3_exec(ppDb, "commit transaction", nil, nil, nil);
}

// 回滚事务
+ (void)rollBackTransaction {
    sqlite3_exec(ppDb, "rollback transaction", nil, nil, nil);
}

// 打开数据库
+ (BOOL)openDB:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    // 创建&打开一个数据库
    return  sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
    
}

// 关闭数据库
+ (void)closeDB {
    sqlite3_close(ppDb);
}


@end
