//
//  CountryFlagSelectionViewController.swift
//
//  Created by German Pereyra on 1/17/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import UIKit

protocol CountryFlagSelectionViewControllerDelegate: class {
  func countryFlagSelectionDidSelectFlag(_ countryFlag: CountryFlag)
  func countryFlagSelectionDidFinished(_ countryFlag: CountryFlag)
}

class CountryFlagSelectionViewController: UIViewController {

  init() {
    let bundle = Bundle(for: CountryFlagSelectionViewController.classForCoder())
    super.init(nibName: "CountryFlagSelectionViewController", bundle: bundle)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  weak var delegate: CountryFlagSelectionViewControllerDelegate?
  var currentFlag: CountryFlag = CountryFlagHelper.currentCountryFlag()
  @IBOutlet weak var picker: UIPickerView!



  @IBAction func donePressed(_ sender: Any) {
    delegate?.countryFlagSelectionDidFinished(currentFlag)
    picker.delegate = nil
    self.dismiss(animated: true, completion: nil)
  }
}

extension CountryFlagSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return CountryFlagHelper.countryFlags.count
  }

  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 30
  }

  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

    let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 30))
    let myImageView = UIImageView(frame: CGRect(x: 0, y: 7, width: 30, height: 15))

    let flag = CountryFlagHelper.countryFlags[row]
    myImageView.image = flag.flag
    myImageView.contentMode = .scaleAspectFit

    let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 30))
    myLabel.font = UIFont.systemFont(ofSize: 16)
    myLabel.text = flag.name
    myView.addSubview(myLabel)
    myView.addSubview(myImageView)

    return myView
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentFlag = CountryFlagHelper.countryFlags[row]
    delegate?.countryFlagSelectionDidSelectFlag(currentFlag)
  }
}
