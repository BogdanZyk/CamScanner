//
//  LocalFileManager.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation
import SwiftUI


class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    let fm = FileManager.default
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        //Create folder
        createFolderIfNeeded(folderName: folderName)
        // get path image
        guard
            let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        // save image
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folederName: String) -> UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folederName),
              fm.fileExists(atPath: url.path) else{
                  return nil
              }
        return UIImage(contentsOfFile: url.path)
    }
    
    public func getContentsOfDirectory(folderName: String) -> [String]?{
        
        guard let url = getURLForFolder(folderName: folderName) else {return []}
      
        do {
            let items = try fm.contentsOfDirectory(atPath: url.path)
            return items
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !fm.fileExists(atPath: url.path){
            do {
                print("createFolderIfNeeded")
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. Folder \(folderName). \(error)")
            }
        }
    }
    

    public func deleteFolder(folderName: String){
        guard let path = getURLForFolder(folderName: AppConstants.getFullFolderPath(folder: folderName))?.path else {return}
        do {
            try fm.removeItem(atPath: path)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL?{
        guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL?{
        guard let folderUrl = getURLForFolder(folderName: folderName) else {return nil}
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
