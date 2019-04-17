//
//  MapViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 15/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: variables
    //Reuseable annotation ID
    private enum AnnotationReuseID: String {
        case pin
    }
    
    @IBOutlet private var mapView: MKMapView!
    
    var mapItems: [MKMapItem]?
    var boundingRegion: MKCoordinateRegion?
    var communities = [Community]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let region = boundingRegion {
            mapView.region = region
        }
        mapView.delegate = self
        
        // Show the compass button in the navigation bar.
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false // Use the compass in the navigation bar instead.
        
        // Make sure `MKPinAnnotationView` and the reuse identifier is recognized in this map view.
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.pin.rawValue)
        
        loadInitialData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Add annotations
        mapView.addAnnotations(communities)
        
        guard let mapItems = mapItems else { return }
        
        if mapItems.count == 1, let item = mapItems.first {
            title = item.name
        } else {
            title = NSLocalizedString("TITLE_ALL_PLACES", comment: "All Places view controller title")
        }
    }

    //MARK: Data function
    //Load initial data
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "communityFarmData", ofType: "json") else {return}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard let data = optionalData, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
        guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
        for dic in jsonArray {
            communities.append(Community(dic))
        }
    }
    
}

//MARK: MKMap View extension
extension MapViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("Failed to load the map: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Community else {return nil}
        
        // Annotation views should be dequeued from a reuse queue to be efficent.
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.canShowCallout = true
        
        // If the annotation has an address, add an extra Info button to the annotation so users can open the Address.
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
        //        let infoButton = UIButton(type: .detailDisclosure)
        view?.rightCalloutAccessoryView = mapsButton
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Community
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
