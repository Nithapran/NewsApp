//
//  SelectedFiltersView.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-12.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SelectedFiltersView: UIView {
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var countryLabelContainerView: UIView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    private let bag = DisposeBag()
    
    let nibName = "SelectedFiltersView"
    
    var selectedCountry = PublishSubject<Countries?>()
    
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
    
    @IBAction func didClickClearButton(_ sender: Any) {
        selectedCountry.onNext(nil)
    }
    
    func setUpView() {
        clearButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        selectedCountry
            .subscribe(onNext: { [unowned self] query in
                self.countryLabel.text = query?.rawValue
            })
            .disposed(by: bag)
        self.countryLabelContainerView.layer.cornerRadius = 15
    }
}
