//
//  TreinoViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 29/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class TreinoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //var treinoArray = 

    @IBOutlet weak var tableViewTreino: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewTreino.delegate = self
        tableViewTreino.dataSource = self
        
        //self.navigationItem.leftBarButtonItem = nil
        //self.navigationItem.hidesBackButton = true;
        
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func btnNovaRotinaPressed(_ sender: UIButton) {
    }
    
    //MARK: - tableViewTreino Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
}
