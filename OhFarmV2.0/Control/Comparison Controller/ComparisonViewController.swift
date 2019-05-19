//
//  ComparisonViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 11/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class ComparisonViewController: UIViewController {
    
    //MARK: Variable
    var compareList: [Plant]!
    var userFarm: [Plant]!
    var itemsPerRow: CGFloat = 4
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    
    //Check box tracking
    var checkTracker = [Int]()
    
    //Get button for add plant
    let button = SearchPlantUI().filterBottomButton()
    let buttonBackground = SearchPlantUI().filterBottomButtonBackground()
    
    //Cell id
    enum cellID: String {
        case PhotoCell
        case ValueCell
        case CheckBoxCell
    }
    
    //Segue id
    enum segueID: String {
        case compareToSearchSegue
    }
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsPerRow = CGFloat(compareList.count+1)
        checkTracker = Array(repeating: 0, count: Int(itemsPerRow)-1)
        
        // Set up collection view delegate
        collection.delegate = self
        collection.dataSource = self
        
        //setup add plant button
        setupAddPlantButton()
        
        navigationItem.title = "Comparison"
        
        //Back ground
        let background = UIImageView(image: UIImage(named: "background"))
        background.contentMode = .scaleAspectFill
        collection.backgroundView = background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //MARK: Actions
    @objc private func checkBox(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            checkTracker[sender.tag] = 1
        } else {
            checkTracker[sender.tag] = 0
        }
        
        print(checkTracker)
        
    }
    
    //add plant button
    @objc private func addPlant(_ sender: UIButton) {
        
        //Check if any plant selected
        if !checkTracker.contains(1) {
            notPlantAlert()
        } else {
            var existList = Array(repeating: 0, count: Int(itemsPerRow)-1)
            
            let farmPlants = userFarm.map { (plant) -> String in
                return plant.cropName
            }
            
            let comparePlants = compareList.map { (plant) -> String in
                return plant.cropName
            }
            //Check if there is any plant exist in the user farm
            for name in farmPlants {
                if let index = comparePlants.firstIndex(of: name) {
                    if checkTracker[index] == 1 {
                        existList[index] = 2
                    }
                }
            }
            
            //From notification
            var existPlants = ""
            var addPlants = ""
            var addPlantsList = [Plant]()
            
            for (index,value) in checkTracker.enumerated() {
                if existList[index] == 2 {
                    existPlants += "\(compareList[index].cropName), "
                }
                
                if value == 1 && existList[index] != 2 {
                    addPlants += "\(compareList[index].cropName), "
                    addPlantsList.append(compareList[index])
                }
            }
            
            //Perform alert
            addPlantAlert(existPlants, addPlants, plantList: addPlantsList)
        }
        
        print(checkTracker)
    }

}

//MARK: Collection view delegate
extension ComparisonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(itemsPerRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.ValueCell.rawValue, for: indexPath)
        
        //Detect different type cell
        switch indexPath.section {
        case 0:
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.PhotoCell.rawValue, for: indexPath) as? PlantPhotoCollectionViewCell else {fatalError()}
            
            //If indexPath row is 0 that it will become row title
            if indexPath.row == 0 {
                photoCell.plantImage.isHidden = true
                photoCell.plantName.text = "Plant"
                photoCell.plantName.textColor = color
            } else {
                let plant = compareList[indexPath.row-1]
                let imageURL = plant.plantImageURL
                photoCell.plantImage.downloaded(from: imageURL[0])
                photoCell.plantName.text = plant.cropName
            }
            
            return photoCell
            
        case 1,2,3,4:
            guard let valueCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.ValueCell.rawValue, for: indexPath) as? PlantValueCollectionViewCell else {fatalError()}
            
            //Column name array
            let columnName = ["","Plant Spacing","Harvest Time","Number of compatible plants","Location","Select"]
            
            var plant: Plant {
                if indexPath.row > 0 {
                    return compareList[indexPath.row-1]
                }
                return compareList[0]
            }
            
            //If the cell is the end or the beginning right bar with no color
            if indexPath.row == Int(itemsPerRow)-1 || indexPath.row == 0 {
                valueCell.rightBar.backgroundColor = .clear
            }
            
            if indexPath.row == 0 {
                valueCell.topBar.backgroundColor = .white
            }
            
            //If index path row is 0 that it will become row title
            
            if indexPath.row == 0 {
                valueCell.backgroundColor = color
                valueCell.value.text = columnName[indexPath.section]
                valueCell.value.textColor = .white
            } else {
                //Follow switch detact which information to take
                switch indexPath.section {
                case 1:
                    //Plant spacing information
                    if plant.minSpacing == plant.maxSpacing {
                        valueCell.value.text = "\(plant.minSpacing) cm"
                    } else {
                        valueCell.value.text = "\(plant.minSpacing) cm\nto\n\(plant.maxSpacing) cm"
                    }
                case 2:
                    //Plant harvest time information
                    if plant.minHarvestTime == plant.maxHarvestTime {
                        valueCell.value.text = "\(plant.minHarvestTime) weeks"
                    } else {
                        valueCell.value.text = "\(plant.minHarvestTime) weeks\nto\n\(plant.maxHarvestTime) weeks"
                    }
                case 3:
                    //Number of compatible plants
                    valueCell.value.text = "\(plant.getCompatiable.count)"
                case 4:
                    //Location
                    valueCell.value.text = plant.plantStyle.capitalized
                default: break
                }
            }
            
            return valueCell
        case 5:
            guard let checkBoxCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.CheckBoxCell.rawValue, for: indexPath) as? PlantCheckBoxCollectionViewCell else {fatalError()}
            
            //If the cell is the end or the beginning right bar with no color
            if indexPath.row == Int(itemsPerRow)-1 || indexPath.row == 0 {
                checkBoxCell.rightBar.backgroundColor = .clear
            }
            
            if indexPath.row == 0 {
                checkBoxCell.topBar.backgroundColor = .white
            }
            
            //if index path row equal 0 set it to be title
            if indexPath.row == 0 {
                checkBoxCell.checkBox.isHidden = true
                checkBoxCell.checkBoxLabel.text = "Select"
                checkBoxCell.checkBoxLabel.textColor = color
            } else {
                checkBoxCell.checkBoxLabel.isHidden = true
                checkBoxCell.checkBox.tag = indexPath.row-1
                checkBoxCell.checkBox.addTarget(self, action: #selector(checkBox(_:)), for: .touchUpInside)
            }
            return checkBoxCell
            
        default: break
        }
        
        return cell
    }
    
}

//MARK: flow layout delegate
extension ComparisonViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: custom collection cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / itemsPerRow
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: width*1.5)
        }
        
        if indexPath.section == 5 || indexPath.section == 4 {
            return CGSize(width: width, height: width*0.5)
        }
        
        return CGSize(width: width, height: width*0.8)
    }
    
    //Set up line spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Set up interItem spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 5 {
            return CGSize(width: 0, height: 60)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView,   viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath as IndexPath)

            return footer
            
        default:
            
            print("anything")
        }
        
        return UICollectionReusableView()
    }
    
}

//MARK: UI aler
extension ComparisonViewController {
    
    //notify when add plant
    private func addPlantAlert(_ existPlants: String, _ addPlants: String, plantList: [Plant]) {
        var alert = UIAlertController()
        
        if addPlants.isEmpty && !existPlants.isEmpty {
            alert = UIAlertController(title: "Plants exist", message: "\(existPlants)are already in your farm", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            if existPlants.isEmpty {
                alert = UIAlertController(title: "Plants added", message: "You have added \(addPlants)to your farm", preferredStyle: UIAlertController.Style.alert)
            } else {
                alert = UIAlertController(title: "Plants added", message: "You have added \(addPlants)to your farm, and \(existPlants)are already in your farm", preferredStyle: UIAlertController.Style.alert)
            }
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
                self.compareList = plantList
                self.performSegue(withIdentifier: segueID.compareToSearchSegue.rawValue, sender: self)
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    //Notify your if they dont have anything checked
    private func notPlantAlert() {
        let alert = UIAlertController(title: "No plant selected", message: "Please select a plant first", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel action
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Appearance
extension ComparisonViewController {
    
    private func setupAddPlantButton() {
        button.setTitle("Add plants", for: .normal)
        button.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
        view.addSubview(buttonBackground)
        view.addSubview(button)
        
        UIView.animate(withDuration: 0.5) {
            self.button.alpha = 0
            self.button.alpha = 1
        }
        
    }
    
}
