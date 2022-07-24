//
//  HomeViewModel.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation
import CoreData


final class HomeViewModel: ObservableObject{
    
    let coreDataManager = CoreDataManager.instace
    @Published var rootFolder: RootFolder?
    @Published var currentFiles: [Item]?
    @Published var createFolderName: String = ""
    @Published var currentSelectedFolder: SelectFolderModel?
 
    
    init(){
        getFolders()
        //addFile(name: "Test file", inFolder: nil)
    }
    
    private func getFolders(){
        let request = NSFetchRequest<RootFolder>(entityName: "RootFolder")
        do {
            rootFolder = try coreDataManager.context.fetch(request).first
            currentSelectedFolder = SelectFolderModel(name: rootFolder?.name, items: rootFolder?.items?.allObjects as? [Item])
        } catch let error {
            print("ERROR FETCH FOLDERS \(error.localizedDescription)")
        }
        
    }
    

    
    
    public func addFolder(){
        guard !createFolderName.isEmpty else {return}
        guard let folders = rootFolder?.folders?.allObjects as? [Folder], !folders.contains(where: {$0.name == createFolderName}) else {return}
        
        let folder = Folder(context: coreDataManager.context)
        folder.name = createFolderName
        folder.rootFolder = rootFolder
        
        save()
    }
    
    public func addFile(scan: ScanModel){
        
        let folders = rootFolder?.folders?.allObjects as? [Folder]
        let folder = folders?.first(where: {$0.name == currentSelectedFolder?.name})
        
        let file = Item(context: coreDataManager.context)
        file.name = scan.name
        file.content = scan.content
        file.folder = folder
        file.rootFolder = rootFolder
        save()
    }
    
    public func deleteFile(index: Int?){
        guard  let index = index, let item = currentSelectedFolder?.items?[index] else {return}
        coreDataManager.context.delete(item)
        save()
    }
    
    
    public func deleteFolder(folder: Folder){
        //let rootFolder = RootFolder(context: coreDataManager.context)
        coreDataManager.context.delete(folder)
        save()
    }
    
    private func save(){
        coreDataManager.save()
        getFolders()
    }
}





