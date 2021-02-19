//
//  Location.swift
//  TDDapp
//
//  Created by Дарья on 19.02.2021.
//

import Foundation
import CoreLocation

struct Location {
    
    let title: String
    let coordinate: CLLocationCoordinate2D?
    
    init(title: String, coordinate: CLLocationCoordinate2D? = nil){
        self.title = title
        self.coordinate = coordinate
    }
}

extension Location: Equatable{
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard lhs.coordinate?.latitude == rhs.coordinate?.latitude &&
                lhs.coordinate?.longitude == rhs.coordinate?.longitude &&
                lhs.title == rhs.title
        else { return false }
        return true
    }
}
