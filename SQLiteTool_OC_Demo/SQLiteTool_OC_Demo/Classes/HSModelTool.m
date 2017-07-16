//
//  HSModelTool.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import "HSModelTool.h"
#import <objc/runtime.h>
#import "HSModelProtocol.h"

@implementation HSModelTool

+ (NSString *)tableName:(Class)cls {
    return [NSStringFromClass(cls) lowercaseString];
}
+ (NSString *)tmpTableName:(Class)cls {
    return [[NSStringFromClass(cls) lowercaseString] stringByAppendingString:@"_tmp"];
}


// 有效的成员变量名称, 以及, 对应的类型
+ (NSDictionary *)getModelIvarNameIvarTypeDic:(Class)cls {
    
    // 获取这个类里面, 所有的成员变量以及类型
    
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    
    NSArray *ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
        ignoreNames = [cls ignoreColumnNames];
    }
    
    
    
    for (int i = 0; i < outCount; i++) {
        
        Ivar ivar = varList[i];
        
        // 1. 获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String: ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        
        if([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        // 2. 获取成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [nameTypeDic setValue:type forKey:ivarName];
    }
    
    return nameTypeDic;
    
}



// 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
+ (NSDictionary *)getModelIvarNameSqlTypeDic:(Class)cls {
    
    NSMutableDictionary *dic = [[self getModelIvarNameIvarTypeDic:cls] mutableCopy];
    
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dic[key] = typeDic[obj];
    }];
    
    return dic;
    
}



// 拼接成SQLite所需语句 (age integer,b integer,....）
+ (NSString *)columnNamesAndTypesStr:(Class)cls {
    
    NSDictionary *nameTypeDic = [self getModelIvarNameSqlTypeDic:cls];
    //    {
    //        age = integer;
    //        b = integer;
    //        name = text;
    //        score = real;
    //        stuNum = integer;
    //    }
    
    //    age integer,b integer
    
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    // componentsJoinedByString 按照某个字符串 进行拼接
    return [result componentsJoinedByString:@","];
    
}



//获取这个类里面 所有的字段组成的数组
+ (NSArray *)allTableSortedIvarNames:(Class)cls {
    
    return [[self getModelIvarNameIvarTypeDic:cls] allKeys];
    
    // ( age, name, score, stuNum )
}



#pragma mark - 私有的方法
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}



@end
