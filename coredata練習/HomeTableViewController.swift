//
//  HomeTableViewController.swift
//  coredata練習
//
//  Created by 翁燮羽 on 2021/7/30.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    
    var container: NSPersistentContainer! //存 AppDelegate的 container
    var loves = [Loves]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getLoves()
    }
    
    //增加資料
    @IBAction func addData(_ sender: UIBarButtonItem) {
        alert()
    }
    //按+ 跳出輸入名稱alert
    func alert(){
        let controller = UIAlertController(title: "輸入名稱", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "新增", style: .default) { (_) in
            let name = controller.textFields?.first?.text
            self.save(name: name)
        }
        controller.addAction(action)
        controller.addTextField(configurationHandler: nil)
        present(controller, animated: true, completion: nil)
    }
    
    //存檔動作
    func save(name:String?){
        let context = container.viewContext
        let love = Loves(context: context)
        love.name = name ?? ""
        //將資料存回array裏面
        loves.append(love)
        //將新增內容加回tableView的array裡
        tableView.insertRows(at: [IndexPath(row: loves.count - 1, section: 0)], with: .automatic)
        //執行coreData存檔
        container.saveContext()
    }
    //讀取資料
    func getLoves(){
        let context = container.viewContext
        do {
            loves = try context.fetch(Loves.fetchRequest())
        } catch {
            print("讀取失敗")
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loves.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeTableViewController.self)", for: indexPath)

        cell.textLabel?.text = loves[indexPath.row].name

        return cell
    }
    
    //刪除資料
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = container.viewContext
        let row = loves[indexPath.row]
        //移除array選到的這筆資料
        loves.remove(at: indexPath.row)
        //將選到的資料從coredata裡 刪除
        context.delete(row)
        //存檔
        container.saveContext()
        //刪除tableview畫面上的cell
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
