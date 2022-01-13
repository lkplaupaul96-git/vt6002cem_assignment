//
//  TourTableViewController.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit
import MapKit

class TourTableViewController: UITableViewController {

    var selectedItem:TourDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! TourCell
        cell.title.text = "123123213"
        cell.subtitle.text = "12328"

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedItem = TourDetail("123", "456", [TourPoint]())
//        print("TEST")
//    }
    
    // back to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else { return }
        let idx = cell.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: idx)
        
        print(indexPath!.row)
        
        self.selectedItem = TourDetail("123", "456", [TourPoint]())
    }
    
}
