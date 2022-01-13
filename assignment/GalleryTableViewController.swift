//
//  GalleryTableViewController.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//

import UIKit
import CoreData

class GalleryTableViewController: UITableViewController {
    
    var tourRecords:[TourRecord] = [TourRecord]()
    var managedObjectContext : NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
    return nil; }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        loadDataFromCoreData()
    }
    
    func loadDataFromCoreData() {
        if let managedObjectContext = self.managedObjectContext {
            let fetchRequest = NSFetchRequest<TourRecord>(entityName: "TourRecord");
            do {
                let records = try managedObjectContext.fetch(fetchRequest)
                self.tourRecords = records
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch { }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tourRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as? GalleryTableViewCell
        if cell == nil {
            cell = GalleryTableViewCell()
        }
        let item = tourRecords[indexPath.row]
        cell?.lblTitle.text = item.title
        cell?.lblDate.text = "\(String(describing: item.date!).prefix(10))"
        let img = UIImage(data: Data(base64Encoded: item.imageData!.base64EncodedData())!)
        cell?.ivPhoto.image = img
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00
    }

}
