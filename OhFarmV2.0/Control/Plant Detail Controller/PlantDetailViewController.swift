//
//  PlantDetailViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlantDetailViewController: UIViewController {
    
    // MARK: Variable
    var plant: Plant?
    @IBOutlet weak var plantImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if plant == nil {
            fatalError("Plant can not be nil")
        }
        
        navigationItem.title = plant?.cropName
        plantImage.image = plant?.plantImage
        plantImage.contentMode = .scaleAspectFill
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            guard let containerVC = segue.destination as? PlantInfoSlideViewController else {fatalError()}
            containerVC.plant = plant
            print("data passed")
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
