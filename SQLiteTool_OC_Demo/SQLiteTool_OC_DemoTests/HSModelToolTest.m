//
//  HSModelToolTest.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSModelTool.h"
#import "HSStudent.h"

@interface HSModelToolTest : XCTestCase

@end

@implementation HSModelToolTest


- (void)testIvarNameType {
    
    NSString *dic = [HSModelTool columnNamesAndTypesStr:[HSStudent class]];
    NSLog(@"%@", dic);
    
    
    NSArray *ivarNames = [HSModelTool allTableSortedIvarNames:[HSStudent class]];
    NSLog(@"%@", ivarNames);
}

-(void)testIvarNameTypeDic {
    NSDictionary *dic = [HSModelTool getModelIvarNameIvarTypeDic:[HSStudent class]];
    NSLog(@"%@", dic);
    
    
    NSDictionary *dic1 = [HSModelTool getModelIvarNameSqlTypeDic:[HSStudent class]];
    NSLog(@"%@", dic1);
    
}


@end
