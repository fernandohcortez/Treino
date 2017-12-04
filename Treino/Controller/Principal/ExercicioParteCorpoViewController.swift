//
//  ExercicioParteCorpoViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 04/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

protocol ParteCorpoDelegate {
    func selectedParteCorpo (parteCorpo : String)
}

class ExercicioParteCorpoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate : ParteCorpoDelegate?
    
    @IBOutlet weak var tableViewParteCorpo: UITableView!
    
    private var _parteCorpoArray = ["Braço","Costa","Peito","Perna","Ombro","Abdomen","Corpo Inteiro","Cardio"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()

    }
    
    func configureTableView() {
        
        tableViewParteCorpo.delegate = self
        tableViewParteCorpo.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _parteCorpoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parteCorpoCell", for: indexPath)
        
        cell.textLabel?.text = _parteCorpoArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selectedParteCorpo(parteCorpo: _parteCorpoArray[indexPath.row])
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
