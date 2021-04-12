//
//  AddTimeZoneViewController.swift
//  TimeZoneTrack
//
//  Created by Anantha on 26/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

class AddTimeZoneViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var searchBar: UISearchBar!
    
    let timeZoneHelper = TimeZoneHelperModel()
    var timezones = [TimeZoneModel]()
    var filtered = [TimeZoneModel]()
    var addTimeZoneClosure: ((TimeZoneModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timezones = timeZoneHelper.fetchAllNonSelectedTimeZone()
        filtered = timezones
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    func updateForSearchString(_ string: String) {
        if !string.isEmpty {
            filtered = timezones.filter {
                $0.name?.range(of: string, options: .caseInsensitive) != nil ||
                    $0.timeZone?.range(of: string, options: .caseInsensitive) != nil ||
                    localTimeZoneName(string, timeZoneModel: $0)
            }
            
        } else {
            filtered = timezones
        }
        tableView?.reloadData()
    }
    
    func localTimeZoneName(_ searchString: String, timeZoneModel: TimeZoneModel) -> Bool {
        guard let locationTimeZone = timeZoneModel.timeZone,
        let timezone = TimeZone(identifier: locationTimeZone) else { return false }
        let localTimeZoneName = timezone.localizedName(for: .standard, locale: .current)
        return localTimeZoneName?.range(of: searchString, options: .caseInsensitive) != nil ? true : false
    }
    
    @IBAction func cancel(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        updateForSearchString(textDidChange)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow, filtered.indices.contains(selectedIndexPath.row) {
            if let addTimeZoneClosure = addTimeZoneClosure {
                addTimeZoneClosure(filtered[selectedIndexPath.row])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell", for: indexPath) as? TimeZoneCell else {
//            print("Cell not exists in storyboard")
            return UITableViewCell()
        }
        
        cell.updateUI(filtered[indexPath.row])
        return cell
    }
}

