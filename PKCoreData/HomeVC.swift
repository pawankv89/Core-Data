//
//  Home.swift
//  PKCoreData
//
//  Created by Pawan kumar on 7/5/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

import Foundation
import UIKit

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phone: UILabel!
    
}

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var personRecordList = [Person]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refrsh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refrsh()
    }
    
    func refrsh() -> Void {
        
        personRecordList =  CoreDataStack.shared.getPersonRecordList() as! [Person]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - UITableViewDataSource
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return personRecordList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
            
            let person = personRecordList[indexPath.row] as Person
            cell.name?.text = "Name: \(String(describing: person.name!))"
            cell.age?.text = "Age: \(String(describing: person.age!))"
            cell.phone?.text = "Phone: \(String(describing: person.phone!))"
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
         let person = personRecordList[indexPath.row] as Person
        
        let alert = UIAlertController(
            title: "Delete",
            message: "Are you sure you want to delete \(String(describing: person.name!))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                print("default")
                CoreDataStack.shared.deletePersonRecord(person: person)
                self.refrsh()
               
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action in
            switch action.style{
                
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: Add Person Record List
    @IBAction func addPersonButtonAction(_ sender: Any) {
        
        displayAddPersoniewController()
    }
    
    //MARK: Display Add Person ViewController
    func displayAddPersoniewController() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddPersonVC") as! AddPersonVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
