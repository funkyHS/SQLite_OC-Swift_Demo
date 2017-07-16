//
//  HSSqliteModelToolTest.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/7.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSSqliteModelTool.h"
#import "HSStudent.h"

@interface HSSqliteModelToolTest : XCTestCase

@end

@implementation HSSqliteModelToolTest

/*
// 测试动态建表
- (void)testCreateTable {
    
    Class cls = NSClassFromString(@"HSStudent");
    BOOL result = [HSSqliteModelTool createTable:cls uid:nil];
    XCTAssertEqual(result, YES);
}

// 测试表格是否需要更新
- (void)testRequiredUpdate {
    
    Class cls = NSClassFromString(@"HSStudent");
    BOOL result = [HSSqliteModelTool isTableRequiredUpdate:cls uid:nil];
    XCTAssertEqual(result, YES);
        
}


// 测试更新表格
- (void)testUpdateTable {
    
    Class cls = NSClassFromString(@"HSStudent");
    BOOL update = [HSSqliteModelTool updateTable:cls uid:nil];
    XCTAssertTrue(update);

}

*/

- (void)testSaveModel {
    
    HSStudent *stu = [[HSStudent alloc] init];
    stu.stuNum = 3;
    stu.age = 19;
    stu.name = @"test3";
    stu.score = 19;
    stu.testArr = [@[@"2",@"3",@"4"] mutableCopy];
    stu.testDic = @{@"xx" : @"13",
                    @"qq" : @"1024673678"};
    
    [HSSqliteModelTool saveOrUpdateModel:stu uid:nil];
    
}
- (void)testDeleteModel {
    
    HSStudent *stu = [[HSStudent alloc] init];
    stu.stuNum = 1;
        
    [HSSqliteModelTool deleteModel:stu uid:nil];
    
}

- (void)testDeleteModelWhere {
    
    [HSSqliteModelTool deleteModel:[HSStudent class] whereStr:@"score <= 60" uid:nil];
    
}

- (void)testDeleteModelWhere2 {
    
    [HSSqliteModelTool deleteModel:[HSStudent class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@"rrrr" uid:nil];
    
}

- (void)testQueryAllModels {
    
//    NSArray *array = [HSSqliteModelTool queryAllModels:[HSStudent class] uid:nil];
//    NSLog(@"%@", array);
    
    NSArray *results = [HSSqliteModelTool queryModels:[HSStudent class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@"test3" uid:nil];
    NSLog(@"%@", results);
    
    
}

@end
