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

class RotinaViewController: UIViewController {

    @IBOutlet weak var tableViewRotina: UITableView!
    
    private let _rotinaRef = Database.database().reference().child("Rotinas")
    
    private var _rotinaArray : [Rotina] = [Rotina]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        addObserversRef()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        configureAddButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //removeObserversRef()
    }
    
    func configureAddButton() {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnIncluirPressed)
        )
    }
    
    @objc func btnIncluirPressed(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
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
    
    func addObserversRef() {

        _rotinaRef.observe(.childAdded) { (snapShot) in
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let rotina = Rotina(JSON: jsonArray)!
                
                rotina.autoKey = snapShot.key
                
                self._rotinaArray.append(rotina)
                
                self._rotinaArray.sort{$0.dataCriacao > $1.dataCriacao}
                
                self.recarregarTableView()
            }
        }
        
        _rotinaRef.observe(.childChanged) { (snapShot) in
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let rotina = Rotina(JSON: jsonArray)!
                
                rotina.autoKey = snapShot.key
                
                if let index = self._rotinaArray.index(where: { $0.autoKey == rotina.autoKey}) {
                    self._rotinaArray[index] = rotina
                }
            }
            
            self.recarregarTableView()
        }
        
        _rotinaRef.observe(.childRemoved) { (snapShot) in

            self._rotinaArray.remove({ $0.autoKey == snapShot.key })
            
            self.recarregarTableView()
        }
    }
    
    private func orderRotinaArray() {
        
        _rotinaArray.sort{ ($1.status,$0.dataCriacao) > ($0.status,$1.dataCriacao) }
    }
    
    func removeObserversRef() {
        
        _rotinaRef.removeAllObservers()
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
        
        orderRotinaArray()
        
        configureHeightCellTableView()
        
        tableViewRotina.reloadData()
    }
}

extension RotinaViewController: UITableViewDelegate, UITableViewDataSource {

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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let exercicioKeyRef = _rotinaRef.child(_rotinaArray[indexPath.row].autoKey)
            
            exercicioKeyRef.removeValue() {
                (error, reference)  in
                
                if let errorRemoving = error {
                    print(errorRemoving)
                }
                else {
                    print("Exercicio Removed!")
                }
            }
        }
    }
}
