//
//  MapView.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    init(coordinates: String?) {
        guard let coordinates = coordinates else {
            self.latitude = 34.011286
            self.longitude = -116.166868
            return
        }
        
        let coordinatesArray = coordinates.split(separator: " ")
        
        if let arrayFirst = coordinatesArray.first, let arrayLast = coordinatesArray.last {
            let latitudeString = String(arrayFirst)
            let longitudeString = String(arrayLast)
            
            if let latitudeDouble = Double(latitudeString), let longitudeDouble = Double(longitudeString) {
                self.latitude = CLLocationDegrees(exactly: latitudeDouble)
                self.longitude = CLLocationDegrees(exactly: longitudeDouble)
            }
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude ?? 34.011286, longitude: longitude ?? -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 34.011286, longitude: longitude ?? -116.166868)
        view.addAnnotation(annotation)
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView(coordinates: "34.011286 -116.166868")
    }
}
