//
//  MoneyManagerTests.swift
//  MoneyManagerTests
//
//  Created by Roman on 07.01.2021.
//

import XCTest
@testable import TheWallet

class TheWalletTests: XCTestCase {

    var sut: VCMain!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = VCMain()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testReturnDayOfDate() throws {
        // 1. given
        let date = Date.init(timeIntervalSince1970: 1681057901)
        print("date1 = \(date.description)")

        // 2. when
        let result = sut.returnDayOfDate(date)

        // 3. then
        XCTAssertEqual(result, "9 April 2023", "Error test. Result= \(result)")
    }

}
