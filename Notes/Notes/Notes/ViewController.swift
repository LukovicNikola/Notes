//
//  ViewController.swift
//  Notes
//
//  Created by Nikola Lukovic on 7/11/19.
//  Copyright © 2019 com.nikola. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addNote(_ sender: Any) {
        let alert = UIAlertController(title: "New Note", message: "Add a new note", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let notesToSave = textField.text else {
                    return
            }
            self.save(note: notesToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(note: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Notes",
                                       in: managedContext)!
        let insert = NSManagedObject(entity: entity, insertInto: managedContext)
        insert.setValue(note, forKeyPath: "noteCD")
        do {
            try managedContext.save()
            modelNote.append(insert)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        //3
        do {
            modelNote = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelNote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let n = modelNote[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = n.value(forKeyPath: "noteCD") as? String
        
        return cell
        
    }
    
    
}
