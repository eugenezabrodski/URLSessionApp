//
//  LoginViewController.swift
//  URLSessionApp
//
//  Created by Eugene on 10/01/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 128/255, alpha: 1)
    let secondaryColor = UIColor(red: 107/255, green: 148/255, blue: 230/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }

}

extension UIView {
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
