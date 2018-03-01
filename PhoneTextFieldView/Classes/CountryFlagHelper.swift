//
//  CountryFlagHelper.swift
//
//  Created by German Pereyra on 3/1/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

import UIKit

struct CountryFlagHelper {

  static let countryFlags = CountryFlagSourcesHelper.countries

  static var currentCode: String? {
    let currentLocale = Locale.current
    let regionCode = currentLocale.regionCode?.uppercased()
    return regionCode
  }

  private static var empty: CountryFlag {
    return CountryFlag(countryCode: "empty", phoneExtension: "")
  }

  static func countryFlagBy(phoneExtension: String) -> CountryFlag {
    let phoneExtension = (phoneExtension as NSString).replacingOccurrences(of: "+", with: "")
    for country in countryFlags where phoneExtension == country.phoneExtension {
      return country
    }
    return empty
  }

  static func countryFlagBy(code: String) -> CountryFlag {
    for country in countryFlags where code == country.countryCode {
      return country
    }
    return empty
  }

  static func currentCountryFlag() -> CountryFlag {
    return countryFlagBy(code: currentCode ?? "")
  }

  static func normalizePhone(_ phone: String) -> String {
    var nomalizedPhone = phone
    if !phone.starts(with: "00") && !phone.starts(with: "+") {
      if phone.starts(with: "0") {
        nomalizedPhone = phone.substring(from: 1)
      }
      let flag = CountryFlagHelper.currentCountryFlag()
      nomalizedPhone = "+\(flag.phoneExtension)\(nomalizedPhone)"
    }
    return nomalizedPhone
  }
}

private class CountryFlagSourcesHelper {
  public private(set) static var countries: [CountryFlag] = {
    var countries: [CountryFlag] = []
    do {

      if let file = PodBundle.main.url(forResource: "countryCodes", withExtension: "json") {
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? [[String: String]] {
          for object in array {
            guard let code = object["code"],
              let phoneExtension = object["dial_code"],
              let formatPattern = object["format"] else {
                fatalError("Must be valid json.")
            }
            countries.append(CountryFlag(countryCode: code,
                                         phoneExtension: phoneExtension))
          }
        }
      } else {
        print("NKVPhonePickerTextField can't find a bundle for the countries")
      }
    } catch {
      print(error.localizedDescription)
    }

    return countries
  }()
}

public class CountryFlag: NSObject {

  var countryCode: String
  var phoneExtension: String
  var name: String {
    return (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode)!
  }
  var flag: UIImage? {
    return UIImage(named: countryCode.uppercased(), in: PodBundle.main, compatibleWith: nil)
  }

  public init(countryCode: String, phoneExtension: String) {
    self.countryCode = countryCode
    self.phoneExtension = phoneExtension
  }
}
