//
//  ViewController.swift
//  PhoneTextFieldView
//
//  Created by P0nj4 on 03/01/2018.
//  Copyright (c) 2018 P0nj4. All rights reserved.
//

import UIKit
import PhoneTextFieldView

class ViewController: UIViewController {

  @IBOutlet weak var phone: PhoneTextFieldView!
  @IBOutlet weak var phoneResult: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    phone.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController: PhoneTextFieldViewDelegate {
  func phoneTextFieldView(_ phoneTextFieldView: PhoneTextFieldView, phoneTextDidChange phoneText: String) {
    phoneResult.text = phoneText
  }

  func phoneTextFieldViewWillPresentFlagsOn() -> UIViewController {
    return self
  }
}

