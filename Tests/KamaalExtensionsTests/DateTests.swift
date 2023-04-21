//
//  DateTests.swift
//
//
//  Created by Kamaal Farah on 24/10/2020.
//

#if !os(watchOS)
import XCTest
@testable import KamaalExtensions

final class DateTests: XCTestCase { }

// - MARK: isBeforeToday

extension DateTests { }

// - MARK: isTomorrow

extension DateTests { }

// - MARK: isYesterday

extension DateTests { }

// - MARK: isFromSameWeek

extension DateTests {
    func testIsFromSameWeekIsInSameWeek() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 10, year: 2020)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 23, month: 10, year: 2020)!

        XCTAssert(date1.isFromSameWeek(as: date2))
    }

    func testIsFromSameWeekIsInSameWeekNumberButDiffrentYear() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 10, year: 2020)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 28, month: 10, year: 2021)!

        XCTAssertFalse(date1.isFromSameWeek(as: date2))
    }

    func testIsFromSameWeekIsNotInSameWeek() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 10, year: 2020)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 26, month: 10, year: 2020)!

        XCTAssertFalse(date1.isFromSameWeek(as: date2))
    }
}

// - MARK: isFutureWeek

extension DateTests {
    func testIsFutureWeekIsInLowerWeekNumberButHigherYearNumber() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 1, year: 2021)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 26, month: 10, year: 2020)!

        XCTAssert(date1.isFutureWeek(from: date2))
    }

    func testIsFutureWeek() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 2, year: 2021)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 21, month: 1, year: 2021)!

        XCTAssert(date1.isFutureWeek(from: date2))
    }

    func testIsFutureWeekIsInLowerWeekNumber() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 1, year: 2021)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 21, month: 2, year: 2021)!

        XCTAssertFalse(date1.isFutureWeek(from: date2))
    }

    func testIsFutureWeekIsInLowerYearNumber() {
        let date1 = DateTestsHelpers.createDateFromComponents(day: 23, month: 1, year: 2020)!
        let date2 = DateTestsHelpers.createDateFromComponents(day: 21, month: 2, year: 2021)!

        XCTAssertFalse(date1.isFutureWeek(from: date2))
    }
}

// - MARK: intervalByDays

extension DateTests {
    func testIntervalByDays() {
        let date = DateTestsHelpers.createDateFromComponents(day: 23, month: 2, year: 2021)!
        let intervalByDays = date.intervalByDays(days: 2 * 7)
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let hoursPerDay = 24
        XCTAssertEqual(TimeInterval(2 * 7 * hoursPerDay * minutesPerHour * secondsPerMinute), intervalByDays)
    }
}

// - MARK: DateTestsHelpers

extension DateTests {
    func testCreateDateFromComponents() {
        let date = DateTestsHelpers.createDateFromComponents(day: 23, month: 1, year: 2021)!
        XCTAssertEqual(Calendar.current.component(.day, from: date), 23)
        XCTAssertEqual(Calendar.current.component(.month, from: date), 1)
        XCTAssertEqual(Calendar.current.component(.year, from: date), 2021)
    }
}

enum DateTestsHelpers {
    static func createDateFromComponents(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
}
#endif
