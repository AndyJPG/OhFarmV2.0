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
    @IBOutlet weak var containerView: UIView!
    
    var orignalIndoor = 0
    var orignalOutdoor = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "\(plant.cropName) Checklist"
        
        //Appearance
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        
        orignalIndoor = plant.indoorList
        orignalOutdoor = plant.outdoorList
        
//        print(plant.indoorList)
//        print(plant.outdoorList)
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
    
    //Back button action also save the modified plant
    @IBAction func backButton(_ sender: Any) {
//        print(orignalIndoor)
//        print(orignalOutdoor)
//        
//        print(plant.indoorList)
//        print(plant.outdoorList)
        
        performSegue(withIdentifier: "unwindFromCheckList", sender: self)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        resetConfirmation()
    }
    
    
}

//UI Alert
extension CheckListHolderViewController {
    
    //MARK: Delete pop up confirmation
    private func resetConfirmation() {
        
        let alert = UIAlertController(title: "Reset Checklist", message: "Are you sure you want to reset everything ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.plant.indoorList = -1
            self.plant.outdoorList = -1
            self.plant.harvestDate = Date()
            self.plant.nextWateringDate = Date()
            self.plant.harvested = false
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (_) in
            print("Delete dismiss")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
}
