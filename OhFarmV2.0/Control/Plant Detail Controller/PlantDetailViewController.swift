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
    var plant: Plant!
    var slides: [PhotoSlide] = []
    let buttonUI = SearchPlantUI()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var isFromHome =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if plant == nil {
            fatalError("Plant can not be nil")
        }
        
        navigationItem.title = plant?.cropName
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        if !isFromHome {
            addPlantButtonUI()
        }
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            guard let containerVC = segue.destination as? PlantInfoSlideViewController else {fatalError()}
            containerVC.plant = plant
            containerVC.isFromHome = isFromHome
        }
    }
    
    // MARK: Action
    @objc private func addPlant(_ sender: UIButton) {
        print("added")
    }
    
    @objc private func screenEdgeSwiped(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Appearence
    // Plant Photo gallery view
    func createSlides() -> [PhotoSlide] {
        let slide1: PhotoSlide = Bundle.main.loadNibNamed("PhotoSlide", owner: self, options: nil)?.first as! PhotoSlide
        slide1.configureWithData(plant.cropName)
        
        let slide2: PhotoSlide = Bundle.main.loadNibNamed("PhotoSlide", owner: self, options: nil)?.first as! PhotoSlide
        slide2.configureWithData("test1")
        
        let slide3: PhotoSlide = Bundle.main.loadNibNamed("PhotoSlide", owner: self, options: nil)?.first as! PhotoSlide
        slide3.configureWithData("test2")
        
        return [slide1, slide2, slide3]
    }
    
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
        view.bringSubviewToFront(pageControl)
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

extension PlantDetailViewController: UIScrollViewDelegate {
    
    //MARK: default fucntion of scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
