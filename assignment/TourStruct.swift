//
//  TourPoint.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import Foundation
import MapKit

struct TourPoint {
    var Title:String
    var Latitude:Double
    var Longitude:Double
    
    var coord:CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
        }
    }
    
    var annotation:MKPointAnnotation {
        get {
            let ann = MKPointAnnotation()
            ann.title = Title
            ann.coordinate = coord
            return ann
        }
    }
    
    var mapItem:MKMapItem {
        get {
            return MKMapItem(placemark: MKPlacemark(coordinate: coord))
        }
    }
    
    init(_ title:String, _ latitude:Double, _ longitude:Double) {
        Title = title
        Latitude = latitude
        Longitude = longitude
    }
}

struct TourDetail {
    var title:String
    var subtitle:String
    var tourPoints:[TourPoint]
    
    init(_ title:String, _ subtitle:String, _ tourPoints:[TourPoint]) {
        self.title = title
        self.subtitle = subtitle
        self.tourPoints = tourPoints
    }
}
