//
//  TourTableViewController.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit
import MapKit
import Firebase

class TourTableViewController: UITableViewController {

    @IBOutlet weak var txtSearch: UITextField!
    var selectedItem:TourDetail?
    var tours:[TourDetail] = [TourDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTours()
    }
    
    func fetchTours() {
        let db = Firestore.firestore()
        db.collection("tours").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    let arr = snapshot.documents.map { d -> TourDetail in
                        let tourPoints = d["tourPoints"] as? [[String: Any]] ?? [[String: Any]]()
                        return TourDetail(
                            id: d.documentID,
                            title: d["title"] as? String ?? "",
                            subtitle: d["subtitle"] as? String ?? "",
                            tourPoints: tourPoints.map { tp -> TourPoint in return TourPoint(
                                title: tp["title"] as? String ?? "",
                                coordinate: tp["coordinate"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)) })
                    }
                    self.tours = arr
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func fetchToursWithFilter() {
        guard let keywords = txtSearch.text else { return }
        let db = Firestore.firestore()
        db.collection("tours")
            .whereField("title", isEqualTo: keywords)
            .getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    let arr = snapshot.documents.map { d -> TourDetail in
                        let tourPoints = d["tourPoints"] as? [[String: Any]] ?? [[String: Any]]()
                        return TourDetail(
                            id: d.documentID,
                            title: d["title"] as? String ?? "",
                            subtitle: d["subtitle"] as? String ?? "",
                            tourPoints: tourPoints.map { tp -> TourPoint in return TourPoint(
                                title: tp["title"] as? String ?? "",
                                coordinate: tp["coordinate"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)) })
                    }
                    self.tours = arr
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tours.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! TourCell
        let idx = indexPath.row
        
        cell.title.text = tours[idx].title
        cell.subtitle.text = tours[idx].subtitle

        return cell
    }
    
    // back to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else { return }
        let idx = cell.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: idx)
        
        self.selectedItem = tours[indexPath!.row]
    }
    
}
