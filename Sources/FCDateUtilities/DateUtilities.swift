//
//  DateUtilities.swift
//
//  Created by Farley Caesar on 2016-04-25.
//  Copyright © 2021 PureFunc. All rights reserved.

/*
 Note that the date utilities below are based on the Gregorian calendar (the calendar in use in the majority of the world).
 The code here has not been tested under other calendars.
 */
import Foundation

// MARK: Calendar Specification
public enum DateUtilities {
    static var supportedCalendar: Calendar {
        Calendar(identifier: .gregorian)
    }
}

// MARK: Date Constructs
public enum StandardDateFormat: String {
    
    case YearDescription = "yyyy"
    case MonthDescription = "MMMM"
    case DayDescription = "dd"
    case ShortDateDescription = "EEEE, MMM dd yyyy"
    case ShortTimeDescription = "h:mm a"
    case LongTimeDescription = "h:mm:ss a"
    
}

public enum DateError: Error {
    case invalidDate(reason: String)
}

public enum DateUtilitiesConstant: Int {
    case canonicalHour = 12
    case canonicalMinute = 1
    case canonicalSecond = 0
}

let tweleve_01_PM = (canonicalHour: DateUtilitiesConstant.canonicalHour,
                     canonicalMinute: DateUtilitiesConstant.canonicalMinute,
                     canonicalSecond: DateUtilitiesConstant.canonicalSecond)

public enum Day: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension Day: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}


public enum Month: Int, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension Month: CustomStringConvertible {
    public var description: String {
        switch self {
        case .january: return "January"
        case .february: return "February"
        case .march: return "March"
        case .april: return "April"
        case .may: return "May"
        case .june: return "June"
        case .july: return "July"
        case .august: return "August"
        case .september: return "September"
        case .october: return "October"
        case .november: return "November"
        case .december: return "December"
        }
    }
}


// MARK: Date formatting methods
public extension DateFormatter {
    
    static func formattedDate(_ date: Date, byApplyingDateFormat dateFormat: StandardDateFormat) -> String {
        formattedDate(date, byApplyingDateFormat: dateFormat.rawValue)
    }
    
    static func formattedDate(_ date: Date, byApplyingDateFormat dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}

public extension Date {
    
    var shortDateDescriptionFormat: String {
        
        DateFormatter.formattedDate(
            self,
            byApplyingDateFormat: StandardDateFormat.ShortDateDescription)
    }
    
    var shortTimeDescriptionFormat: String {
        
        DateFormatter.formattedDate(
            self,
            byApplyingDateFormat: StandardDateFormat.ShortTimeDescription)
    }
    
    var shortDateLongTimeDescriptionFormat: String {
        
        DateFormatter.formattedDate(
            self,
            byApplyingDateFormat: "\(StandardDateFormat.ShortDateDescription.rawValue), \(StandardDateFormat.LongTimeDescription.rawValue)")
    }
    
    var shortDateTimeDescriptionFormat: String {
        
        DateFormatter.formattedDate(
            self,
            byApplyingDateFormat: "\(StandardDateFormat.ShortDateDescription.rawValue), \(StandardDateFormat.ShortTimeDescription.rawValue)")
    }
    
    var yearDescription: String {
        DateFormatter.formattedDate(self, byApplyingDateFormat: StandardDateFormat.YearDescription)
    }
    
    var monthDescription: String {
        DateFormatter.formattedDate(self, byApplyingDateFormat: StandardDateFormat.MonthDescription)
    }
    
    var dayDescription: String {
        DateFormatter.formattedDate(self, byApplyingDateFormat: StandardDateFormat.DayDescription)
    }
}


// MARK: Comparison Operations
public extension Date {
    func compare(against otherDate: Date,
                 for comparisonResult: ComparisonResult) -> Bool {

        self.compare(otherDate) == comparisonResult
    }

    func isSame(as otherDate: Date) -> Bool {
        compare(against: otherDate, for: .orderedSame)
    }

    func isGreater(than otherDate: Date) -> Bool {
        compare(against: otherDate, for: .orderedDescending)
    }

    func isLess(than otherDate: Date) -> Bool {
        compare(against: otherDate, for: .orderedAscending)
    }
    
    func isOnTheSameDay(as otherDate: Date) -> Bool {
        
        guard
            let canonicalDate1 = self.toCanonicalDate,
            let canonicalDate2 = otherDate.toCanonicalDate
        else {
            return false
        }
        
        return canonicalDate1.isSame(as: canonicalDate2)
    }
    
    var isOnWeekend: Bool {
        guard let cannoicalDate = self.toCanonicalDate else { return false }
        
        let components = DateUtilities.supportedCalendar.dateComponents([.weekday],from: cannoicalDate)
        
        guard let weekdayOfDate = components.weekday else { return false }
        
        return
            [Day.saturday.rawValue, Day.sunday.rawValue]
            .contains(weekdayOfDate)
    }
    
    var isLeapYear: Bool {
        guard let yearNumber = yearNumber else {
            return false
        }
        
        return Self.isLeapYear(yearNumber)
    }
        
    static func isLeapYear(_ year: Int) -> Bool {
        guard year >= 0 else { return false }
        
        if (year % 400) == 0 {
            // year is divisible by 400 then we have a leap year
            return true
        } else if (year % 100) == 0 {
            // year is divisible by 100. Not a leap year
            return false
        } else if (year % 4) == 0 {
            // year is divisible by 4 then we have a leap year
            return true
        } else {
            // not a leap year
            return false
        }
    }
    
    func isOnTheSameDayOfMonth(as otherDate: Date) -> Bool {
        dayNumberWithinMonth == otherDate.dayNumberWithinMonth
    }
    
    func isInSameMonthInSameYear(as otherDate: Date) -> Bool {
       return
        monthNumber == otherDate.monthNumber &&
        yearNumber == otherDate.yearNumber
    }
    
    func isInSameMonthWithoutRegardToYear(as otherDate: Date) -> Bool {
       monthNumber == otherDate.monthNumber
    }
    
    func isInSameYear(as otherDate: Date) -> Bool {
        yearNumber == otherDate.yearNumber
    }
    
    var isToday: Bool {
        guard
            let today = Date.canonicalToday,
            let canonicalDate = self.toCanonicalDate
        else {
            return false
        }
        
        return canonicalDate.isSame(as: today)
    }
}

// MARK: Date Determination Operations
public extension Date {
    var numberOfDayOfTheWeekStartingAtSunday: Int? {
        let weekDayComponents = DateUtilities.supportedCalendar.dateComponents([.weekday], from:self)
        
        // Note: 1 is Sunday. Day numbers increment from there. So Sunday = 1, Monday = 2, ..., Saturday = 7
        return  weekDayComponents.weekday

    }
    
    static var canonicalToday: Date? {
        today.toCanonicalDate
    }
                
    var dayNumberWithinMonth: Int? {
        let components = DateUtilities.supportedCalendar.dateComponents([.day],from: self)
        let dayOfDateAsNumber = components.day
        
        return dayOfDateAsNumber
    }
    
    var monthNumber: Int? {
        let components = DateUtilities.supportedCalendar.dateComponents([.month],from: self)
        let monthOfDateAsNumber = components.month
        
        return monthOfDateAsNumber
    }
    
    var yearNumber: Int? {
        let components = DateUtilities.supportedCalendar.dateComponents([.year], from: self)
        let yearOfDateAsNumber = components.year
        
        return yearOfDateAsNumber
    }
    
    
    var toCanonicalDate: Date? {
        sameDateAtSpecificTime(atHour: DateUtilitiesConstant.canonicalHour.rawValue,
                               atMinute: DateUtilitiesConstant.canonicalMinute.rawValue,
                               atSecond: DateUtilitiesConstant.canonicalSecond.rawValue)
    }
    
    var nextDay: Date? {
        shiftedToTheFuture(by: 1)
    }
    
    var previousDay: Date? {
        shiftedToThePast(by: 1)
    }
        
    static var yesterday: Date? {
        today.previousDay
    }
    
    static var today: Date {
       now
    }
    
    static var now: Date {
        Date()
    }
    
    static var tomorrow: Date? {
        today.nextDay
    }

    
    var startOfDay: Date? {
        let calendar = DateUtilities.supportedCalendar
        
        let calendarUnitFlags: Set<Calendar.Component> = [.year,.month,.day]
        
        let dateComponents = calendar.dateComponents(calendarUnitFlags, from: self)
        
        return calendar.date(from: dateComponents)
    }
    
    var endOfDay: Date? {
        let startOfNextDay = nextDay?.startOfDay
        
        let endOfDay = startOfNextDay?.addingTimeInterval(-1)
        
        return endOfDay
    }
    
    static func createCanonicalDate(forDay day: Int, month: Int, year: Int) -> Date? {
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        
        comps.hour = tweleve_01_PM.canonicalHour.rawValue
        comps.minute = tweleve_01_PM.canonicalMinute.rawValue
        comps.second = tweleve_01_PM.canonicalSecond.rawValue
        
        let date = DateUtilities.supportedCalendar.date(from: comps)
        
        return date
    }

    func sameDateAtSpecificTime(atHour newHour: Int, atMinute newMinute: Int, atSecond newSecond: Int) -> Date? {
        let calendar = DateUtilities.supportedCalendar
        
        let calendarUnitFlags: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        var dateTimeComponents = calendar.dateComponents(calendarUnitFlags, from: self)
        
        dateTimeComponents.hour = newHour
        dateTimeComponents.minute = newMinute
        dateTimeComponents.second = newSecond
        
        let dateAtSpecifiedTime = calendar.date(from: dateTimeComponents)
        
        return dateAtSpecifiedTime
    }
    
    func offSet(_ offset: Int) -> Date? {
        
        // The complexities of the below are as a result of the paculiarities of Day Light Savings Time. The below will reliably give the next day at the same time in any timezone (retrieved from WWDC 2012 - Session 304 Event kit talk)
        
        let calendar = DateUtilities.supportedCalendar
        var oneDayComponents = DateComponents()
        oneDayComponents.day = offset
        
        guard
            let offSetDate = calendar.date(byAdding: oneDayComponents, to: self)
        else {
            return nil
        }
        
        let unitFlags: Set<Calendar.Component> = [.era, .year, .month, .day]
        
        var offSetDateComponentsAtSameTime = calendar.dateComponents(unitFlags, from: offSetDate)
        let dateTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        offSetDateComponentsAtSameTime.hour = dateTimeComponents.hour
        offSetDateComponentsAtSameTime.minute = dateTimeComponents.minute
        offSetDateComponentsAtSameTime.second = dateTimeComponents.second
        
        let offSetDateAtSameTime = calendar.date(from: offSetDateComponentsAtSameTime)
        
        return offSetDateAtSameTime
    }
    
    func shiftedToTheFuture(by numberOfDays: Int) -> Date? {
        offSet(numberOfDays)
    }

    func shiftedToThePast(by numberOfDays: Int) -> Date? {
        offSet((-1 * numberOfDays))
    }
    
    static func differenceInDays(between startDate: Date, and endDate: Date) -> Int? {
        DateUtilities.supportedCalendar.dateComponents([.day], from: startDate, to: endDate).day
    }

}

public extension Month {
    
    func retrieveNumberOfDaysInMonth(forYear year: Int) -> Int {
        if (self == .february) && Date.isLeapYear(year) {
            return 29
        }

        switch self {
        case .january,.march,.may,.july,.august,.october,.december:
            return 31
        case .february:
            return 28
        case .april, .june, .september, .november:
            return 30
        }
    }
    
    var name: String {
        let arbitraryYear = 2000, arbitraryDay = 1
        
        guard
            let dateForMonth = Date.createCanonicalDate(forDay: arbitraryDay,
                                                        month: self.rawValue,
                                                        year: arbitraryYear)
        else {
            return ""
        }
        
        return dateForMonth.monthDescription
    }
        
    var numberOfDaysInMonthForCurrentYear: Int?
    {
        let calendar = DateUtilities.supportedCalendar
        
        let unitFlags: Set<Calendar.Component> = [.era, .year, .month, .day]
        
        let dateComponents = calendar.dateComponents(unitFlags, from: Date.today)
        
        guard
            let year = dateComponents.year,
            let date = Date.createCanonicalDate(forDay: 1, month: self.rawValue, year: year)
        else {
            return nil
        }
        
        let dayRange = calendar.range(of: .day, in: .month, for: date)
        
        let numberOfDaysInMonth = dayRange?.count
        
        return numberOfDaysInMonth;
    }
    
    func numberOfWeeksInMonth(inYear year: Int, startingAtDayNumber startDayNumber: Int) -> Int? {
        
        guard
            let startDate = Date.createCanonicalDate(forDay: startDayNumber, month: self.rawValue, year: year),
            let dayOfWeek: Int = startDate.numberOfDayOfTheWeekStartingAtSunday // One based. That is Sunday = 1
        else {
            return nil
        }
        
        let numberOfTotalPossibleDays = self.retrieveNumberOfDaysInMonth(forYear: year)
        
        let numberOfDaysInAWeek = 7;
        
        let numberOfDaysInFirstWeek = (numberOfDaysInAWeek - dayOfWeek + 1)
        
        let numberOfRemainingDaysInMonth: Int
        let numberOfWeeksAfterTheFirstWeek: Double
        
        if numberOfTotalPossibleDays > numberOfDaysInFirstWeek {
            
            numberOfRemainingDaysInMonth = numberOfTotalPossibleDays - numberOfDaysInFirstWeek;
            numberOfWeeksAfterTheFirstWeek = ceil(Double(numberOfRemainingDaysInMonth) / Double(numberOfDaysInAWeek));
            
        } else {
            
            numberOfRemainingDaysInMonth = numberOfTotalPossibleDays;
            numberOfWeeksAfterTheFirstWeek = 0;
            
        }
        
        let numberOfWeeksInMonth = Int(numberOfWeeksAfterTheFirstWeek + 1.0)
        
        return numberOfWeeksInMonth
    }
}

public struct DateRange {
    let startDate: Date
    let endDate: Date
    
    init?(startDate: Date, endDate: Date) {
        // startDate must be <= endDate
        guard startDate.isLess(than: endDate) || startDate == endDate else {
            return nil
        }
        
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension DateRange {
    static var today: DateRange? {
        let today = Date.today
        return DateRange(startDate: today, endDate: today)
    }
    
    static let allHistory: DateRange? = DateRange(startDate: .distantPast, endDate: .today)
    
    static func daysOfHistory(count: Int, including endDate: Date) -> DateRange? {
        guard count >= 0 else {
            return nil
        }
        
        guard count > 0 else {
            return DateRange(startDate: endDate, endDate: endDate)
        }
        
        guard let startDate = endDate.shiftedToThePast(by: count - 1) else {
            return nil
        }
        
        return DateRange(startDate: startDate, endDate: endDate)
    }
    
    #warning("Write unit tests for numberOfDaysBetweenInclusive, numberOfDaysBetweenExclusive")
    var numberOfDaysBetweenInclusive: Int? {
        guard
            let normalizedStart = startDate.startOfDay,
            let normalizedEnd = endDate.startOfDay,
            let numberOfDays =
                DateUtilities.supportedCalendar.dateComponents([.day],
                                                               from: normalizedEnd,
                                                               to: normalizedStart).day
        else {
            return nil
        }
        
         return numberOfDays + 1
    }
    
    var numberOfDaysBetweenExclusive: Int? {
        guard let numberOfDaysBetweenInclusive = numberOfDaysBetweenInclusive else {
            return nil
        }
        
        switch numberOfDaysBetweenInclusive {
        
        case 0, 1:
            return numberOfDaysBetweenInclusive
        
        default:
            return numberOfDaysBetweenInclusive - 2
        }
    }
}
