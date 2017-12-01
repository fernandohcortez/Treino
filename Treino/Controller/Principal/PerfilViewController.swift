//
//  PerfilViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditarPressed)
        )
    }
    
    @objc func btnEditarPressed(sender: UIBarButtonItem) {
        print("btnEditarPressed")
    }
}
