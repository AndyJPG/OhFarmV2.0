//
//  PlantAvoidTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PlantAvoidTableViewCell: UITableViewCell {
    
    var compatiablePlant: [String] = []
    var slides: [AvoidCompanionSlide] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Appearence
    // Plant Photo gallery view
    func createSlides() -> [AvoidCompanionSlide] {
        
        var slides: [AvoidCompanionSlide] = []
        for item in compatiablePlant {
            let slide: AvoidCompanionSlide = Bundle.main.loadNibNamed("AvoidCompanionSlide", owner: self, options: nil)?.first as! AvoidCompanionSlide
            slide.configWithData(item.trimmingCharacters(in: .whitespaces))
            slides.append(slide)
        }
        
        return slides
    }
    
    func setupSlideScrollView(slides: [AvoidCompanionSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 135)
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(slides.count), height: 135)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: 135)
            scrollView.addSubview(slides[i])
        }
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        self.bringSubviewToFront(pageControl)
    }

}

extension PlantAvoidTableViewCell: UIScrollViewDelegate {
    //MARK: default fucntion of scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
