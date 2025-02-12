//
//  ViewMenuBarItem.swift
//  LocationSimulator
//
//  Created by David Klopp on 25.12.20.
//  Copyright © 2020 David Klopp. All rights reserved.
//

import AppKit
import MapKit

let kViewMenuTag: Int = 3

/// The main File menu.
enum ViewMenubarItem: Int, CaseIterable, MenubarItem {
    case toggleSidebar = 3
    case zoomIn = 6
    case zoomOut = 7
    case explore = 9
    case satellite = 10
    case hybrid = 11

    static public var menu: NSMenu? {
        return NSApp.menu?.item(withTag: kViewMenuTag)?.submenu
    }

    static public func selectMapTypeItem(forMapType mapType: MKMapType) {
        let menuBarItems: [MKMapType: ViewMenubarItem] = [.standard: .explore, .satellite: .satellite, .hybrid: .hybrid]
        menuBarItems.forEach { $1.off() }
        menuBarItems[mapType]?.on()
    }
}
