//
//  TimerViewModel.swift
//  TestBackgroundFetchingApp
//
//  Created by Геворг on 07.02.2022.
//

import SwiftUI
import UserNotifications

//timer model and data...

class TimerData: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    @Published var time: Int = 0
    @Published var selectedTime: Int = 0
    
    //animation properties
    @Published var buttonAnimation = false
    
    //timeview data...
    @Published var timerViewOffset: CGFloat = UIScreen.main.bounds.height
    @Published var timerHightChange: CGFloat = 0
    
    //getting time when it leaves the app
    @Published var leftTime: Date = Date()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //telling what to do when receiving in foreground
        completionHandler([.banner, .sound])
    }
    
    //process users's response to a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //when tapping the notification
        completionHandler()
    }
    
    func resetView() {
        withAnimation(.default) {
            time = 0
            selectedTime = 0
            timerHightChange = 0
            timerViewOffset = UIScreen.main.bounds.height
            buttonAnimation = false
        }
    }
    
}
