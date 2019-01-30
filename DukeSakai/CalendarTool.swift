//
//  CalendarTool.swift
//  DukeSakai
//
//  Created by 马丞章 on 4/2/17.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

import UIKit

//Calendar Reference: https://github.com/LitterL/CalendarDemo 

open class CalendarTool: NSObject {
    /**
     Returns year
     - parameter date: data
     - returns: year
     */
    open class func Year(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.year, from: date)
        return components.year!
    }
    
    /**
     Returns month
     - parameter date: data
     - returns: month
     */
    open class func Month(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.month, from: date)
        return components.month!
    }
    
    /**
     Returns day
     - parameter date: data
     - returns: day
     */
    open class func Day(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.day, from: date)
        return components.day!
    }
    
    
    
    /**
     Returns the number of days in this month
     - parameter date: data
     - returns: day
     */
    open class func DaysInMonth(_ date:Date)->Int{
        let days = (Foundation.Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return days.length
    }
    
    /**
     Returns the last month
     - parameter date: data
     - returns: last month
     */
    open class func UpMonth(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.month  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    
    /**
     Returns the next month
     - parameter date: data
     - returns: next month
     */
    open class func NextMonth(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.month  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    /**
     Returns the previous year
     - parameter date: data
     - returns: last year
     */
    open class func UpYear(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.year  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    /**
     Returns the next year
     - parameter date: data
     - returns: next year
     */
    open class func NextYear(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.year  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    
    
    /**
     The first day of the month is the day of the week
     - parameter date: data
     - returns: day of the week
     */
    open class func DayinWeek(_ date:Date)->Int{
        
        let interval = date.timeIntervalSince1970 - 18000;
        var days = Int(interval / 86400);
        days =  days - Day(date) + 1
        return (days - 3) % 7;
    }
    
}


