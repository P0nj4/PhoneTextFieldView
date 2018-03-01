//
//  BundleHelper.swift
//  PhoneTextFieldView
//
//  Created by German Pereyra on 3/1/18.
//

import Foundation

class PodBundle {
  static var main: Bundle {
    let frameworkBundle = Bundle(for: PodBundle.self)
    let bundleURL = (frameworkBundle.resourceURL! as NSURL).appendingPathComponent("PhoneTextFieldView.bundle")
    let resourceBundle = Bundle(url: bundleURL!)
    return resourceBundle!
  }
}

