//
//  ParkMapViewController.swift
//  Park View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

enum MapType: Int {
  case standard = 0
  case hybrid
  case satellite
}

class ParkMapViewController: UIViewController, MKMapViewDelegate {
  
  
  @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var mapView: MKMapView!
  
  var park = Park(filename: "MagicMountain")
  var selectedOptions = [MapOptionsType]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let latDelta = park.overlayTopLeftCoordinate.latitude -
      park.overlayBottomRightCoordinate.latitude
    
    // think of a span as a tv size, measure from one corner to another
    let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
    
    let region = MKCoordinateRegionMake(park.midCoordinate, span)
    
    mapView.region = region
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Add methods
  
  func addOverlay() {
    let overlay = ParkMapOverlay(park: park)
    mapView.add(overlay)
  }
  
  func addAttractionPins() {
    let filePath = Bundle.main.path(forResource: "MagicMountainAttractions", ofType: "plist")
    let attractions = NSArray(contentsOfFile: filePath!) as! [[String:String]]
    for attraction in attractions {
      let point = CGPointFromString(attraction["location"]!)
      let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
      let title = attraction["name"]!
      let typeRawValue = Int(attraction["type"]!)
      let type = AttractionType(rawValue: typeRawValue!)!
      let subtitle = attraction["subtitle"]!
      let annotation = AttractionAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
      mapView.addAnnotation(annotation)
    }
  }
  
  func addRoute() {
    let thePath = Bundle.main.path(forResource: "EntranceToGoliathRoute", ofType: "plist")
    let pointsArray = NSArray(contentsOfFile: thePath!)
    
    let pointsCount = pointsArray!.count
    
    var pointsToUse: [CLLocationCoordinate2D] = []
    
    for i in 0...pointsCount-1 {
      let p = CGPointFromString(pointsArray![i] as! String)
      pointsToUse += [CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))]
    }
    
    let myPolyline = MKPolyline(coordinates: &pointsToUse, count: pointsCount)
    
    mapView.add(myPolyline)
  }
  
  func addBoundary() {
    let polygon = MKPolygon(coordinates: &park.boundary, count: park.boundaryPointsCount)
    mapView.add(polygon)
  }
  
  func addCharacterLocation() {
    let batmanFilePath = Bundle.main.path(forResource: "BatmanLocations", ofType: "plist")
    let batmanLocations = NSArray(contentsOfFile: batmanFilePath!)
    let batmanPoint = CGPointFromString(batmanLocations![Int(arc4random()%4)] as! String)
    let batmanCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(batmanPoint.x), CLLocationDegrees(batmanPoint.y))
    let batmanRadius = CLLocationDistance(max(5, Int(arc4random()%40)))
    let batman = Character(center:batmanCenterCoordinate, radius:batmanRadius)
    batman.color = UIColor.blue
    
    let tazFilePath = Bundle.main.path(forResource: "TazLocations", ofType: "plist")
    let tazLocations = NSArray(contentsOfFile: tazFilePath!)
    let tazPoint = CGPointFromString(tazLocations![Int(arc4random()%4)] as! String)
    let tazCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(tazPoint.x), CLLocationDegrees(tazPoint.y))
    let tazRadius = CLLocationDistance(max(5, Int(arc4random()%40)))
    let taz = Character(center:tazCenterCoordinate, radius:tazRadius)
    taz.color = UIColor.orange
    
    let tweetyFilePath = Bundle.main.path(forResource: "TweetyBirdLocations", ofType: "plist")
    let tweetyLocations = NSArray(contentsOfFile: tweetyFilePath!)
    let tweetyPoint = CGPointFromString(tweetyLocations![Int(arc4random()%4)] as! String)
    let tweetyCenterCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(tweetyPoint.x), CLLocationDegrees(tweetyPoint.y))
    let tweetyRadius = CLLocationDistance(max(5, Int(arc4random()%40)))
    let tweety = Character(center:tweetyCenterCoordinate, radius:tweetyRadius)
    tweety.color = UIColor.yellow
    
    mapView.add(batman)
    mapView.add(taz)
    mapView.add(tweety)
  }
  
  // MARK: - Map View delegate
  
  func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
    if overlay is ParkMapOverlay {
      let magicMountainImage = UIImage(named: "overlay_park")
      let overlayView = ParkMapOverlayView(overlay: overlay, overlayImage: magicMountainImage!)
      
      return overlayView
    } else if overlay is MKPolyline {
      let lineView = MKPolylineRenderer(overlay: overlay)
      lineView.strokeColor = UIColor.green
      
      return lineView
    } else if overlay is MKPolygon {
      let polygonView = MKPolygonRenderer(overlay: overlay)
      polygonView.strokeColor = UIColor.magenta
      
      return polygonView
    } else if overlay is Character {
      let circleView = MKCircleRenderer(overlay: overlay)
      circleView.strokeColor = (overlay as! Character).color
      
      return circleView
    }
    
    return nil
  }
  
  func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
    let annotationView = AttractionAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
    annotationView.canShowCallout = true
    return annotationView
  }
  
  // MARK: Helper methods
  
  func loadSelectedOptions() {
    mapView.removeAnnotations(mapView.annotations)
    mapView.removeOverlays(mapView.overlays)
    
    for option in selectedOptions {
      switch (option) {
        case .mapOverlay:
          self.addOverlay()
        case .mapPins:
          self.addAttractionPins()
        case .mapRoute:
          self.addRoute()
        case .mapBoundary:
          self.addBoundary()
        case .mapCharacterLocation:
          self.addCharacterLocation()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let optionsViewController = segue.destination as! MapOptionsViewController
    optionsViewController.selectedOptions = selectedOptions
  }
  
  @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
    let optionsViewController = exitSegue.source as! MapOptionsViewController
    selectedOptions = optionsViewController.selectedOptions
    self.loadSelectedOptions()
  }
  
  @IBAction func mapTypeChanged(_ sender: AnyObject) {
    let mapType = MapType(rawValue: mapTypeSegmentedControl.selectedSegmentIndex)
    switch (mapType!) {
    case .standard:
      mapView.mapType = MKMapType.standard
    case .hybrid:
      mapView.mapType = MKMapType.hybrid
    case .satellite:
      mapView.mapType = MKMapType.satellite
    }
  }
}
