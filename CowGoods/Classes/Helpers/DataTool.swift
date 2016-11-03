//
//  DataTool.swift
//  CowGoods
//
//  Created by ddn on 16/6/23.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation
import SQLite

class Region {
    var id: Int?
    var name: String?
    var level: Int?
    var parent_id: Int?
    
    init(id: Int?, name: String?, level: Int?, parent_id: Int?) {
        self.id = id
        self.name = name
        self.level = level
        self.parent_id = parent_id
    }
    
    var city: Region?
    var county: Region?
    var road: Region?
}

class RegionTool {
    
    static let id = Expression<Int?>("id")
    static let name = Expression<String?>("name")
    static let level = Expression<Int?>("level")
    static let parent_id = Expression<Int?>("parent_id")
    
    class var path: String? {
        return NSBundle.mainBundle().pathForResource("region", ofType: "sqlite")
    }
    
    class func getProvince() -> [Region]? {
        return getSub("t_shen", filter_id: nil)
    }
    
    class func getCity(province: Region) -> [Region]? {
        return getSub("t_shi", filter_id: province.id)
    }
    
    class func getCounty(city: Region) -> [Region]? {
        return getSub("t_xian", filter_id: city.id)
    }
    
    class func getRoad(county: Region) -> [Region]? {
        return getSub("t_jie", filter_id: county.id)
    }
    
    private class func getSub(tableName: String, filter_id: Int?) -> [Region]? {
        if let db = try? Connection(path!) {
            let table = Table(tableName)
            
            var filter: Table = table
            
            if filter_id != nil {
                filter = table.filter(parent_id == filter_id)
            }
            
            if let datas = try? db.prepare(filter) {
                return datas.flatMap{Region(id: $0[id], name: $0[name], level: $0[level], parent_id: $0[parent_id])}
            }
        }
        return nil
    }
}










