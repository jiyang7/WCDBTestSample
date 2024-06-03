//
//  TestFile.swift
//  TestProduct
//
//  Created by Mac Mini on 2024/4/29.
//

import Foundation
import WCDBSwift
import UIKit

let tableName = "tablesample"

class TestSample: NSObject {
    
    static let sharedInstance = TestSample()
    public static let testDB: Database = TestSample.sharedInstance.testDB()
    
    private override init() {
        super.init()
        
    }
    
    
    
    /**
     * 获取测试数据
     */
    func selectWrongTestData() -> String {
        
        var resultArray = [Sample]()
        let condition = Sample.Properties.type.in([6, 7, 10])
        let orderBy = Sample.Properties.type.order(.ascending)
        
        var errorMessage = ""
        
        do {
            let select = try TestSample.testDB.prepareSelect(of: Sample.self, fromTable: tableName).where(condition).order(by: orderBy).limit(40)
            let result = try select.allObjects(of: Sample.self)
            resultArray.append(contentsOf: result)
            errorMessage = "在一个do catch中查询两次，结果错误，result的个数不应和otherResult结果数相同\n"
            + "result.count \(result.count)\n"
            print("在一个do catch中查询两次，结果错误，result的个数不应和otherResult结果数相同\n")
            print("result.count \(result.count)\n")
            
            let otherSelect = try TestSample.testDB.prepareSelect(of: Sample.self, fromTable: tableName).where(!condition).order(by: orderBy)
            let otherResult = try otherSelect.allObjects(of: Sample.self)
            errorMessage = "在一个do catch中查询两次，结果错误，result的个数不应和otherResult结果数相同\n"
            + "result.count \(result.count)\n" + "otherResult.count \(otherResult.count)\n"
            print("otherResult.count \(otherResult.count)\n")
            resultArray.append(contentsOf: otherResult)
        } catch {
            
        }
        
        return errorMessage
        
    }
    
    func selectRightTestData() -> String {
        
        var resultArray = [Sample]()
        let condition = Sample.Properties.type.in([6, 7, 10])
        let orderBy = Sample.Properties.type.order(.ascending)
        var resultMessage = "在两个do catch中查询两次，结果正确，result的个数不应和otherResult结果数相同\n"
        print("在两个do catch中查询两次，结果正确，result的个数不应和otherResult结果数相同\n")
        do {
            let select = try TestSample.testDB.prepareSelect(of: Sample.self, fromTable: tableName).where(condition).order(by: orderBy).limit(40)
            let result = try select.allObjects(of: Sample.self)
            resultArray.append(contentsOf: result)
            resultMessage = resultMessage + "result.count \(result.count)\n"
            print("result.count \(result.count)\n")
            
        } catch {
            
        }
        
        do {
            let otherSelect = try TestSample.testDB.prepareSelect(of: Sample.self, fromTable: tableName).where(!condition).order(by: orderBy)
            let otherResult = try otherSelect.allObjects(of: Sample.self)
            
            resultMessage = resultMessage + "otherResult.count \(otherResult.count)\n"
            
            print("otherResult.count \(otherResult.count)\n")
            resultArray.append(contentsOf: otherResult)
        } catch {
            
        }
        
        return resultMessage
        
    }
    
    func testDB() -> Database {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = documentPath.appendingPathComponent("sample.sqlite")
        NSLog("%@", filePath)
        let database = Database(at: filePath)
        if !database.canOpen {
            assert(false, "fail")
        }
        
        return database
    }
    
    
    func createTable() {
        do {
            try TestSample.testDB.create(table: tableName, of: Sample.self)
            NSLog("create table %@ success", tableName)
        } catch {
            print("error - \(error)")
        }
    }
    
    func createSampleData() {
        
        do {
            //Prepare data
            var array = [Sample]()
            for i in 0..<10000 {
                let object = Sample()
                object.identifier = i
                object.description = "sample_insert - \(i)"
                if i % 4 == 0 {
                    object.type = 10
                } else if i % 4 == 1 {
                    object.type = 6
                } else if i % 4 == 2 {
                    object.type = 7
                } else if i % 4 == 3 {
                    object.type = 8
                }
                array.append(object)
            }
            //Insert
            try TestSample.testDB.insert(array, intoTable: tableName)
        } catch let error {
            print("error - \(error)")
        }
        
    }
    
    func updateMessageInfo(with messageArray: [Sample]){
        do {
            try TestSample.testDB.insert(messageArray, intoTable: tableName)
        } catch let error {
            print("error - \(error)")
        }
    }
    
}

final class Sample: TableCodable {
    var identifier: Int? = nil
    var description: String? = nil
    var type: Int? = 0
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
        case type
    }
}
