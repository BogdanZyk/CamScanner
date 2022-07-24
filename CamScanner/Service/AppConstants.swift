//
//  AppConstants.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation

final class AppConstants{
    
    static let appFolderName: String = "CamScanner"
    
    static func getFullFolderPath(folder: String) -> String{
        appFolderName + "/" + folder
    }
}



