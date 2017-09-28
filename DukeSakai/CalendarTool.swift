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
     返回年
     - parameter date: 数据
     - returns: 年
     */
    open class func Year(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.year, from: date)
        return components.year!
    }
    
    /**
     返回月
     - parameter date: 数据
     - returns: 月
     */
    open class func Month(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.month, from: date)
        return components.month!
    }
    
    /**
     返回日
     - parameter date: 数据
     - returns: 日
     */
    open class func Day(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.day, from: date)
        return components.day!
    }
    
    
    
    /**
     返回这个月的天数
     - parameter date:数据
     - returns: 天
     */
    open class func DaysInMonth(_ date:Date)->Int{
        let days = (Foundation.Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return days.length
    }
    
    /**
     获取上一个月
     - parameter date: 数据
     - returns: 上一月
     */
    open class func UpMonth(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.month  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    
    /**
     获取下一个月
     - parameter date: 数据
     - returns: 下一月
     */
    open class func NextMonth(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.month  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    /**
     获取上一个年
     - parameter date: 数据
     - returns: 上一年
     */
    open class func UpYear(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.year  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    /**
     获取下一个年
     - parameter date: 数据
     - returns: 下一年
     */
    open class func NextYear(_ date:Date)->Date{
        var dateComponents = DateComponents()
        dateComponents.year  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return newDate!
    }
    
    
    
    /**
     这个月的第一天是星期几
     - parameter date: 数据
     - returns: 周几
     */
    open class func DayinWeek(_ date:Date)->Int{
        
        let interval = date.timeIntervalSince1970 - 18000;
        var days = Int(interval / 86400);
        days =  days - Day(date) + 1
        return (days - 3) % 7;
    }
    
    
    
    
    
    
    
}


