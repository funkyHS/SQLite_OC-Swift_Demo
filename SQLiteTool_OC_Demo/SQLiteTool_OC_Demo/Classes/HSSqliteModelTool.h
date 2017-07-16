//
//  HSSqliteModelTool.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSModelProtocol.h"

typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,      // >
    ColumnNameToValueRelationTypeLess,      // <
    ColumnNameToValueRelationTypeEqual,     // ==
    ColumnNameToValueRelationTypeMoreEqual, // >=
    ColumnNameToValueRelationTypeLessEqual, // <=
};



@interface HSSqliteModelTool : NSObject

//// 根据模型 动态创建表  cls 类名  uid 用户唯一标识
//+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;
//
//
//// 判断表是否需要更新
//+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;
//
//
//// 更新表
//+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;
//








// 保存或更新模型
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


// 删除模型
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;


// 根据条件来删除  cls->从哪个表里删除  whereStr score <= 10 and age > 19
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;


// 删除 cls表中 属性为name relation（大于，等于，小于...）value 的条目
+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;


// 较复杂的语句时使用
+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid;



+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;
@end
