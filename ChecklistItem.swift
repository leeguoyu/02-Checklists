//
//  ChecklistItem.swift
//  Checklists
//
//  Created by leeguoyu on 16/1/29.
//  Copyright © 2016年 leeguoyu. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeObject(checked, forKey: "Checked")
        
    }
    
    //以下两个方法是继承 NSCoding 要实现的
    required init?(coder aDecoder: NSCoder) {
        //从plist读取数据
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        
        super.init()
    }
    
    override init(){
        super.init()
    }
    
    

}

