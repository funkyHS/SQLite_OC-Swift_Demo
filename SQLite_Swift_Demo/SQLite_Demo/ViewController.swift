//
//  ViewController.swift
//  SQLite_Demo
//
//  Created by 胡晟 on 2017/6/27.
//  Copyright © 2017年 胡晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // ----- DDL语句 -----
        
        // 创建表
        // SQLiteTool.shareInstance.createTable()
        
        // 删除表
        // SQLiteTool.shareInstance.dropTable()
        
        
        
        // ----- DML语句 -----

        //let stu1 = Student(name: "funky", age: 18, score: 100)
        
        // 插入数据
        //stu1.insertStudent()
        
        // 删除 name 为funky的数据
        //Student.deleteStu(name: "funky")
        
        // 修改数据
        //let stu2 = Student(name: "Bob", age: 28, score: 10)
        //stu1.updateStudent(newStu: stu2)
        
        // 绑定插入数据
        //stu1.bindInsert()
        
        // 绑定插入大批量数据优化（手动开启‘事物’）
        //stu1.fastBindInsert()
        
        
        
        
        /*
         
         --> 事务（Transaction）是并发控制的单位，是用户定义的一个操作序列。这些操作要么都做，要么都不做，是一个不可分割的工作单位。通过事务，可以将逻辑相关的一组操作绑定在一起，保持数据的完整性。
         
         --> 事务通常是以BEGIN TRANSACTION开始，以COMMIT TRANSACTION或ROLLBACK TRANSACTION结束。
                COMMIT表示提交，即提交事务的所有操作。具体地说就是将事务中所有对数据库的更新写回到磁盘上的物理数据库中去，事务正常结束。
                ROLLBACK表示回滚，即在事务运行的过程中发生了某种故障，事务不能继续进行，系统将事务中对数据库的所有以完成的操作全部撤消，滚回到事务开始的状态。
         
         */
        
        /*
        SQLiteTool.shareInstance.beginTransaction()
        
        // 张三-10
        let result1 = Student.update(sql: "update t_stu set money = money - 10 where name = 'zhangsan'")
        
        // 李四 + 10
        let result2 = Student.update(sql: "update t_stu set money = money + 10 where name = 'lisi'")
        
        if result1 && result2 {
            SQLiteTool.shareInstance.commitTransaction()
        }else {
            SQLiteTool.shareInstance.rollbackTransaction()
        }
        
        */
        
        
        
        // ----- DQL语句 -----

        // 查询所有,方案1
        // 作用: 可以通过回调来获取结果, 步骤相对来说简单, 结果数据类型没有特定类型(id),统一是字符串
        //Student.queryAll()
        
        // 查询所有,方案2
        // 作用: 可以处理不同特定类型, 步骤相对来说复杂
        Student.queryAllOther()
        
        
        
    }

}

