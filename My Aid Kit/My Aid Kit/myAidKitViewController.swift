//
//  ViewController.swift
//  My Aid Kit
//
//  Created by Adam Rup on 08/06/2019.
//  Copyright © 2019 Adam Rup. All rights reserved.
//

import UIKit

class myAidKitViewController: UITableViewController, AddMedicamentViewControllerDelegate {
    func addMedicamentViewControllerDidCancel(_ controller: AddMedicamentViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addMedicamentViewController(_ controller: AddMedicamentViewController, didFinishAdding med: Medicament) {
        let newRowIndex = medicamentsTable.count
        medicamentsTable.append(med)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        saveMedicament()
    }
    
    func addMedicamentViewController(_ controller: AddMedicamentViewController, didFinishEditing med: Medicament) {
        if let index = medicamentsTable.firstIndex(of: med){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: med)
            }
        }
        navigationController?.popViewController(animated: true)
        saveMedicament()
    }
    
    var medicamentsTable = [Medicament]() // zmienna tablicowa zawierająca leki (zmienna bo może być rozszerzana i pomniejszana)
    
    //Mark:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMed"{
            let controller = segue.destination as! AddMedicamentViewController
            controller.delegate = self
        } else if segue.identifier == "EditMed" {
            let controller = segue.destination as! AddMedicamentViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.medToEdit = medicamentsTable[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(documentsDirectory())
        loadMedicaments()
    }
    

    //Mark:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                               numberOfRowsInSection section: Int) -> Int {
        return medicamentsTable.count //wyświetla ilość wierszy
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell( //zadeklarowanie komórki
                withIdentifier: "Medicament",   //jeśli nosi identyfikator "Medicanent"
                for: indexPath) //dla indexu
            let med = medicamentsTable[indexPath.row] //stała określająca komurkę w tabeli z lekami
            configureText(for: cell, with: med)
            return cell //zwraca komórkę
    }
    
    //Mark:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        medicamentsTable.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveMedicament()
    }
    
    func configureText(for cell: UITableViewCell,
                       with med: Medicament) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = med.name
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Medicaments.plist")
    }
    
    func saveMedicament(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(medicamentsTable)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadMedicaments(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do {
                medicamentsTable = try decoder.decode([Medicament].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}

