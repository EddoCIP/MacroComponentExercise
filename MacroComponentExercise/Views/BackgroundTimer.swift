//
//  BackgroundTimer.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 30/11/22.
//

import SwiftUI

class BackgroundTimerLogic: ObservableObject {
    @Published var startTime: Date?
    @Published var stopTime: Date?
    @Published var timerCounting: Bool = false
    var scheduledTimer: Timer!
    @Published var label: String = ""
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    init() {
        startTime = UserDefaults.standard.object(forKey: "startTime") as? Date
        stopTime = UserDefaults.standard.object(forKey: "stopTime") as? Date
        timerCounting = UserDefaults.standard.bool(forKey: "countingKey")
        
        if timerCounting {
            startTimer()
        } else {
            stopTimer()
            
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }
    
    func startTimer() {
        setTimerCounting(true)
    }
    func stopTimer() {
        setTimerCounting(false)
    }
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        
        return Date().addingTimeInterval(diff)
    }
    func setStartTime(date: Date?)
    {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?)
    {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool)
    {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func startStopAction() {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        } else {
            if let stop = stopTime {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else {
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
    {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        self.label = makeTimeString(hour: time.0, min: time.1, sec: time.2)
    }
}

struct BackgroundTimer: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @StateObject var backgroundTimer = BackgroundTimerLogic()
    
    var body: some View {
        VStack {
            Text(backgroundTimer.label)
                .foregroundColor(Color.red)
            
            HStack {
                Button {
                    backgroundTimer.startStopAction()
                } label: {
                    Text(backgroundTimer.timerCounting ? "STOP" : "START")
                }
            }
            .onReceive(timer) { _ in
                if backgroundTimer.timerCounting {
                    if let start = backgroundTimer.startTime {
                        let diff = Date().timeIntervalSince(start)
                        backgroundTimer.setTimeLabel(Int(diff))
                    } else {
                        backgroundTimer.stopTimer()
                        backgroundTimer.setTimeLabel(0)
                    }
                }
            }
        }
    }
}

struct BackgroundTimer_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundTimer()
    }
}
