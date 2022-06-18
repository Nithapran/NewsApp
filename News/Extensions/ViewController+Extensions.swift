//
//  ViewController+Extensions.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-18.
//

import Foundation
import UIKit

extension UIViewController {
    func setUpNavBar(_ title: String = "",_ isHidden: Bool = false) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = title
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            //appearance.backgroundColor = .red
            appearance.titleTextAttributes =  [NSAttributedString.Key.foregroundColor : UIColor.black]
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
    }
}
