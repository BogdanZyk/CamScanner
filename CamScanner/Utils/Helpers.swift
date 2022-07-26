//
//  Helpers.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import Foundation
import SwiftUI

final class Helpers{
    
    
    static  func convertImageToData(images: [UIImage]) -> [Data]{
        
        return images.compactMap({$0.jpegData(compressionQuality: 1)})
    }
    
    static func convertDataToImages(imageData: [Data]) -> [UIImage] {
        
        return imageData.compactMap({UIImage(data: $0)})
    }
    
    
    static func archiveImageData(images: [UIImage]) -> Data?{
        
        let imagesDataArray = convertImageToData(images: images)
        
        var data: Data?
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: imagesDataArray, requiringSecureCoding: true)
        } catch {
            print("Error archiveImageData")
        }
        return data
    }
    
    
    static func unarchivedImageData(imageData: Data) -> [UIImage]?{
        
        var myImagesdataArray = [Data]()
        
       
            var dataArray = [Data]()
            do {
                dataArray = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: imageData) as! [Data]
                myImagesdataArray.append(contentsOf: dataArray)
            } catch {
                print("could not unarchive array: \(error.localizedDescription)")
            }
        
        let image = convertDataToImages(imageData: myImagesdataArray)
        return image
    }
    

}
