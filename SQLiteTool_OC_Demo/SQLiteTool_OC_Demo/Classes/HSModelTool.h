//
//  HSModelTool.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSModelTool : NSObject

// 根据类名，获取表格名称
+ (NSString *)tableName:(Class)cls;

// 根据类名，获取临时表格名称
+ (NSString *)tmpTableName:(Class)cls;


/**
 所有的有效成员变量, 以及成员变量对应的类型
 
 @param cls 类名
 @return 所有的有效成员变量, 以及成员变量对应的类型 {key: 成员变量名称,取出下划线  value: 类型}
 {
     age = i;
     name = NSString;
     score = f;
     stuNum = i;
     testArr = NSMutableArray;
     testDic = NSDictionary;
 }
 */
+ (NSDictionary *)getModelIvarNameIvarTypeDic:(Class)cls;


/**
 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 
 @param cls 类名
 @return 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 {
     age = integer;
     name = text;
     score = real;
     stuNum = integer;
     testArr = text;
     testDic = text;
 }
 */
+ (NSDictionary *)getModelIvarNameSqlTypeDic:(Class)cls;


/**
 字段名称和sql类型, 拼接的用户创建表格的字符串
 
 @param cls 类名
 @return 字符串 如: age integer,stuNum integer,score real,testArr text,name text,testDic text
 */
+ (NSString *)columnNamesAndTypesStr:(Class)cls;


/**
 排序后的类名对应的成员变量数组, 用于和表格字段进行验证是否需要更新
 
 @param cls 类名
 @return 成员变量数组,( age, name, score, stuNum, testArr, testDic )

 */
+ (NSArray <NSString *>*)allTableSortedIvarNames:(Class)cls;

@end
