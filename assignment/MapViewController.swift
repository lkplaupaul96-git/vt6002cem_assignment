//
//  MapViewController.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnShowNearBy: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
    }
    
    func presentSubView() {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = true
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true, completion: nil)
    }
    
    deinit {
        //
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        let source = segue.source as? TourTableViewController
        print("TEST2")
        if let item = source?.selectedItem {
            print(item)
        }
    }
    
    func showTourPath(_ tours:[TourPoint]){
        // reset map view
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        
        self.mapView.showAnnotations(tours.map({ $0.annotation }), animated: true )
        
        if tours.count >= 2 {
            for (idx, pt) in tours.enumerated() {
                guard idx != tours.count - 1 else { return }
                let request = MKDirections.Request()
                request.source = pt.mapItem
                request.destination = tours[idx+1].mapItem
                request.requestsAlternateRoutes = true
                request.transportType = .walking

                let directions = MKDirections(request: request)

                directions.calculate { [unowned self] response, error in
                    guard let unwrappedResponse = response else { return }

                    for route in unwrappedResponse.routes {
                        self.mapView.addOverlay(route.polyline)
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.alpha = 0.6
        return renderer
    }
}
