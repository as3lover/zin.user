//
//  Timer2.swift
//  zin
//
//  Created by Morteza on 6/23/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation

class Timer2
{
    private var _timer:Timer?
    var timerDispatchSourceTimer:DispatchSourceTimer?
    
    private var _count:Int!
    private var _step:Double!
    private var _function:(()->())!
    private var _repeats:Bool!
    private var _lastTime:Double!
    private var _started:Bool!
    
    var step:Double
    {
        get{
            return _step
        }
        
        set(val){
            _step = val
            
            if _started{
                start()
            }
        }
    }
    
    var function:()->()
    {
        get{
            return _function
        }
        
        set(val){
            _function = val
            
            if _started{
                start()
            }
        }
    }
    
    var repeats:Bool
    {
        get{
            return _repeats
        }
        
        set(val){
            _repeats = val
        }
    }
    
    var count:Int{
        return _count
    }
    
    var elapced:Double{
        return Date().timeIntervalSince1970 - _lastTime
    }
    
    
    
    init(step:Double, function:@escaping (()->()), repeats:Bool, start:Bool=true)
    {
        _started = start
        self.start(step: step, function: function, repeats: repeats)
    }
    
    func start(step:Double, function:@escaping ()->(), repeats:Bool)
    {
        print("start")
        _count = 0
        _step = step
        _function = function
        _repeats = repeats
        _lastTime = Date().timeIntervalSince1970
        
        if !_started{return}
        
        stop()
        _started = true
        
        print("timer started")
        
        if #available(iOS 10.0, *) {
            print("version 10", step, _repeats)
            //_timer = Timer.scheduledTimer(withTimeInterval: _step, repeats: _repeats, block: fire)
            _timer = Timer.scheduledTimer(timeInterval: _step, target: self, selector: "fire", userInfo: nil, repeats: _repeats)
        } else {
            // Fallback on earlier versions
            print("old version")
            timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .milliseconds(Int(_step * 1000)))
            timerDispatchSourceTimer?.setEventHandler{
               self.fire()
            }
            timerDispatchSourceTimer?.resume()
        }
    }
    
    func start()
    {
        _started = true
        start(step: _step, function: _function, repeats: _repeats)
    }
    
    func stop()
    {
        print("stop")
        _started = false
        
        if _timer != nil
        {
            _timer?.invalidate()
            _timer = nil
        }
        else if timerDispatchSourceTimer != nil
        {
            timerDispatchSourceTimer?.cancel()
            timerDispatchSourceTimer = nil
        }
    }
    
    private func fire(_ sender:Timer? = nil)
    {
        DispatchQueue.main.async {
             print("fire")
        }
       
        _function()
        
        _count = _count + 1
        _lastTime = Date().timeIntervalSince1970
        
        if !_repeats
        {
            stop()
        }
    }
    
}
