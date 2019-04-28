//
//  LoginViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 28/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Variable
    @IBOutlet weak var nameField: UITextField!
    let themeColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    let vcUI = SearchPlantUI()
    var name = ""
    var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        setupAppearence()
        enableTapAway()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupAppearence() {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2.6))
        contentView.backgroundColor = themeColor
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        contentView.layer.shadowRadius = 17
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize.zero
        
        let label = UILabel(frame: CGRect(x: 24, y: 111, width: contentView.frame.width-48, height: 86))
        label.numberOfLines = 0
        label.text = "Hello!\nWelcome to Oh! Farm."
        label.textColor = .white
        label.font = UIFont(name: "Helvetica", size: 30)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background")
        
        contentView.addSubview(label)
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        view.addSubview(contentView)
        
        button = vcUI.filterBottomButton()
        button.setTitle("Skip", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    //MARK: Go next page action
    @objc private func buttonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToHomeSegue", sender: self)
    }
    
    //MARK: Alert for text input
    private func uiAlert()  {
        var alert = UIAlertController()
        
        alert = UIAlertController(title: "Error", message: "Name can only have characters or number", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Tap away method
    private func enableTapAway() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the buttons while editing.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameField.text?.isEmpty == false {
            let name = nameField.text ?? ""
            if name.rangeOfCharacter(from: CharacterSet.letters) == nil || name.rangeOfCharacter(from: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ")) == nil {
                nameField.text = ""
                self.name = ""
                button.setTitle("Skip", for: .normal)
                uiAlert()
            } else {
                self.name = name
                button.setTitle("Start", for: .normal)
            }
        } else {
            self.name = ""
            button.setTitle("Skip", for: .normal)
        }
    }
    
}
