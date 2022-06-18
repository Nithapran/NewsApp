//
//  SelectCountryView.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-11.
//

import UIKit
import RxSwift
import RxCocoa

class SelectCountryView: UIView {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var isSelectedSwitch: UISwitch!
    var selectCountry: ((_ country: Countries) -> Void)?
    var isSelected: Bool = false {
        didSet {
            isSelectedSwitch.isOn = isSelected
        }
    }
    var country: Countries = .CA {
        didSet {
            setUpView()
        }
    }

        let nibName = "SelectCountryView"
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
            setUpView()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
            setUpView()
        }
        
        func commonInit() {
            guard let view = loadViewFromNib() else { return }
            view.frame = self.bounds
            self.addSubview(view)
        }
        
        func loadViewFromNib() -> UIView? {
            let nib = UINib(nibName: nibName, bundle: nil)
            return nib.instantiate(withOwner: self, options: nil).first as? UIView
        }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        selectCountry?(country)
    }
    
    func setUpView(){
        isSelectedSwitch.isOn = isSelected
        isSelectedSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        self.countryLabel.text = country.rawValue
        

            
    }

}
