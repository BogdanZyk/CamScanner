//
//  ScanData.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation


struct ScanData: Identifiable{
    var id = UUID()
    let content: String
    
    
    init(content: String){
        self.content = content
    }
}
