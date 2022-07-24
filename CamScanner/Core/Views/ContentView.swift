//
//  ContentView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeVM = HomeViewModel()
    @State private var showScanner: Bool = false
//    @State private var texts: [ScanData] = []
    @State private var currentTab: Tab = .main
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeView()
                    .environmentObject(homeVM)
                .tag(Tab.main)
                
                SettingsView()
                .tag(Tab.setting)
            }
            tabBarView
        }
        .fullScreenCover(isPresented: $showScanner) {
            ScannerView(homeVM: homeVM, isShowScannerView: $showScanner)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView{
    
    enum Tab: String, CaseIterable{
        case main = "house.fill"
        case setting = "gearshape.fill"
    }
//    private func makeScannerView() -> ScannerView{
//        ScannerView { textPerPage in
//            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespaces){
//                //let newScanDate = ScanData(content: outputText)
//
//                homeVM.addFile(name: outputText, inFolder: nil)
//                //self.texts.append(newScanDate)
//            }
//            self.showScanner = false
//        }
//    }
    
    private var tabBarView: some View{
        HStack(spacing: 0){
            Spacer()
            tabButton(tab: .main)
            Spacer()
            addNewScanDocBtn
                .offset(y: -30)
            Spacer()
            tabButton(tab: .setting)
            Spacer()
        }
        .hCenter()
        .padding(.horizontal, 20)
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .padding(.horizontal)
        
    }
    
    
    private func tabButton(tab: Tab) -> some View{
        Button {
            currentTab = tab
        } label: {
            Image(systemName: tab.rawValue)
                .foregroundColor(currentTab == tab ? .accent : .secondaryGray)
                .font(.title2)
        }
    }
    
    private var addNewScanDocBtn: some View{
        Button {
            showScanner.toggle()
        } label: {
            ZStack{
                Circle()
                    .fill(Color.accent)
                Image(systemName: "doc.viewfinder")
                    .foregroundColor(.white)
                    .font(.title)
            }
            .frame(width: 60, height: 60)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
}



