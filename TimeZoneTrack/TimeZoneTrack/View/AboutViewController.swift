//
//  AboutViewController.swift
//  TimeZoneTrack
//
//  Created by Prasad Prabhu on 22/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var appLogo: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var appVersionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = ThemeManager.currentTheme()
        self.view.backgroundColor = theme.backgroundColor
        self.appVersionLabel.textColor = theme.titleTextColor
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        switch theme {
        case .theme1:
            appLogo.image = #imageLiteral(resourceName: "logo-white4")
        case .white:
            appLogo.image = #imageLiteral(resourceName: "logo")
        default:
             appLogo.image = #imageLiteral(resourceName: "logo-white4")
        }
        appVersionLabel.text = "App Version: \(appVersion!) "
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
