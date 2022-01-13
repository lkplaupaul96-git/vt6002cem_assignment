//
//  MapViewController.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnShowNearBy: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var firstGPSCoord:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    @IBAction func showNearbyTour() {
        self.locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return }
        firstGPSCoord = false
        locationManager.startUpdatingLocation()
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
            showTourPath(item.tourPoints)
        }
    }
    
    func showTourPath(_ tours:[TourPoint]){
        guard tours.count > 0 else { return }
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
                    
                    let firstPtCoord = CLLocationCoordinate2D(
                        latitude: tours[0].coordinate.latitude,
                        longitude: tours[0].coordinate.longitude)
                    let region = MKCoordinateRegion(center: firstPtCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.mapView.setRegion(region, animated: true)
                }
            }
        } else if tours.count == 1 {
            let firstPtCoord = CLLocationCoordinate2D(
                latitude: tours[0].coordinate.latitude,
                longitude: tours[0].coordinate.longitude)
            let region = MKCoordinateRegion(center: firstPtCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.alpha = 0.6
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
 
        if !firstGPSCoord {
            firstGPSCoord = true
            let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}
