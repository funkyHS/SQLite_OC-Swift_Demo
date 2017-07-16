//
//  SQLiteTool.swift
//  SQLite_Demo
//
//  Created by 胡晟 on 2017/6/27.
//  Copyright © 2017年 胡晟. All rights reserved.
//

import UIKit

class SQLiteTool: NSObject {

    
    static let shareInstance = SQLiteTool()
    
    var db: OpaquePointer? = nil
    
    override init() {
        super.init()
        
        // 1. 创建一个数据库
        /*
             sqlite3_open：打开一个指定的数据库, 如果数据库不存在就创建,如果存在就直接打开,并且赋值给参数2
             参数1: 数据库路径
             参数2: 一个已经打开的数据库(如果后期要执行sql语句, 都需要借助这个对象)
             关于sqlite 数据库文件的后缀名, 没有要求, 一般常用 sqlite db db3作后缀名
         */
        
        let path = "/Users/Funky/Desktop/sqlite_demo.sqlite"
        
        if  sqlite3_open(path, &db) == SQLITE_OK {
            print("执行成功")
            
            createTable()
            
        }else {
            print("执行失败")
        }
        
    }
    
    
    // 创建表
    func createTable() -> () {
        let sql = "create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real default 60)"
        let result = execute(sql)
        if result {
            print("创建表成功")
        }
        
        
        
    }
    
    // 删除表
    func dropTable() -> () {
        let sql = "drop table if exists t_stu"
        let result = execute(sql)
        if result {
            print("删除表成功")
        }
    }
    
    func execute(_ sql: String) -> Bool {
        // 参数1: 已经打开的数据库
        // 参数2: 需要执行的sql字符串
        // 参数3: 执行回调
        // 参数4: 参数3 参数1
        // 参数5: 错误信息
        return (sqlite3_exec(db, sql, nil , nil, nil) == SQLITE_OK)
        
    }
    
    
    // 问题: 如果使用 sqlite3_exec 或者, sqlite3_step()来执行sql语句, 会自动开启一个"事务", 然后, 自动提交"事务"
    // 方案: 只需要手动开启事务, 手动提交事务, 这时候, 函数内部, 就不会自动开启 和提交事务
    
    
    // 开启事务
    func beginTransaction() -> () {
        let sql = "begin transaction"
        if execute(sql) {
            print("开启事务成功")
        }
    }
    
    // 提交事务
    func commitTransaction() -> () {
        let sql = "commit transaction"
        if execute(sql) {
            print("提交事务成功")
        }
    }
    
    
    
    // 事物回滚
    func rollbackTransaction() -> () {
        let sql = "rollback transaction"
        if execute(sql){
            print("事物回滚成功")
        }
    }
    
}
