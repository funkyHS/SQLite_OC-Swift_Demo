//
//  HSStudent.h
//  SQLiteTool_OC_Demo
//
//  Created by 胡晟 on 2017/7/4.
//  Copyright © 2017年 胡晟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSModelProtocol.h"

@interface HSStudent : NSObject <HSModelProtocol>
{
    int b;
}
@property (nonatomic, assign) int stuNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) float adress;

@property (nonatomic, strong) NSMutableArray *testArr;
@property (nonatomic, strong) NSDictionary *testDic;


@end
