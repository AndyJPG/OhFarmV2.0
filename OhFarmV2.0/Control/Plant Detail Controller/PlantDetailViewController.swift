//
//  PlantDetailViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
//import XLPagerTabStrip

class PlantDetailViewController: UIViewController {
    
    enum imageID: String {
        case favourite
        case favouriteFill
    }
    
    enum segueID: String {
        case detailToSearchSegue
    }
    
    // MARK: Variable
    var plant: Plant!
    var user: User!
    var favourite = false
    var slides: [PhotoSlide] = []
    let buttonUI = SearchPlantUI()
    let localData = LocalData()
    
    //Photo slide variable
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var isFromHome =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if plant == nil {
            fatalError("Plant can not be nil")
        }
        
        navigationItem.title = plant?.cropName
        
        scrollView.delegate = self
        
        //Create slides for plant photo
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        if !isFromHome {
            addPlantButtonUI()
        }
        
        setUpAppearance()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // For transport data to slider view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            guard let containerVC = segue.destination as? PlantInfoSlideViewController else {fatalError()}
            containerVC.plant = plant
            containerVC.isFromHome = isFromHome
        }
    }
    
    // MARK: Action
    //Add plant functions for add plant button
    @objc private func addPlant(_ sender: UIButton) {
        if isExist(user.farmPlants) {
            uiAlert(plant.cropName, alertIndex: 0)
        } else {
            let newPlant = plant.copy() as! Plant
            user.farmPlants.insert(newPlant, at: 0)
            localData.saveUserInfo(user)
            uiAlert(plant.cropName, alertIndex: 1)
        }
    }
    
    //Create edge swipe recognizer
    @objc private func screenEdgeSwiped(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //Back button action
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Functions for favourite plant
    //Add favourite plant function
    @IBAction func addToFavourite(_ sender: Any) {
        favourite = !favourite
        
        let plantName = user.favoritePlants.map { (plant: Plant) -> String in
            return plant.cropName
        }
        
        if favourite {
            user.favoritePlants.append(plant)
            localData.saveUserInfo(user)
            favouriteButton.image = UIImage(named: imageID.favouriteFill.rawValue)
            favouriteAlert(plant.cropName, alertIndex: 0)
        } else {
            if let index = plantName.firstIndex(of: plant.cropName) {
                user.favoritePlants.remove(at: index)
                localData.saveUserInfo(user)
            }
            favouriteButton.image = UIImage(named: imageID.favourite.rawValue)
            favouriteAlert(plant.cropName, alertIndex: 1)
        }
    }
    
    //Check if the plant is already exsit
    private func isExist(_ list: [Plant]) -> Bool {
        
        let plantName = list.map { (plant: Plant) -> String in
            return plant.cropName
        }
                
        if plantName.contains(plant.cropName) {
            return true
        } else {
            return false
        }
    }
    
    
    
    // MARK: Appearence
    //Set up appearance for navigation bar
    private func setUpAppearance() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        if isExist(user.favoritePlants) {
            favouriteButton.image = UIImage(named: imageID.favouriteFill.rawValue)
            favourite = true
        }
    }
    
    // Set status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Add plant button ui
    private func addPlantButtonUI() {
        let button = buttonUI.filterBottomButton()
        button.setTitle("Add to My Farm", for: .normal)
        button.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
        view.addSubview(buttonUI.filterBottomButtonBackground())
        view.addSubview(button)
    }
    
}



//MARK: Photo gallery
extension PlantDetailViewController: UIScrollViewDelegate {
    
    //MARK: default fucntion of scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // Plant Photo gallery view
    func createSlides() -> [PhotoSlide] {
        var newSlides = [PhotoSlide]()
        let plantImageURL = plant.plantImageURL
        
        for url in plantImageURL {
            guard let slide: PhotoSlide = Bundle.main.loadNibNamed("PhotoSlide", owner: self, options: nil)?.first as? PhotoSlide else {fatalError()}
            slide.configureWithData(url)
            newSlides.append(slide)
        }
        
        return newSlides
    }
    
    // Set up slide scroll view for segmented section
    func setupSlideScrollView(slides: [PhotoSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 200)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 200)
            scrollView.addSubview(slides[i])
        }
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightText
        view.bringSubviewToFront(pageControl)
    }
}



// MARK: UI alert section
extension PlantDetailViewController {
    
    // MARK: Alert functions
    private func uiAlert(_ plant: String, alertIndex: Int)  {
        if alertIndex == 0 {
            let alert = UIAlertController(title: "Oops!", message: "\(plant) is already in your farm", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        if alertIndex == 1 {
            let alert = UIAlertController(title: "New Plant!", message: "\(plant) has being added to your farm", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //cancel
                self.performSegue(withIdentifier: segueID.detailToSearchSegue.rawValue, sender: self)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Favourite alert
    private func favouriteAlert(_ plant: String, alertIndex: Int) {
        if alertIndex == 0 {
            let alert = UIAlertController(title: "", message: "You have added \(plant) to your favourites", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        if alertIndex == 1 {
            let alert = UIAlertController(title: "", message: "You have moved \(plant) from your favourites", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}
