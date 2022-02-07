//
//  Home.swift
//  TestBackgroundFetchingApp
//
//  Created by Геворг on 07.02.2022.
//

import SwiftUI
//sending notification
import UserNotifications

struct Home: View {
    
    @EnvironmentObject var data: TimerData
    
    var body: some View {
        ZStack {
        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(spacing: 20) {
                    ForEach(1...6, id: \.self) { index in
                        let time = index * 5
                        Text("\(time)")
                            .font(.system(size: 45, weight: .heavy))
                            .frame(width: 100, height: 100)
                        //changing color for selected ones
                            .background(data.time == time ? Color("black") : Color.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .onTapGesture {
                                withAnimation {
                                    data.time = time
                                    data.selectedTime = time
                                }
                            }
                    }
                }.padding()
            })
            //setting to center
                .offset(y: 40)
                .opacity(data.buttonAnimation ? 0 : 1)
            
            
            Spacer()
            Button {
                withAnimation(Animation.easeInOut(duration: 0.65)) {
                    data.buttonAnimation.toggle()
                }
                //delay animaiton
                                    //after button goes down view is moving up...
                withAnimation(Animation.easeIn.delay(0.6)) {
                    data.timerViewOffset = 0
                }
                performNotifications()
            } label: {
                Circle()
                    .fill(Color("black"))
                    .frame(width: 80, height: 80)
            }
            .padding(.bottom, 35)
            //disable if not selected
            .disabled(data.time == 0)
            .opacity(data.time == 0 ? 0.6 : 1)
            //moving data on smootly
            .offset(y: data.buttonAnimation ? 300 : 0)
        }
            Color("black")
                .overlay(
                    Text("\(data.selectedTime)")
                        .font(.system(size: 55, weight: .heavy))
                        .foregroundColor(.white)
                )
            //decresing height for each count down
                .frame(height: UIScreen.main.bounds.height - data.timerHightChange)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.all, edges: .all)
                .offset(y: data.timerViewOffset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        //timer functionality
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {_ in
            if data.time != 0 && data.selectedTime != 0 && data.buttonAnimation {
                data.selectedTime -= 1
                
                //updating height...
                let ProgressHeight = UIScreen.main.bounds.height / CGFloat(data.time)
                let diff = data.time - data.selectedTime
                
                withAnimation(.default) {
                    data.timerHightChange = CGFloat(diff) * ProgressHeight
                }
                
                if data.selectedTime == 0 {
                    //reseting...
                    data.resetView()
                }
            }
        }.onAppear {
            //permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
                
            }
            //setting delegate for in - App notifications...
            UNUserNotificationCenter.current().delegate = data
        }
    }
    func performNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Notification From Timer"
        content.body = "Timer Has Been Finished!"
        
        //triggering at selected time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(data.time), repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { err in
            if err != nil {
                print(err!.localizedDescription)
            }
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
