//
//  MapDesc.swift
//  Fooderland
//
//  Created by xxlxcxfxr on 08/11/2020.
//

import Foundation
import MapKit

class MapDesc: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title:String?, locationName:String?, discipline:String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
