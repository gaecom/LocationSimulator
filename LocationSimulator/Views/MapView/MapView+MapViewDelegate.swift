//
//  MapViewController+MapViewDelegate.swift
//  LocationSimulator
//
//  Created by David Klopp on 18.08.19.
//  Copyright © 2019 David Klopp. All rights reserved.
//

import Foundation
import MapKit

let kAnnotationViewCurrentLocationIdentifier = "AnnotationViewCurrentLocationIdentifier"

/// This delegate is responsible for providing a polyline when navigation is active.
/// Additionally it handles the track gesture of the current location marker and informs observer about the action.
extension MapView: MKMapViewDelegate {

    // MARK: - Navigation overlay

    /// Create the renderer for the navigation overlay.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            fatalError("Could not cast overlay to MKPolyline.")
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .overlayBlue
        // renderer.lineDashPattern = [0, 10]
        renderer.lineWidth = 8
        return renderer
    }

    // MARK: - Current location marker

    /// Create the view for the current location marker.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pointAnnotation = annotation as? MKPointAnnotation, pointAnnotation == self.currentLocationMarker {
            var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: kAnnotationViewCurrentLocationIdentifier)

            if annotationView == nil {
                annotationView = UserLocationView(annotation: annotation,
                                                  reuseIdentifier: kAnnotationViewCurrentLocationIdentifier)

            }

            annotationView?.annotation = pointAnnotation

            return annotationView
        }

        return nil
    }

    /// Current location marker was dragged.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending, let annotation = view.annotation {
            self.markerDragAction?(self.currentLocationMarker?.coordinate, annotation.coordinate)
        }
    }

    // MARK: - User interaction
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.isUserInteracting = true
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.isUserInteracting = false
    }
}
