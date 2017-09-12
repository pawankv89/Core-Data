//
//  CoreDataStack.swift
//  WorldClock
//
//  Created by Pawan kumar on 7/4/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class CoreDataStack {
    
    // Can't init is singleton
    private init() {
    
        print("CoreDataStack Initialized")
    }
    
    // MARK: Shared Instance
    
   static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PKManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "PKManager", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStack.shared.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PKManager.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {

        let context = getContext()
        //save the object
        do {
            try context.save()
            //print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
   private func getUTCFormateDate(_ localDate: Date) -> String {
       
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormatter.string(from: localDate)
        return dateString
    }

    // MARK: - Get Object of ManagedObjectContext
    
    func getContext () -> NSManagedObjectContext {
        
            if #available(iOS 10.0, *) {
                 //IOS 10
                return CoreDataStack.shared.persistentContainer.viewContext
                
            } else {
                // Fallback on earlier versions
                
                //IOS 9
                return CoreDataStack.shared.managedObjectContext
            }
    }
    
    private func insertUserPreferences (property: String, value: String, date: String) {
       
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "UserRecord", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //Delete First then Save Value
        _ = deleteValueforKey(property)
        //print("Insert Status \(status)")
        
        //set the entity values
        transc.setValue(property, forKey: "property")
        transc.setValue(value, forKey: "value")
        transc.setValue(date, forKey: "updateDate")
        
        //save the object
        do {
            try context.save()
            //print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }

    // MARK: - Save Value For Key
    func saveValue(_ value: String, forKey key: String) -> Bool {
        let date = Date()
        let dateSting: String = getUTCFormateDate(date)
        insertUserPreferences(property: key, value: value, date: dateSting)
        return true
    }
    
    // MARK: - Get Value For Key
    func getValueForKey(_ property: String) -> String {
        
        let context = getContext()
        
        // Define our table/entity to use
        let entity = NSEntityDescription.entity(forEntityName: "UserRecord", in: context)
        // Setup the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let searchPredicate = NSPredicate(format: "(property == %@)", property)
        request.predicate = searchPredicate
        // Fetch the records and handle an error
        var _: Error?
        
        let mutableFetchResults: [Any]? = try? context.fetch(request)
        if mutableFetchResults == nil {
            return ""
        }
        else if mutableFetchResults?.count == 0 {
            return ""
        }
        
        //I like to check the size of the returned results!
        //print ("num of results = \(String(describing: mutableFetchResults?.count))")
        
        let trans : NSManagedObject  = (mutableFetchResults?[0] as? NSManagedObject)!
        let value : String = (trans.value(forKey: "value") as? String)!
        
        return value
    }
    
    // MARK: - Get Value For Key
    func deleteValueforKey(_ property: String) -> Bool {
        
        let context = getContext()
        
        // Define our table/entity to use
        let entity = NSEntityDescription.entity(forEntityName: "UserRecord", in: context)
        // Setup the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let searchPredicate = NSPredicate(format: "(property == %@)", property)
        request.predicate = searchPredicate
        // Fetch the records and handle an error
    
        let mutableFetchResults: [Any]? = try? context.fetch(request)
       
        //I like to check the size of the returned results!
        //print ("num of results = \(String(describing: mutableFetchResults?.count))")
        
        if (mutableFetchResults?.count)! > 0 {
            
            for trans in (mutableFetchResults as! [NSManagedObject]) {
                
                context.delete(trans)
            }

            //save the object
            do {
                try context.save()
                print("Delete First property!\(property)")
            } catch let error as NSError  {
                print("Could not Delete \(error), \(error.userInfo)")
            } catch {
                
            }
        }
        //Remove in CoreData
        return true
    }
    
    // MARK: - Delete All UserRecord
    func deleteAllUserRecordTable() -> Bool {
        
        let context = getContext()
        
        // Define our table/entity to use
        let entity = NSEntityDescription.entity(forEntityName: "UserRecord", in: context)
        // Setup the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>()
    
        request.entity = entity
        request.includesPropertyValues = false
    
        let mutableFetchResults: [Any]? = try? context.fetch(request)
        
        //I like to check the size of the returned results!
        //print ("num of results = \(String(describing: mutableFetchResults?.count))")
        
        if (mutableFetchResults?.count)! > 0 {
            
            for trans in mutableFetchResults as! [NSManagedObject] {
                
                context.delete(trans)
            }
            
            //save the object
            do {
                try context.save()
                print("Delete All \(String(describing: entity?.name))!")
            } catch let error as NSError  {
                print("Could not Delete \(error), \(error.userInfo)")
            } catch {
                
            }
        }
        //Remove in CoreData
        return true
    }
    
    //MARK : - Person Record
    func insertPersonRecord (person : Person) {
        
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "PersonRecord", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(person.name, forKey: "name")
        transc.setValue(person.age, forKey: "age")
        transc.setValue(person.accountType, forKey: "accountType")
        transc.setValue(person.phone, forKey: "phone")
        transc.setValue(person.gender, forKey: "gender")
        transc.setValue(person.location, forKey: "location")
        
        //save the object
        do {
            try context.save()
            //print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }

    // MARK: - Get Person Record List
    func getPersonRecordList() -> Array<Any> {
    
        var personList = [Person]()

        let context = getContext()
        
        // Define our table/entity to use
        let entity = NSEntityDescription.entity(forEntityName: "PersonRecord", in: context)
        // Setup the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        
        // Fetch the records and handle an error
        var _: Error?
        
        let mutableFetchResults: [Any]? = try? context.fetch(request)
        if mutableFetchResults == nil {
            return personList
        }
        else if mutableFetchResults?.count == 0 {
            return personList
        }
        
        //I like to check the size of the returned results!
        //print ("num of results = \(String(describing: mutableFetchResults?.count))")
        
        for trans in (mutableFetchResults as! [NSManagedObject]) {
        
            let name : String = (trans.value(forKey: "name") as? String)!
            let age : String = (trans.value(forKey: "age") as? String)!
            let accountType : String = (trans.value(forKey: "accountType") as? String)!
            let phone : String = (trans.value(forKey: "phone") as? String)!
            let gender : String = (trans.value(forKey: "gender") as? String)!
            let location : String = (trans.value(forKey: "location") as? String)!
            
            let person = Person()
            
            person.name = name
            person.age = age
            person.phone = phone
            person.gender = gender
            person.location = location
            person.accountType = accountType
            
             personList.append(person)
        }

        return personList
    }

    // MARK: - Get Value For Key
    func deletePersonRecord(person : Person) -> Void {
        
        let context = getContext()
        
        // Define our table/entity to use
        let entity = NSEntityDescription.entity(forEntityName: "PersonRecord", in: context)
        // Setup the fetch request
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let searchPredicate = NSPredicate(format: "(phone == %@)", person.phone!)
        request.predicate = searchPredicate
        // Fetch the records and handle an error
        
        let mutableFetchResults: [Any]? = try? context.fetch(request)
        
        //I like to check the size of the returned results!
        //print ("num of results = \(String(describing: mutableFetchResults?.count))")
        
        if (mutableFetchResults?.count)! > 0 {
            
            for trans in (mutableFetchResults as! [NSManagedObject]) {
                
                context.delete(trans)
            }
            
            //save the object
            do {
                try context.save()
                print("Delete First property!\(person.phone!)")
            } catch let error as NSError  {
                print("Could not Delete \(error), \(error.userInfo)")
            } catch {
                
            }
        }
        //Remove in CoreData
        //return true
    }
    
}
