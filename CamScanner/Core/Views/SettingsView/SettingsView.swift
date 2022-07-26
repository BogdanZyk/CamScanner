//
//  SettingsView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var items = [Any]()
    @State private var showShare: Bool = false
    var body: some View {
        VStack{
            Text("Settings")
            Button {
                items.append(UIImage(systemName: "cloud.drizzle.fill")!)
                showShare.toggle()
            } label: {
                Text("Share")
            }

        }
        .allFrame()
        .sheet(isPresented: $showShare) {
            ShareSheet(items: items)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
