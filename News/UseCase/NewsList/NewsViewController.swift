//
//  NewsViewController.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-05.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectedFiltersView: SelectedFiltersView!
    
    @IBOutlet weak var SelectedFiltersViewHeightConstraint: NSLayoutConstraint!
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 10))
    
    private let viewModel = NewsViewModel()
    
    private let bag = DisposeBag()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindTableView()
        bindSearchBar()
        bindSelectedFilters()
        
    }
    
    @objc private func didClickFilterButton() {
        let vc = FilterViewController() //change this to your class name
        let navigationController = UINavigationController(rootViewController: vc)
        
        vc.selectedCountry
            .subscribe(onNext: { [unowned self] query in
                viewModel.fetchNews(selectedCountry: query.rawValue)
                selectedFiltersView.selectedCountry.onNext(query)
                
            })
            .disposed(by: bag)
        
         // Present View "Modally"
         self.present(navigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpNavBar()
    }
    
    private func setUpView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 198
        searchBar.placeholder = "Your placeholder"
        searchBar.tintColor = .white
        searchBar.layer.cornerRadius = 10
    
        let rightNavBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .plain, target: self, action: #selector (didClickFilterButton))
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    private func bindSelectedFilters() {
        selectedFiltersView.selectedCountry
            .subscribe(onNext: { [unowned self] query in
                guard query != nil else {
                    SelectedFiltersViewHeightConstraint.constant = 0
                    selectedFiltersView.isHidden = true
                    return
                }
                
                SelectedFiltersViewHeightConstraint.constant = 30
                selectedFiltersView.isHidden = false
                
            })
            .disposed(by: bag)
    }
    
    private func bindSearchBar() {
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(.microseconds(100), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
             // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                print(query)
                self.viewModel.searchText = query
                
            })
            .disposed(by: bag)
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
            
        viewModel.obsevedNews.bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { (row,news,cell) in
                cell.news = news
            }.disposed(by: bag)
            
            tableView.rx.modelSelected(News.self).subscribe(onNext: { item in
                print("SelectedItem: \(String(describing: item.author))")
            }).disposed(by: bag)
            
            viewModel.fetchNews()
        }
}
