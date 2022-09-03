//
//  ViewController.swift
//  ToDoList
//
//  Created by 髙津悠樹 on 2022/09/02.
//

import UIKit

class TableViewController: UITableViewController {
    
    var todoText = [String]()
    
    var todoCheck = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            // NavigationBarの背景色の設定
            appearance.backgroundColor = UIColor.systemOrange
            // NavigationBarのタイトルの文字色の設定
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAddItemButton(_:)))
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        //テキスト
        if UserDefaults.standard.object(forKey: "TodoText") != nil {
            todoText = UserDefaults.standard.object(forKey: "TodoText") as! [String]

        }
        //チェックマーク
        if UserDefaults.standard.object(forKey: "TodoCheck") != nil {
            todoCheck = UserDefaults.standard.object(forKey: "TodoCheck") as! [Bool]

        }
       /*
        todoText.append("宿題をする")
        todoCheck.append(false)
        todoText.append("YouTubeを見る")
        todoCheck.append(false)
        */
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoText.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        TodoCell.textLabel!.text = todoText[indexPath.row]
        
        let accessory: UITableViewCell.AccessoryType = todoCheck[indexPath.row] ? .checkmark: .none
        TodoCell.accessoryType = accessory
        
        return TodoCell
    }
    
    //チェックマークをつける
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        todoCheck[indexPath.row] = !todoCheck[indexPath.row]
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
    //セルを削除する
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoText.remove(at: indexPath.row)
        todoCheck.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        UserDefaults.standard.set(todoText, forKey: "TodoText")
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
    
    //テキストを追加する
    func addNewToDoItem(title: String) {
        let newIndex = todoText.count
        todoText.append(title)
        todoCheck.append(false)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        UserDefaults.standard.set(todoText, forKey: "TodoText")
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
    
    @objc func didTapAddItemButton(_ sendar: UIBarButtonItem) {
        
        let alert = UIAlertController(
            title: "追加する項目", message: "Todoリストに新しい内容を追加します", preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text {
                
                if title == "" {
                    let al = UIAlertController(
                        title: "エラー", message: "テキストを入力してください", preferredStyle: .alert
                    )
                    al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(al, animated: true, completion: nil)
                } else {
                    self.addNewToDoItem(title: title)

                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }


}

