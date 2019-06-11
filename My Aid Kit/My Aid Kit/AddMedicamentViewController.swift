//
//  AddMedicamentViewController.swift
//  My Aid Kit
//
//  Created by Adam Rup on 09/06/2019.
//  Copyright © 2019 Adam Rup. All rights reserved.
//

import UIKit

protocol AddMedicamentViewControllerDelegate: class {
    func addMedicamentViewControllerDidCancel(_ controller: AddMedicamentViewController)
    func addMedicamentViewController(_ controller: AddMedicamentViewController,
                                     didFinishAdding med: Medicament)
    func addMedicamentViewController(_ controller: AddMedicamentViewController,
                                     didFinishEditing med: Medicament)
}

class AddMedicamentViewController: UITableViewController, UITextFieldDelegate {

    //Mark:- Outlets
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var numOfPillsField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var expiryDatePicker: UIDatePicker!
    
    @IBOutlet weak var currentNumOfPillsField: UITextField!
    
    weak var delegate: AddMedicamentViewControllerDelegate?
    
    var medToEdit: Medicament?
    
    //Mark:- Actions
    @IBAction func done(){
        if let med = medToEdit {
            med.name = textField.text!
            med.numberOfPillsInBox = (numOfPillsField.text! as NSString).integerValue
            med.currentNumberOfPillsInBox = (currentNumOfPillsField.text! as NSString).integerValue
            med.expiryDate = expiryDatePicker.date
            delegate?.addMedicamentViewController(self, didFinishEditing: med)
        } else {
            let med = Medicament()
            med.name = textField.text!
            med.numberOfPillsInBox = (numOfPillsField.text! as NSString).integerValue
            med.currentNumberOfPillsInBox = (currentNumOfPillsField.text! as NSString).integerValue
            med.expiryDate = expiryDatePicker.date
            delegate?.addMedicamentViewController(self, didFinishAdding: med)
        }
    }
    
    @IBAction func cancel(){
        delegate?.addMedicamentViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let med = medToEdit {
            title = "Edit Med"
            textField.text = med.name
            numOfPillsField.text = String(med.numberOfPillsInBox)
            currentNumOfPillsField.text = String(med.currentNumberOfPillsInBox)
            expiryDatePicker.date = med.expiryDate
            doneBarButton.isEnabled = true
            med.lessThanTenPercentOfTheBox(med.numberOfPillsInBox, med.currentNumberOfPillsInBox)
            med.hasTheMedicamentValidExpiryDate(med.expiryDate)
        }
    }
    
    //Mark:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)

        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func numOfPillsField(_ textField: UITextField,
                         shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) -> Bool {
        let oldNum = numOfPillsField.text!
        let numRange = Range(range, in: oldNum)!
        let newNum = oldNum.replacingCharacters(in: numRange, with: string)

        if newNum.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}


