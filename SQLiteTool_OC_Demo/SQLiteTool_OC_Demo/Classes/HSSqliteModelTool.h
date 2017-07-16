//
//  HSSqliteModelTool.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSModelProtocol.h"

typedef NS_ENUM(NSUInteger, HSColumnNameToValueRelationType) {
    HSColumnNameToValueRelationTypeMore,      // >
    HSColumnNameToValueRelationTypeLess,      // <
    HSColumnNameToValueRelationTypeEqual,     // ==
    HSColumnNameToValueRelationTypeMoreEqual, // >=
    HSColumnNameToValueRelationTypeLessEqual, // <=
    HSColumnNameToValueRelationTypeNotEqual,  // !=

};


typedef enum : NSUInteger {
    HSColumnNameToValueLogicNot,  // not
    HSColumnNameToValueLogicAnd,  // and
    HSColumnNameToValueLogicOr,   // or
} HSColumnNameToValueLogic;



@interface HSSqliteModelTool : NSObject



#pragma mark - 创建表格 & 更新表格
// 保存或更新模型
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


#pragma mark - 删除模型

// 删除模型
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

// 根据条件来删除  cls->从哪个表里删除  whereStr score <= 10 and age > 19
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

// 删除 cls表中 属性为name relation（大于，等于，小于...）value 的条目
+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(HSColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (BOOL)deleteModel:(Class)cls columnNames: (NSArray *)columnNames relations: (NSArray *)relations values: (NSArray *)values logics: (NSArray *)logics uid: (NSString *)uid;

// 较复杂的语句时使用
+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid;


#pragma mark - 查询模型

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(HSColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls columnNames: (NSArray *)columnNames relations: (NSArray *)relations values: (NSArray *)values logics: (NSArray *)logics uid: (NSString *)uid;
+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;
@end
