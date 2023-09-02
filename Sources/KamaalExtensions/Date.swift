//
//  Date.swift
//
//
//  Created by Kamaal Farah on 23/10/2020.
//

import Foundation

extension Date {
    public enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case faturday = 7
    }

    public var asNSDate: NSDate {
        self as NSDate
    }

    public var dayNumberOfWeek: Int {
        Calendar.current.component(.day, from: self)
    }

    public var weekNumber: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }

    public var yearNumber: Int {
        Calendar.current.component(.yearForWeekOfYear, from: self)
    }

    /// Is any day before today
    public var isBeforeToday: Bool {
        let selfDate = self
        let today = Date()
        return (selfDate.dayNumberOfWeek < (today.dayNumberOfWeek) || selfDate.weekNumber < today.weekNumber) &&
            selfDate.yearNumber == today.yearNumber
    }

    /// Is tomorrow
    public var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    /// Is yesterday
    public var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    public var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }

    public var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }

    public func getFormattedDateString(withFormat format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }

    public func nextDays(till amountOfDays: Int, offset: Int = 0) -> [Date] {
        guard amountOfDays > 0,
              let date = Calendar.current.date(byAdding: .day, value: offset, to: self) else { return [] }
        return (0 ..< amountOfDays).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: date)
        }
    }

    public func datesOfWeek(weekOffset: Int = 0) -> [Date] {
        var dates = [Date]()
        for index in 1 ... 7 {
            if let weekday = Weekday(rawValue: index) {
                let date = dateOfWeek(weekday: weekday, weekOffset: weekOffset)
                dates.append(date)
            }
        }
        return dates
    }

    public func adding(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    @available(OSX 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    public func toIsoString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter.string(from: self)
    }

    public func isFromSameWeek(as date: Date) -> Bool {
        let selfDate = self
        return selfDate.weekNumber == date.weekNumber && selfDate.yearNumber == date.yearNumber
    }

    public func isFutureWeek(from date: Date) -> Bool {
        let selfDate = self
        if selfDate.yearNumber != date.yearNumber {
            return selfDate.yearNumber > date.yearNumber
        }
        return selfDate.weekNumber > date.weekNumber
    }

    public func isSameDay(as date: Date) -> Bool {
        let selfDate = self
        return selfDate.dayNumberOfWeek == date.dayNumberOfWeek
            && selfDate.weekNumber == date.weekNumber
            && selfDate.yearNumber == date.yearNumber
    }

    public func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        date1.compare(self) == compare(date2)
    }
}

extension Date {
    func dateOfWeek(weekday targetDayOfWeek: Weekday, weekOffset: Int = 0) -> Date {
        var selfDate = self
        let weekInterval = self.intervalByDays(days: weekOffset * 7)
        selfDate.addTimeInterval(weekInterval)

        let formattor = DateFormatter()
        formattor.timeZone = TimeZone.current
        formattor.dateFormat = "e"

        if let selfDayOfWeek = Int(formattor.string(from: selfDate)) {
            let interval_days = targetDayOfWeek.rawValue - selfDayOfWeek
            let interval = self.intervalByDays(days: interval_days)
            selfDate.addTimeInterval(interval)
            return selfDate
        }

        return selfDate
    }

    func intervalByDays(days: Int) -> TimeInterval {
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let hoursPerDay = 24
        return TimeInterval(days * hoursPerDay * minutesPerHour * secondsPerMinute)
    }
}
