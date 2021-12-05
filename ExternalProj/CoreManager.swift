//
//  CoreManager.swift.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/04.
//

import Foundation
import CoreData

class PersistenceManager {
    
    static var shared: PersistenceManager = PersistenceManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func saveInfo(info: AlarmInfoModel) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "AlarmInfo", in: context)
                
        if let entity = entity {
            let data = NSManagedObject(entity: entity, insertInto: context)
            data.setValue(info.activation, forKey: "activation")
            data.setValue(info.date, forKey: "date")
            data.setValue(info.note, forKey: "note")
            data.setValue(info.subject, forKey: "subject")
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do{
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
