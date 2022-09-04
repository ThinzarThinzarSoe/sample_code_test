//
//  Additional.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import Foundation

open class Additional {
    
    private init() {}
    static let shared : Additional = Additional()
    
    func getFibonacciNumbers(num: Int) -> [Int] {
        
        var fibonacciSeriesArray = [Int]()
        
        var number1 = 0
        var number2 = 1
        var nextNumber = 0
        
        fibonacciSeriesArray.append(number1)
        fibonacciSeriesArray.append(number2)

        for _ in 0..<num {
            nextNumber = number1 + number2
            number1 = number2
            number2 = nextNumber
            fibonacciSeriesArray.append(number2)
        }
       return fibonacciSeriesArray
    }
    
    func checkingPrimeNumber(num: Int) -> Bool{
       if(num == 1 || num == 0){
          return false
       }
       for j in 2..<num{
          if (num % j == 0){
             return false
          }
       }
       return true
    }
    
    func getPrimeNumbers(endNumber: Int) -> [Int] {
        var primesNumbersArray = [Int]()
        for k in 1...endNumber {
            if checkingPrimeNumber(num: k) {
                primesNumbersArray.append(k)
            }
        }
        return primesNumbersArray
    }
    
    func filterArray(firstArray : [Int] , secondArray : [Int]) -> [Int] {
        var remaingArray = secondArray
        firstArray.forEach { firstItem in
            for k in 0...secondArray.count {
                if firstItem == secondArray[k] {
                    remaingArray.remove(at: k)
                }
            }
        }
        return remaingArray
    }
}


