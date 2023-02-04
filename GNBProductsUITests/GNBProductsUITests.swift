//
//  GNBProductsUITests.swift
//  GNBProductsUITests
//
//  Created by Joaquín Corugedo Rodríguez on 4/2/23.
//

import XCTest

final class GNBProductsUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialTableEmptyAndTotalText() {
        
        
        XCTAssert(app.staticTexts["Total: 0 €"].exists)
        XCTAssert(app.tables.cells.count == 0)
    }
    
    func testDifferenteSelectionInPicker() {
        
        //When
        app.pickers.element.firstMatch.swipeUp()
        
        
        //Then
        XCTAssert(!app.staticTexts["Total: 0 €"].exists) // El texto con valor total 0 ha cambiado
        XCTAssert(app.tables.cells.count > 0) // La tabla contiene celdas
    }

}
