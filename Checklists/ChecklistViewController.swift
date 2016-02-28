//
//  ViewController.swift
//  Checklists
//
//  Created by leeguoyu on 16/1/29.
//  Copyright © 2016年 leeguoyu. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items: [ChecklistItem]

    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "brush my teeth"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "learn iOS"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "soccer practice"
        row3item.checked = true
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "eat ice cream"
        row4item.checked = false
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "go to hell"
        row5item.checked = true
        items.append(row5item)
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        
        //调用cell初始化方法
        configureCheckmarkForCell(cell, withChecklistItem: item)
        configureTextForCell(cell, withChecklistItem: item)
        return cell
    }
    
    //MARK: cell的设置
    
    //打钩与否
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            
            let item = items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
            
        }
        //点击后把cell的状态设置为 未选择。
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //持久化条目
        saveChecklistItems()

    }
    
    //用于初始化cell的方法，比如它的accessoryType
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item:ChecklistItem){
        
        let label = cell.viewWithTag(10001) as! UILabel
        
        if item.checked{
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    //初始化cell的文字
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item:ChecklistItem){
        let label = cell.viewWithTag(10000) as! UILabel
        label.text = item.text
    }
    
    //滑动删除条目
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        //持久化条目
        saveChecklistItems()

    }
    
    //MARK: 实现itemDetailViewController的代理方法
    //取消保存
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //新增条目
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //持久化条目
        saveChecklistItems()
        
    }
    
    //修改条目
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem){
        if let index = items.indexOf(item){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        //持久化条目
        saveChecklistItems()
    }
    //通过segue传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem"{
            
            //因为segue先从ChecklistViewController连到navigationController，再到ItemDetailViewController
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        }else if segue.identifier == "EditItem"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
            
        }
    }
    
    //MARK: 数据持久化
    
    //创建文件目录
    func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String{
        let directory = documentsDirectory() as NSString
        return directory.stringByAppendingPathComponent("Checklists.plist")
    }
    
    //保存清单对象
    func saveChecklistItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
        
    }

}






