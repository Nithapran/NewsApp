//
//  FilterViewController.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-10.
//

import UIKit
import RxSwift
import RxCocoa

enum Countries: String,CaseIterable {
    case US
    case CA
    case BR
    case IN
}

class FilterViewController: UIViewController {
    @IBOutlet weak var countriesStackVIew: UIStackView!
    
    var countryFilters: [SelectCountryView] = []
    
    var selectedCountry = PublishSubject<Countries>()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindSelectCountryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpNavBar("Filters")
    }
    
    private func setUpView() {
        for country in Countries.allCases {
            let view = SelectCountryView(frame: CGRect(x: 0, y: 0, width: countriesStackVIew.frame.width, height: 30))
            view.country = country
            view.selectCountry = selectCountry
            self.countryFilters.append(view)
            self.countriesStackVIew.addArrangedSubview(view)
        }
    }
    
    private func selectCountry(country: Countries) {
        self.selectedCountry.onNext(country)
    }
    
    private func bindSelectCountryView() {
        selectedCountry
            .subscribe(onNext: { [unowned self] query in
                for countryView in countryFilters {
                    countryView.isSelected = query == countryView.country ? true : false
                    self.navigationController?.dismiss(animated: true)
                }
            })
            .disposed(by: bag)
    }
    
}
