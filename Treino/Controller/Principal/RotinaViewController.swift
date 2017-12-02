//
//  RotinaViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ObjectMapper

class RotinaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewRotina: UITableView!
    
    private var _rotinaArray : [Rotina] = [Rotina]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        carregarRotinas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        configureAddButton()
    }
    
    func configureAddButton() {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnIncluirPressed)
        )
    }
    
    @objc func btnIncluirPressed(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _rotinaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaCell", for : indexPath) as! CustomRotinaCell
        
        cell.updateUI(rotina: _rotinaArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: _rotinaArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let rotinaDetalhesVC = segue.destination as! RotinaDetalhesViewController
        
        if segue.identifier == "goToRotinaDetalhes"
        {
            if let rotina = sender as? Rotina {
                rotinaDetalhesVC.model = rotina
            }
        }
    }
    
    func carregarRotinas() {
        
        let rotinaDB = Database.database().reference().child("Rotinas")
        
        rotinaDB.observe(.childAdded) { (snapShot) in

            let rotina = Rotina(JSONString: snapShot.value as! String)!
            
            rotina.autoKey = snapShot.key
            
            self._rotinaArray.append(rotina)
            
            self.configureHeightCellTableView()
            
            self.recarregarTableView()
        }
    }
    
    func configureTableView() {
        
        tableViewRotina.delegate = self
        tableViewRotina.dataSource = self
        
        tableViewRotina.register(UINib(nibName : "CustomRotinaCell", bundle : nil), forCellReuseIdentifier: "customRotinaCell")
        
        tableViewRotina.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {
        
        tableViewRotina.rowHeight = UITableViewAutomaticDimension
        tableViewRotina.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        tableViewRotina.reloadData()
    }

}
