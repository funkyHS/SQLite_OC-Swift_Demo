//
//  HSStudent.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import "HSStudent.h"

@implementation HSStudent

+ (NSString *)primaryKey {
    
    return @"stuNum";
    
}

+ (NSArray *)ignoreColumnNames {
    return @[@"b", @"adress"];
}

//新（age2） --> 旧（age）
//+ (NSDictionary *)newNameToOldNameDic {
//    return @{@"age2" : @"age"};
//}
@end
