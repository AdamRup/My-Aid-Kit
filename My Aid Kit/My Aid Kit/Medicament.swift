//
//  Medicament.swift
//  My Aid Kit
//
//  Created by Adam Rup on 09/06/2019.
//  Copyright © 2019 Adam Rup. All rights reserved.
//

import Foundation

class Medicament: NSObject, Codable{
    var itemID = -1
    var name: String = ""
    var numberOfPillsInBox: Int = 0
    var currentNumberOfPillsInBox: Int = 0
    var expiryDate: Date = Date()
    var shouldRemind = false
    
    func lessThanTenPercentOfTheBox(_ fullnumber: Int,_ currNumber: Int){
        if currNumber <= (fullnumber/10){
            print("Masz mniej niż 10% zawartości opakowania: \(currNumber). Kup nowe :)")
        } else {
            print("jestem w chuj dobrze zaopatrzony")
        }
    }
    
    func hasTheMedicamentValidExpiryDate(_ expiryDate: Date){
        let isDateValid = Date().compare(expiryDate)
        if isDateValid == ComparisonResult.orderedAscending{
            print("jest jeszcze ważne")
        } else {
            print("po terminie kup nowe tabsy :p")
        }
    }
}
