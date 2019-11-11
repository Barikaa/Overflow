//
//  StackoverflowTests.swift
//  StackoverflowTests
//
//  Created by Kalló Barbara on 2019. 10. 16..
//  Copyright © 2019. Kalló Barbara. All rights reserved.
//

import XCTest
@testable import Stackoverflow

class StackoverflowTests: XCTestCase {

    var sut: QuestionsTableViewController!
    
    override func setUp() {
        sut = QuestionsTableViewController()
    }

    override func tearDown() {
        sut = nil
    }
    
    func test1() {
        let url = sut.createURL(for: "javascript", page: 1)
        XCTAssertEqual(url, "https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&tagged=javascript&site=stackoverflow")
    }

}
