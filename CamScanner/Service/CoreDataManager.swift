//
//  CoreDataManager.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import Foundation
import CoreData

final class CoreDataManager{
    
    
    
    static let instace = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init(){
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOAD CORE DATA \(error.localizedDescription)")
            }
        }
        context = container.viewContext
        createRootFolder()
    }
    
    public func save(){
        do {
            try context.save()
            print("Save success!")
        } catch let error {
            print("ERROR SAVING CORE DATA \(error.localizedDescription)")
        }
    }
    
    private func createRootFolder(){
        let newFolder = RootFolder(context: context)
        newFolder.name = "All Files"
        if !context.isEqual(newFolder){
            save()
        }
    }
    
}
