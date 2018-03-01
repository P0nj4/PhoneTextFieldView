//
//  PhoneTextFieldView.swift
//
//  Created by German Pereyra on 1/17/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import UIKit

public protocol PhoneTextFieldViewDelegate: class {
  func phoneTextFieldView(_ phoneTextFieldView: PhoneTextFieldView, phoneTextDidChange phoneText: String)
  func phoneTextFieldViewWillPresentFlagsOn() -> UIViewController
}

public class PhoneTextFieldView: UIView {

  @IBOutlet weak var view: UIView!
  @IBOutlet weak var phoneNumber: UITextField!
  @IBOutlet weak var flag: UIImageView!
  @IBOutlet weak var phoneExtension: UILabel!

  public weak var delegate: PhoneTextFieldViewDelegate?

  public var phone: String {
    return phoneNumber.text!
  }

  public var prefix: String {
    return phoneExtension.text!
  }

  public var entirePhone: String {
    return "\(phoneExtension.text!)\(phoneNumber.text!)"
  }

  public var font: UIFont? {
    get {
      return phoneNumber.font
    }
    set {
      phoneNumber.font = newValue
      phoneExtension.font = newValue
    }
  }

  func initialize() {
    let bundle = PodBundle.main
    bundle.loadNibNamed("PhoneTextFieldView", owner: self, options: nil)
    addSubview(self.view)
    view.frame = self.bounds
    phoneNumber.delegate = self
    updateFlag(countryFlag: CountryFlagHelper.currentCountryFlag())

  }
  public override init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    initialize()
  }

  func updateFlag(countryFlag: CountryFlag) {
    phoneExtension.text = "+\(countryFlag.phoneExtension)"
    flag.image = countryFlag.flag
  }

  @IBAction func flagPressed(_ sender: Any) {
    let countryFlagSelectionViewController = CountryFlagSelectionViewController()
    countryFlagSelectionViewController.delegate = self
    countryFlagSelectionViewController.modalPresentationStyle = .overCurrentContext

    if let viewController = self.delegate?.phoneTextFieldViewWillPresentFlagsOn() {
      viewController.present(countryFlagSelectionViewController, animated: true, completion: nil)
    }
    phoneNumber.resignFirstResponder()
  }
}

extension PhoneTextFieldView: UITextFieldDelegate {

  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    let updatedText = currentText.replacingCharacters(in: currentText.range(from: range)!,
                                                      with: string)
    delegate?.phoneTextFieldView(self, phoneTextDidChange: updatedText)
    return true
  }
}

extension PhoneTextFieldView: CountryFlagSelectionViewControllerDelegate {

  func countryFlagSelectionDidFinished(_ countryFlag: CountryFlag) {
    updateFlag(countryFlag: countryFlag)
    phoneNumber.becomeFirstResponder()
  }

  func countryFlagSelectionDidSelectFlag(_ countryFlag: CountryFlag) {
    updateFlag(countryFlag: countryFlag)
  }
}
