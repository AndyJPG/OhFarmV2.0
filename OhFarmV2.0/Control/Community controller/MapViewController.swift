//
//  MapViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 15/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

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
        } else {
            let initialLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(coordinateRegion, animated: true)
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
    
    //Create annotation call out
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Community else {return nil}
        
        // Annotation views should be dequeued from a reuse queue to be efficent.
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.canShowCallout = true
        
        // If the annotation has an address, add an extra Info button to the annotation so users can open the Address.
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
        mapsButton.tag = 0
        view?.rightCalloutAccessoryView = mapsButton
        
        // Add email button to left call out accessory view
        let emailButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        emailButton.setBackgroundImage(UIImage(named: "Email-icon"), for: UIControl.State())
        emailButton.tag = 1
        view?.leftCalloutAccessoryView = emailButton
                
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! Community
        if control.tag == 0 {
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        } else {
            sendEmail(location.contactEmail, location.garden)
        }
    }
}

//MARK: MFMail compose view controller delegate extension
extension MapViewController: MFMailComposeViewControllerDelegate {
    
    //MARK: Send Email funcion
    func sendEmail(_ email: String, _ farmName: String) {
        if MFMailComposeViewController.canSendMail() {
            print(email)
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p>To \(farmName)</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("send email fail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
