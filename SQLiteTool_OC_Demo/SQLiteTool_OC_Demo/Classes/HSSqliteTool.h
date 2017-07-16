//
//  HSSqliteTool.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSqliteTool : NSObject


// 用户机制，如果 uid 传 nil，则操作common.db  如果 uid 传 funky，则操作 funky.db
/**
 处理sql语句, 包括增删改记录, 创建删除表格等等无结果集操作
 
 @param sql sql语句
 @param uid 用户的唯一标识
 @return 是否处理成功
 */

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;


/**
 查询语句, 有结果集返回
 
 @param sql sql语句
 @param uid 用户的唯一标识
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid;


/**
 同时处理多条语句, 并使用事务进行包装
 
 @param sqls sql语句数组
 @param uid 用户的唯一标识
 @return 是否全部处理成功; 注意, 如果有一条没有成功, 则会进行回滚操作
 */
+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid;

@end
