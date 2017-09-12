//
//  AddPersonVC.swift
//  PKCoreData
//
//  Created by Pawan kumar on 7/5/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

import Foundation
import UIKit

class AddPersonVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Add Person Record List
    @IBAction func adduttonAction(_ sender: Any) {
        
        if name.text! == "" || age.text! == "" || phone.text! == "" {
            return
        }
        
        let person = Person()
        
        person.name = name.text!
        person.age = age.text!
        person.phone = phone.text!
        person.gender = "Male"
        person.location = "Noida"
        person.accountType = "IOS"
        
        CoreDataStack.shared.insertPersonRecord(person: person)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:  Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    
}
