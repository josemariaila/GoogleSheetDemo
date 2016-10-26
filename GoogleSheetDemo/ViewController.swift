//
//  ViewController.swift
//  GoogleSheetDemo
//
//  Created by José María Ila on 25/10/16.
//  Copyright © 2016 Vector Mobile. All rights reserved.
//

import GoogleAPIClientForREST
import GTMOAuth2
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let kKeychainItemName = "Google Sheets API"
    private let kClientID = "CLIENT_ID"
    private let kSpreadsheetID = "SPREADSHEET_ID"
    private let kRange = "SPREADSHEET_RANGE"
    private let kValueInputOption = "RAW"
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets, kGTLRAuthScopeSheetsDrive]
    private let service = GTLRSheetsService()
    
    // MARK: - View management
    
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeychainItemName, clientID: kClientID, clientSecret: nil) {
            service.authorizer = auth
        }
    }
    
    /**
     Notifies the view controller that its view was added to a view hierarchy.
     
     - parameter animated: If true, the view was added to the window using an animation.
     */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let data: [[AnyObject]] = [["Row 1", "Row 1"], ["Row 2", "Row 2"], ["Row 3", "Row 3"], ["Row 4", "Row 4"], ["Row 5", "Row 5"]]
        
        if let authorizer = service.authorizer, canAuth = authorizer.canAuthorize where canAuth {
            writeData(data)
            
        } else {
            presentViewController(createAuthController(), animated: true, completion: nil)
        }
    }
    
    // MARK: - Spreadsheet methods
    
    /**
     Reads data from sample spreadsheet
     https://docs.google.com/spreadsheets/d/1EVnXU42R6-H4aTwlUEdF4m8keA_nE8wgIRG6ffA2pjU/edit
     */
    func readData() {
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.queryWithSpreadsheetId(kSpreadsheetID, range:kRange)
        service.executeQuery(query, delegate: self, didFinishSelector: #selector(ViewController.displayResultWithTicket(_:finishedWithObject:error:)))
    }
    
    /**
     Writes data in sample spreadsheet
     https://docs.google.com/spreadsheets/d/1EVnXU42R6-H4aTwlUEdF4m8keA_nE8wgIRG6ffA2pjU/edit
     */
    func writeData(data: [[AnyObject]]) {
        
        let valueRange = GTLRSheets_ValueRange.init();
        valueRange.values = data
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.queryWithObject(valueRange, spreadsheetId:kSpreadsheetID, range:kRange)
        query.valueInputOption = kValueInputOption
        service.executeQuery(query, delegate: self, didFinishSelector: #selector(ViewController.displayResultWithTicket(_:finishedWithObject:error:)))
    }
    
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        
        let scopeString = scopes.joinWithSeparator(" ")
        let authController = GTMOAuth2ViewControllerTouch(scope: scopeString, clientID: kClientID, clientSecret: nil, keychainItemName: kKeychainItemName, delegate: self, finishedSelector: #selector(ViewController.viewController(_:finishedWithAuth:error:)))
        
        return authController
    }
    
    // MARK: - Alert methods.
    
    func showAlert(title : String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let success = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(success)
        presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - ViewController Delegate methods

extension ViewController {
    
    func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
    }
    
    func viewController(vc: UIViewController, finishedWithAuth authResult: GTMOAuth2Authentication, error: NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
}
