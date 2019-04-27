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

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteToDetailSegue" {
            guard let nv = segue.destination as? UINavigationController, let detailVC = nv.topViewController as? PlantDetailViewController, let indexPath = sender as? IndexPath else {fatalError()}
            detailVC.plant = user.favoritePlants[indexPath.row]
            detailVC.user = user
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    }

}
