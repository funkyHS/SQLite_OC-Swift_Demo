//
//  HSSqliteToolTest.m
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSSqliteTool.h"

@interface HSSqliteToolTest : XCTestCase

@end

@implementation HSSqliteToolTest


// 执行语句
- (void)testExample {
    
    // 1. 测试执行语句
    /*
        NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
        BOOL result = [HSSqliteTool deal:sql uid:nil];
        XCTAssertEqual(result, YES);
    */
    
    
}


- (void)testQuery {
    
    NSString *sql = @"select * from HSStudent";
    NSMutableArray *result = [HSSqliteTool querySql:sql uid:nil];
    
    NSLog(@"%@", result);
    
    /*
     
     (
         {
             age = 18;
             name = qq;
             score = 11;
             stuNum = 1;
         },
     
         {
             age = 19;
             name = ww;
             score = 20;
             stuNum = 2;
         }
     )

     */
    
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
