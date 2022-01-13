//
//  MapViewController.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit
import MapKit
import Firebase

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearTour(notification:)), name: Notification.Name("clearTour"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToPoint(notification:)), name: Notification.Name("moveToPoint"), object: nil)
    }
    
    @IBAction func showNearbyTour() {
        self.locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return }
        firstGPSCoord = false
        locationManager.startUpdatingLocation()
        
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
                    self.mapView.showAnnotations(arr.map({ $0.tourPoints[0].annotation }), animated: true )
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func presentSubView(_ tour:TourDetail) {
        let vc = TourDetailsViewController(tour: tour)

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = true
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        self.present(nav, animated: true, completion: nil)
//        performSegue(withIdentifier: "showTourDetails", sender: nil)
    }
    
    @objc func closeTourDetailsView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clearTour(notification: Any) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    @objc func moveToPoint(notification: Notification) {
        guard let coord = notification.object as? CLLocationCoordinate2D else { return }
        self.moveMapView(coord.latitude, coord.longitude)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("clearTour"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("moveToPoint"), object: nil)
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        let source = segue.source as? TourTableViewController
        if let item = source?.selectedItem {
            showTourPath(item.tourPoints)
            DispatchQueue.main.async {
                self.presentSubView(item)
            }
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
                    
                    self.moveMapView(tours[0].coordinate.latitude,
                                     tours[0].coordinate.longitude)
                }
            }
        } else if tours.count == 1 {
            moveMapView(tours[0].coordinate.latitude,
                        tours[0].coordinate.longitude)
        }
    }
    
    func moveMapView(_ latitude: Double, _ longitude: Double) {
        let firstPtCoord = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
        let region = MKCoordinateRegion(center: firstPtCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: false)
        let viewCenter = self.mapView.center
        let fakeCenter = CGPoint(x: viewCenter.x,
                                 y: viewCenter.y + (self.mapView.frame.size.height / 2 - 50))
        self.mapView.setCenter(
            self.mapView.convert(fakeCenter,
                                 toCoordinateFrom: self.mapView),
                animated: true)
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
