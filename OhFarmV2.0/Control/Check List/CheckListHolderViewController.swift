//
//  CheckListHolderViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 8/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class CheckListHolderViewController: UIViewController {
    
    //MARK: Variable
    var plant: Plant!
    var checkList = [String:[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = plant.cropName
        
        //Appearance
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            guard let cv = segue.destination as? CheckListViewController else {fatalError()}
            cv.plant = self.plant
            cv.checkList = self.checkList
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromCheckList", sender: self)
    }
    
    
}
