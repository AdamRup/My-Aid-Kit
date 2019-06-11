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
    func addMedicamentViewController(_ controller: AddMedicamentViewController, didFinishAdding med: Medicament)
    func addMedicamentViewController(_ controller: AddMedicamentViewController, didFinishEditing med: Medicament)
}

class AddMedicamentViewController: UITableViewController, UITextFieldDelegate {

    //Mark:- Outlets
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var numOfPillsField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var expiryDatePicker: UIDatePicker!
    
    @IBOutlet weak var currentNumOfPillsField: UITextField!
    
    weak var delegate: AddMedicamentViewControllerDelegate?
    
    var medicamentToEdit: Medicament?
    
    //MARK:- Actions
    @IBAction func done(){
        if let medicament = medicamentToEdit {
            medicament.name = textField.text!
            medicament.numberOfPillsInBox = (numOfPillsField.text! as NSString).integerValue
            medicament.currentNumberOfPillsInBox = (currentNumOfPillsField.text! as NSString).integerValue
            medicament.expiryDate = expiryDatePicker.date
            delegate?.addMedicamentViewController(self, didFinishEditing: medicament)
        } else {
            let medicament = Medicament()
            medicament.name = textField.text!
            medicament.numberOfPillsInBox = (numOfPillsField.text! as NSString).integerValue
            medicament.currentNumberOfPillsInBox = (currentNumOfPillsField.text! as NSString).integerValue
            medicament.expiryDate = expiryDatePicker.date
            delegate?.addMedicamentViewController(self, didFinishAdding: medicament)
        }
    }
    
    @IBAction func cancel(){
        delegate?.addMedicamentViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let medicament = medicamentToEdit {
            title = "Edit Med"
            textField.text = medicament.name
            numOfPillsField.text = String(medicament.numberOfPillsInBox)
            currentNumOfPillsField.text = String(medicament.currentNumberOfPillsInBox)
            expiryDatePicker.date = medicament.expiryDate
            doneBarButton.isEnabled = true
            medicament.lessThanTenPercentOfTheBox(medicament.numberOfPillsInBox, medicament.currentNumberOfPillsInBox)
            medicament.hasTheMedicamentValidExpiryDate(medicament.expiryDate)
        }
    }
    
    //MARK:- Text Field Delegates
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
