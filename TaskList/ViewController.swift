//
//  ViewController.swift
//  TaskList
//
//  Created by user215932 on 4/28/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Database context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var toDoItems = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TaskList"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
        // Add + button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapPlus))
        
        localNotification()
    }
    
    @objc private func didTapPlus(){
        let alert = UIAlertController(title: "Add Item", message: "Add a new to-do item", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let item = toDoItems[indexPath.row]
                let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
                sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                
                    let alert = UIAlertController(title: "Edit Item", message: "Edit to-do item", preferredStyle: .alert)
                
                    alert.addTextField(configurationHandler: nil)
                    alert.textFields?.first?.text = item.name
                    alert.addAction(UIAlertAction(title: "Save changes", style: .cancel, handler: { [weak self] _ in
                        guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                            return
                        }
                
                        self?.updateItem(item: item, newName: newName)
                    }))
                    self.present(alert, animated: true)
                }))
                sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    self?.deleteItem(item: item)
                }))
                
                present(sheet, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = toDoItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "Your Task"
        vc.createdAt = toDoItems[indexPath.row].createdAt
        vc.name = toDoItems[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Handle local notification
    func localNotification(){
        // Ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert], completionHandler: {(granted, error) in })
        
        // Notification content
        let content = UNMutableNotificationContent()
        content.title = "Like TaskList?"
        content.body = "Don't forget to rate the App on the App Store"
        
        // Notification trigger
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    // CoreData Operations
    func getAllItems(){
        do{
            toDoItems = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print(error)
        }
    }

    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print(error)
        }
    }
    
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print(error)
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print(error)
        }
    }
}

