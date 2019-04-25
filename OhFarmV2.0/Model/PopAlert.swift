//
//  PopAlert.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PopAlert {
    
    //MARK: Delete pop up confirmation
    func deleteConfirmation(_ tableView: UITableViewController) -> Bool {
        
        var delete =  false
        let alert = UIAlertController(title: "Delete plant", message: "Are you sure you want to delete this plant ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
            delete = true
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (_) in
            print("Delete dismiss")
        }))
        
        tableView.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        print(delete)
        return delete
    }
    
}
