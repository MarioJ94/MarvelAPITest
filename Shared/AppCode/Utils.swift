//
//  Utils.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

func currentDeviceType() -> UIUserInterfaceIdiom {
    return UIDevice.current.userInterfaceIdiom
}

class Utils {
    static func appendPathOfImage(path: String, withExtension ext: String) -> String {
        let nsPath = path as NSString
        let result = nsPath.appendingPathExtension(ext) ?? ""
        return result
    }
}
