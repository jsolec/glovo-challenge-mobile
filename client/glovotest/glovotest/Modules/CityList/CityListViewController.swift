//
//  CityListViewController.swift
//  glovotest
//
//  Created Jesús Solé on 16/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SnapKit

class CityListViewController: UIViewController, CityListViewProtocol {

	var presenter: CityListPresenterProtocol?
    var tableView: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.clipsToBounds = true
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                maker.top.equalTo(self.view.layoutMarginsGuide)
            }
            maker.bottom.trailing.leading.equalTo(self.view)
        }
        
        self.getCountries()
    }

    func getCountries() {
        self.presenter?.getCountries()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showError() {
        AlertsManager.showAlertMessage(controller: self,
                                       title: "Error".localize,
                                       message: "ServerError".localize,
                                       buttonString: "Ok".localize)
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.citySelected(indexPath: indexPath)
    }
}

extension CityListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.presenter?.getCountryCount() ?? 0
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsForSection = self.presenter?.getCityCountByCountry(section: section) ?? 0
        return cellsForSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: CellsIdentifier.cityCell)
        cell.textLabel?.text = self.presenter?.getCityName(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.presenter?.getCountryName(section: section)
    }
}
