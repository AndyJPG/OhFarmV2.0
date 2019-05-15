//
//  FavouriteTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 27/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {
    
    //MARK: Variable
    var user: User!
    let uiStyle = HomeUI()
    var notifiMassage = UILabel()
    var welcomeIamage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpAppearance()
        
        //Create edge gesture for cancel action
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMassage()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.favoritePlants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)
        let plantCell = uiStyle.favouriteCell(cell, plant: user.favoritePlants[indexPath.row])
        
        return plantCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favouriteToDetailSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteToDetailSegue" {
            guard let detailVC = segue.destination as? PlantDetailViewController, let indexPath = sender as? IndexPath else {fatalError()}
            detailVC.plant = user.favoritePlants[indexPath.row]
            detailVC.user = user
        }
    }
    
    //MARK: Actions
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Create edge swipe recognizer
    @objc private func screenEdgeSwiped(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: Appearence
    // Set up search bar
    private func setUpAppearance() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        tableView.separatorStyle = .none
        navigationItem.title = "Favourite Plants"
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        tableView.backgroundView = image
        
        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
        
        //Set up the image
        //Add welcome image and label
        welcomeIamage = UIImageView(frame: CGRect(x: view.frame.width*0.5 - 110, y: view.frame.height*0.2, width: 230, height: 230))
        welcomeIamage.image = UIImage(named: "favouriteImage")
        welcomeIamage.contentMode = .scaleAspectFit
        
        view.addSubview(welcomeIamage)
        
        //Set up the label
        let text = "Mark any plant as favourite and we will display them here\nSo you can access them when ever you want."
        
        notifiMassage = UILabel(frame: CGRect(x: view.frame.width*0.5-120, y: view.frame.height*0.2+230, width: 240, height: 100))
        notifiMassage.numberOfLines = 0
        notifiMassage.font = UIFont(name: "Helvetica", size: 15)
        notifiMassage.textColor = .darkGray
        
        let attributedString = NSMutableAttributedString(string: text)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        notifiMassage.attributedText = attributedString
        
        tableView.addSubview(notifiMassage)
    }
    
    //up date the labe
    private func updateMassage() {
        
        if user.favoritePlants.isEmpty {
            notifiMassage.isHidden = false
            welcomeIamage.isHidden = false
        } else {
            notifiMassage.isHidden = true
            welcomeIamage.isHidden = true
        }
        
    }

}
