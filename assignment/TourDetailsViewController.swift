//
//  TourDetailsViewController.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//

import UIKit

class TourDetailsViewController: UITableViewController {
    
    var tour:TourDetail
    
    init(tour:TourDetail) {
        self.tour = tour
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action:  #selector(closeTourDetailsView))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = tour.title
    }
    
    @objc func closeTourDetailsView() {
        NotificationCenter.default.post(name: Notification.Name("clearTour"), object: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(tour.tourPoints.count)
        return tour.tourPoints.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell_\(indexPath.row)")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell_\(indexPath.row)")
        }
        
        cell!.textLabel?.text = tour.tourPoints[indexPath.row].title

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("moveToPoint"), object: tour.tourPoints[indexPath.row].coord)
    }
    
}
