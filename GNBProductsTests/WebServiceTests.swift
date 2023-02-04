//
//  WebServiceTests.swift
//  GNBProductsTests
//
//  Created by Joaquín Corugedo Rodríguez on 31/1/23.
//

import XCTest
@testable import GNBProducts

enum ErrorMock: Error {
    case mockCase
}

final class WebServiceTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: WebService!

    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        sut = WebService(session: urlSessionMock)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGetRatesSuccess() {
        var error: NetworkError?
        var retrievedRates: [Rate]?
        
        //Given
        urlSessionMock.data = getData(resourceName: "rates")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getRates { rates, networkError in
            error = networkError
            retrievedRates = rates
        }
        
        //Then
        XCTAssertEqual(retrievedRates?.first?.from, "EUR")
        XCTAssertNil(error, "There should be no error")
    }
    
    func testGetRatesWithError() {
        var error: NetworkError?
        var retrievedRates: [Rate]?
        
        //Given
        urlSessionMock.data = nil
        urlSessionMock.error = ErrorMock.mockCase
        
        //When
        
        sut.getRates { rates, networkError in
            error = networkError
            retrievedRates = rates
        }
        
        //Then
        XCTAssertEqual(retrievedRates, [], "Rates should be nil")
        XCTAssertEqual(error, .other)
    }

}

extension WebServiceTests {
    
    func getData(resourceName: String) -> Data? {
        let bundle = Bundle(for: WebServiceTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
