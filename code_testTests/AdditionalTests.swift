//
//  AdditionalTests.swift
//  code_testTests
//
//  Created by Thinzar Soe on 9/4/22.
//

import XCTest
@testable import code_test

class AdditionalTests:XCTestCase{
    
    func testfibonacciNumbers(){
        let finbonancciArray = [0, 1, 1, 2, 3, 5, 8, 13]
        let testArray = Additional.shared.getFibonacciNumbers(num: 8)
        XCTAssertEqual(finbonancciArray, testArray)
    }
    
    func testPrimesNumbers(){
        let primesNumbersArray = [2, 3, 5, 7, 11, 13, 17, 19]
        let testArray = Additional.shared.getPrimeNumbers(endNumber: 20)
        XCTAssertEqual(primesNumbersArray, testArray)
    }
    
    func testFilterArray(){
        let firstArray = [2, 3, 5, 7]
        let secondArray = [7, 6, 1 , 0, 6, 5 , 56, 89, 21]
        let remainingArray = [6, 1, 0,6,56,89,21]
        let testArray = Additional.shared.filterArray(firstArray: firstArray, secondArray: secondArray)
        XCTAssertEqual(remainingArray, testArray)
    }
}
