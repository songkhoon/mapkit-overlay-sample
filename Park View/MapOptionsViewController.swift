//
//  MapOptionsViewController.swift
//  Park View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit

enum MapOptionsType: Int {
    case mapBoundary = 0
    case mapOverlay
    case mapPins
    case mapCharacterLocation
    case mapRoute
}

class MapOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedOptions = [MapOptionsType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as! UITableViewCell
        let mapOptionsType = MapOptionsType(rawValue: indexPath.row)
        switch (mapOptionsType!) {
        case .mapBoundary:
            cell.textLabel!.text = "Park Boundary"
        case .mapOverlay:
            cell.textLabel!.text = "Map Overlay"
        case .mapPins:
            cell.textLabel!.text = "Attraction Pins"
        case .mapCharacterLocation:
            cell.textLabel!.text = "Character Location"
        case .mapRoute:
            cell.textLabel!.text = "Route"
        }
        
        //    if contains(selectedOptions, mapOptionsType!) {
        //      cell.accessoryType = UITableViewCellAccessoryType.checkmark
        //    } else {
        //      cell.accessoryType = UITableViewCellAccessoryType.none
        //    }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let mapOptionsType = MapOptionsType(rawValue: indexPath.row)
        if (cell!.accessoryType == UITableViewCellAccessoryType.checkmark) {
            cell!.accessoryType = UITableViewCellAccessoryType.none
            // delete object
            selectedOptions = selectedOptions.filter { (currentOption) in currentOption != mapOptionsType}
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedOptions += [mapOptionsType!]
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
