//
//  IntroductionViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 1/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    var slides: [IntroductionView] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    enum segueID: String {
        case LoginSegue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create slides for introduction
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Actions
    @objc private func getStart(_ sender: UIButton) {
        performSegue(withIdentifier: segueID.LoginSegue.rawValue, sender: self)
    }
    
    @objc private func skipButton(_ sender: UIButton) {
        performSegue(withIdentifier: segueID.LoginSegue.rawValue, sender: self)
    }
    
    //MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

//Extension for ui scroll view delegate
extension IntroductionViewController: UIScrollViewDelegate {
    
    //MARK: default function of scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //MARK: Create slide view
    // Create each slide
    func createSlides() -> [IntroductionView] {
        var introSlides = [IntroductionView]()
        
        let slidesData = [["introSearch","Live Sustainably","Oh! Farm helps you to use the free space in your home and live sustainably"],["introSow","Grow Your Own Plant","Select a plant, Know the techniques and grow your own plant in your garden regardless of space and time"],["introPlanting","Grow Your Own Plant","Select a plant, Know the techniques and grow your own plant in your garden regardless of space and time"],["introMap","Access the community","Search for a nearby community farm and meet people who share your interests"],["introLike","Last","Welcome to Oh! Farm.\nTap the button below to start your journey."]]
        
        for data in slidesData {
            guard let slide: IntroductionView = Bundle.main.loadNibNamed("IntroductionView", owner: self, options: nil)?.first as? IntroductionView else {fatalError()}
            slide.configWithData(data)
            introSlides.append(slide)
            slide.skipButton.addTarget(self, action: #selector(skipButton(_:)), for: .touchUpInside)
            if data[1] == "Last" {
                slide.button.addTarget(self, action: #selector(getStart(_:)), for: .touchUpInside)
            }
        }
        
        return introSlides
    }
    
    //Set up slide scroll view for segmented section
    func setupSlideScrollView(slides: [IntroductionView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
        
        //Set page control number same as number of slide
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        pageControl.pageIndicatorTintColor = .lightGray
        view.bringSubviewToFront(pageControl)
        
        //Hide scroll bar
        scrollView.showsHorizontalScrollIndicator = false
    }
    
}
