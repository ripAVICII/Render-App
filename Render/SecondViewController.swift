//
//  SecondViewController.swift
//  Render
//
//  Created by James Hilton-Barber on 21.02.20.
//  Copyright © 2020 James Hilton-Barber. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

     var render: Render?
      
      override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        render?.printInfo()
      }
      
      private func setup() {
        guard let render = render else { return }
        title = render.renderName
        render.loadCoverPhoto { [weak self] image in
            guard self != nil else { return }
            print("Success")
        }
      }


}
