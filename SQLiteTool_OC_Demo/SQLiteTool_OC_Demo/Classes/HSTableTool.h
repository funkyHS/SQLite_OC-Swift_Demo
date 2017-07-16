//
//  HSTableTool.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/5.
//  Copyright © 2017年 胡晟. All rights reserved.
// 用来解析表格

#import <Foundation/Foundation.h>

@interface HSTableTool : NSObject

// 取出排序好的表的字段 cls 是确定表的。uid 是确定数据库的
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;

// 判断表 是否存在
+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;


@end
