//
//  Student.swift
//  SQLite_Demo
//
//  Created by 胡晟 on 2017/6/27.
//  Copyright © 2017年 胡晟. All rights reserved.
//

import UIKit

class Student: NSObject {

    
    var name: String = ""
    var age: Int = 0
    var score: Float = 0.0
    
    
    init(name: String, age: Int, score: Float) {
        super.init()
        self.name = name
        self.age = age
        self.score = score
    }
    
    
    // 1. 插入数据
    func insertStudent() -> () {
        
        let sql = "insert into t_stu(name, age, score) values ('\(name)', \(age), \(score))"
        
        if  SQLiteTool.shareInstance.execute(sql)  {
            print("插入成功")
        }
    }

    
    // 2. 删除 name 为XXX的数据
    class func deleteStu(name: String) -> () {
        let sql = "delete from t_stu where name = '\(name)'"
        
        if  SQLiteTool.shareInstance.execute(sql)  {
            print("删除成功")
        }
    }
    
    
    // 3. 修改数据内容
    func updateStudent(newStu: Student) -> () {
        
        let sql = "update t_stu set name = '\(newStu.name)', age = \(newStu.age), score = \(newStu.score) where name = '\(name)'"
        
        print(sql)
        
        if  SQLiteTool.shareInstance.execute(sql)  {
            print("修改成功")
        }else {
            print("修改失败")
        }
        
    }

    
    // 4. 绑定插入数据
    func bindInsert() -> () {
        
        // 根据sql字符串, 创建准备语句
        // 参数1: 一个已经打开的数据库
        // 参数2: sql 字符串 "123234324"
        // 参数3: 取出字符串的长度 "2"  -1 : 代表自动计算
        // 参数4: 预处理语句
        // 参数5: 根据参数3的长度, 取出参数2的值以后, 剩余的参数
        //sqlite3_prepare_v2(<#T##db: OpaquePointer!##OpaquePointer!#>, <#T##zSql: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##nByte: Int32##Int32#>, <#T##ppStmt: UnsafeMutablePointer<OpaquePointer?>!##UnsafeMutablePointer<OpaquePointer?>!#>, <#T##pzTail: UnsafeMutablePointer<UnsafePointer<Int8>?>!##UnsafeMutablePointer<UnsafePointer<Int8>?>!#>)
        
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        let db = SQLiteTool.shareInstance.db
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预处理失败")
            return
        }
        
        
        // 2. 绑定参数
        // 参数1: 准备语句
        // 参数2: 绑定值的索引 索引从1
        // 惨数3: 需要绑定的值
        sqlite3_bind_int(stmt, 2, 20)
        sqlite3_bind_double(stmt, 3, 59.9)
        
        // 绑定文本(姓名)
        // 参数1: 准备语句
        // 参数2: 绑定的索引 1
        // 参数3: 绑定的值 "123"
        // 参数4: 值取出多少长度 -1 , 取出所有
        // 参数5: 值的处理方式
        // SQLITE_STATIC : 人为参数是一个常量, 不会被释放, 处理方案: 不做任何的引用
        // SQLITE_TRANSIENT: 会对参数, 进行一个引用
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        sqlite3_bind_text(stmt, 1, "zhangsan2", -1, SQLITE_TRANSIENT)
        
        
        // 3. 执行sql语句, 准备语句
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("执行成功")
        }
        
        // 4. 重置语句
        sqlite3_reset(stmt)
        
        
        
        // 5. 释放准备语句
        sqlite3_finalize(stmt)
        
        
        
    }
    
    
    // 问题: 如果使用 sqlite3_exec 或者, sqlite3_step()来执行sql语句, 会自动开启一个"事务", 然后, 自动提交"事务"
    // 方案: 只需要手动开启事务, 手动提交事务, 这时候, 函数内部, 就不会自动开启 和提交事务
    
    
    // 5. 优化绑定插入数据（插入大批量数据）
    func fastBindInsert() -> () {
        
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        let db = SQLiteTool.shareInstance.db
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预处理失败")
            return
        }
        
        // 手动开启事务
        SQLiteTool.shareInstance.beginTransaction()
        
        for i in 0..<100000 {
            
            let value = Int32(i)
            sqlite3_bind_int(stmt, 2, value)
            sqlite3_bind_double(stmt, 3, 59.9)
            
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_text(stmt, 1, "zhangsan2", -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                // print("执行成功")
            }
            
            sqlite3_reset(stmt)
            
        }
        
        // 提交事务
        SQLiteTool.shareInstance.commitTransaction()
        
        sqlite3_finalize(stmt)
        
        
        
    }
    
    
    
    class func update(sql: String) -> Bool {
        return SQLiteTool.shareInstance.execute(sql)
    }

    
    
    
    // 6. 查询所有，方案1
    class func queryAll() -> () {
        let sql = "select * from t_stu"
        
        let db = SQLiteTool.shareInstance.db
        
        // 参数1: 一个打开的数据库
        // 参数2: sql语句
        // 参数3: 回调代码块
            // 参数1 传递过来的值
            // 参数2 列的个数
            // 参数3 值的数组
            // 参数4: 列名称的数组
        // 返回值: 0, 继续查询 1: 终止查询
        // 参数4: 传递到参数3里面的第一个参数
        // 参数5: 错误信息
        // char *
        let result = sqlite3_exec(db, sql, { (
            firstValue, columnCount, values , columnNames ) -> Int32 in
            
            let count = Int(columnCount)
            for i in 0..<count {
                // 列的名称
                let columnName = columnNames?[i]
                let columnNameStr = String(cString: columnName!, encoding: String.Encoding.utf8)
                // 值
                let value = values?[i]
                let valueStr = String(cString: value!, encoding: String.Encoding.utf8)
                
                print(columnNameStr ?? "", valueStr ?? "")
                
            }
            
            return 0
            
        }, nil, nil)
        
        //        print(result)
        if result == SQLITE_ABORT {
            print("查询成功")
        }else {
            print("查询失败")
        }
        
        
    }
    
    // 7. 查询所有，方案2
    class func queryAllOther() {
        
        // 准备语句 历程
        let sql = "select * from t_stu;"
        // 1. 创建 "准备语句"
        // 参数1: 打开的数据库
        // 参数2: sql字符串
        // 参数3: 字符串, 取的长度 -1代表, 去所有的
        // 参数4: 准备语句的指针
        // 参数5: 剩余的sql字符串
        let db = SQLiteTool.shareInstance.db
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预处理失败")
            return
        }
        
        // 2. 绑定参数(这一步可以省略)
        
        // 3. 执行"准备语句"
        // sqlite3_step . 作用, 执行DQL, 语句时, 会把, 执行得到的结果, 放到"准备语句"stmt里面
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            // 读取结果
            // 从准备语句里面进行读取
            // 1. 计算预处理语句里面得到的结果是多少列
            let count = sqlite3_column_count(stmt)
            for i in 0..<count {
                
                // 2. 取出列的名称
                let columnName = sqlite3_column_name(stmt, i)
                let columnNameStr = String(cString: columnName!, encoding: String.Encoding.utf8)
                
                print(columnNameStr ?? "")
                // 3. 取出列的值
                // 不同的数字类型, 是通过不同的函数进行获取
                // 3.1 获取这一列的类型
                let type = sqlite3_column_type(stmt, i)
                // 3.2. 根据不同的类型, 使用不同的函数, 获取结果
                if type == SQLITE_INTEGER {
                    let value = sqlite3_column_int(stmt, i)
                    print(value)
                }
                if type == SQLITE_FLOAT {
                    let value = sqlite3_column_double(stmt, i)
                    print(value)
                }
                if type == SQLITE_TEXT {

                    let valueStr = String(cString: sqlite3_column_text(stmt, i))
                    print(valueStr)
                    
                }
                
            }
            
            
        }
        
        // 4. 重置"准备语句"(这一步可以省略)
        
        // 5. 释放"准备语句"
        sqlite3_finalize(stmt)
        
        
    }

    
    
    
    
    
}
