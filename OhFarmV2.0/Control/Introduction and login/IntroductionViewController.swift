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
    @IBOutlet weak var introSkipButton: UIButton!
    
    enum segueID: String {
        case LoginSegue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create slides for introduction
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        setupSkipButton()
        //812 iphone x
        print(view.frame.height)
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
    @objc private func buttonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0,1:
            performSegue(withIdentifier: segueID.LoginSegue.rawValue, sender: self)
        case 2:
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: true)
        default: break
        }
    }
    
    //MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSkipButton() {
        introSkipButton.isHidden = true
        introSkipButton.setTitleColor(UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1), for: .normal)
        introSkipButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        introSkipButton.titleLabel?.sizeToFit()
        introSkipButton.tag = 0
    }

}

//Extension for ui scroll view delegate
extension IntroductionViewController: UIScrollViewDelegate {
    
    //MARK: default function of scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        if Int(pageIndex) == 0 || Int(pageIndex) == 7 {
            introSkipButton.isHidden = true
        } else {
            introSkipButton.isHidden = false
        }
    }
    
    //MARK: Create slide view
    // Create each slide
    func createSlides() -> [IntroductionView] {
        var introSlides = [IntroductionView]()
        
        let slidesData = [["introLeaf","First","Welcome to Oh! Farm.\nWe would like to give you a quick tour about our application, and you are welcome to skip at any time."],["introSearch","Live Sustainably","Oh! Farm helps you to use the free space in your home and live sustainably"],["introSow","Grow Your Own Plant","Select a plant, Know the techniques and grow your own plant in your garden regardless of space and time"],["introPlanting","Grow Your Own Plant","Select a plant, Know the techniques and grow your own plant in your garden regardless of space and time"],["introMap","Access the community","Search for a nearby community farm and meet people who share your interests"],["notificationTutorial","Set the Notification", "Switch on/off the notification to be informed about when to water and harvest."],["checkListTutorial","Step-by-step Instruction","You can follow the steps for indoor/outdoor plants to ensure a great harvest."],["introLike","Last","Well done.\nTap the button below to start your journey."]]
        
        for data in slidesData {
            guard let slide: IntroductionView = Bundle.main.loadNibNamed("IntroductionView", owner: self, options: nil)?.first as? IntroductionView else {fatalError()}
            slide.configWithData(data)
            //Check screen size
            if view.frame.height > CGFloat(780) {
                print(slide.imageView.frame.height)
                slide.imageView.contentMode = .scaleToFill
            }
            
            introSlides.append(slide)
            slide.skipButton.tag = 0
            slide.skipButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            if data[1] == "Last" {
                slide.button.tag = 1
                slide.button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            }
            if data[1] == "First" {
                slide.button.tag = 2
                slide.button.setTitle("Start tour", for: .normal)
                slide.button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
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
