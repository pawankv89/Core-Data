//
//  ViewController.swift
//  PKCoreData
//
//  Created by Pawan kumar on 7/5/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var status : Bool = CoreDataStack.shared.saveValue("Pawan", forKey: "Name")
        print("status:\(status)")
        
        status = CoreDataStack.shared.saveValue("27", forKey: "Age")
        status = CoreDataStack.shared.saveValue("IOS", forKey: "Post")
        print("status:\(status)")
        
        var name : String =  CoreDataStack.shared.getValueForKey("Name")
        var age : String =  CoreDataStack.shared.getValueForKey("Age")
        var post : String =  CoreDataStack.shared.getValueForKey("Post")
        print("Name:\(name)")
        print("age:\(age)")
        print("post:\(post)")
        
        //Delete All UserRecord Data
        status  = CoreDataStack.shared.deleteAllUserRecordTable()
        
        name  =  CoreDataStack.shared.getValueForKey("Name")
        age  =  CoreDataStack.shared.getValueForKey("Age")
        post  =  CoreDataStack.shared.getValueForKey("Post")
        
        print("Name:\(name)")
        print("age:\(age)")
        print("post:\(post)")
        
        let person = Person()
        
            person.name = "Pawan"
            person.age = "25"
            person.phone = "9876543210"
            person.gender = "Male"
            person.location = "Noida"
            person.accountType = "IOS"
        
         CoreDataStack.shared.insertPersonRecord(person: person)
        
        let personRecordList =  CoreDataStack.shared.getPersonRecordList()
        
        print("personRecordList:\(personRecordList)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

