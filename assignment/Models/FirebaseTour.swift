//
//  FirebaseTour.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//

import Foundation
import FirebaseFirestore

struct FirebaseTour: Identifiable {
    var id:String
    var title:String
    var points:[GeoPoint]
}
