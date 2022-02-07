//
//  TestBackgroundFetchingAppApp.swift
//  TestBackgroundFetchingApp
//
//  Created by Геворг on 07.02.2022.
//

import SwiftUI

@main
struct TestBackgroundFetchingAppApp: App {
    @StateObject var data = TimerData()
    //using scene phase for scene data...
    @Environment(\.scenePhase) var scene
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
        }
        .onChange(of: scene) { newScene in
            if newScene == .background {
                data.leftTime = Date()
            }
            //when it enter again -> check the time difference
            if newScene == .active && data.time != 0 {
                let diff = Date().timeIntervalSince(data.leftTime)
                
                let currentTime = data.selectedTime - Int(diff)
                if currentTime >= 0 {
                    withAnimation(.default) {
                        data.selectedTime = currentTime
                    }
                } else {
                    //resetting view
                    data.resetView()
                }
            }
        }
    }
}
