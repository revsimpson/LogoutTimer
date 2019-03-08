//
//  TimerApplication.swift
//  LogOutTimer
//
//  Created by Richard EV Simpson on 08/03/2019.
//  Copyright © 2019 REVS. All rights reserved.
//

import UIKit

class TimerApplication: UIApplication {
 
    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 6 seconds
        return 0.10 * 60
    }
    
    private var idleTimer: Timer?
    
    // resent the timer because there was user interaction
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerApplication.timeHasExceeded),
                                         userInfo: nil,
                                         repeats: false
        )
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        NotificationCenter.default.post(name: .appTimeout, object: nil)
        
    }
    
    func resetTimerManually() {
        print("Timer has manually been reset")
        resetIdleTimer()
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        super.sendEvent(event)
        
        // Even if the timer is finished the sendEvent will still be called. So if you want to start the timer when somebody logged in to your app you should set a check here to see if the user is logged In.
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}


extension Notification.Name {
    
    static let appTimeout = Notification.Name("appTimeout")
    
}
