//
//  HistoricoViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper

class HistoricoViewController: UIViewController {

    @IBOutlet weak var historicoTableView: UITableView!
    
    private var _treinoRef : DatabaseReference!
    private var _treinoArray : [Treino] = [Treino]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureDatabaseReferenceByUser()
        
        configureTableView()
        
        retrieveAllTreinos()
    }

    override func viewDidAppear(_ animated: Bool) {
        configureAddButton()
    }
    
    private func configureDatabaseReferenceByUser() {
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            
            Message.CreateAlert(viewController: self, message: "Usuário não autenticado. Refaça o login.")
            
            dismiss(animated: true, completion: nil)
            
            //navigationController?.popViewController(animated: true)
            
            return
        }
        
        _treinoRef = Database.database().reference().child("Treinos").child(userUID)
    }
    
    private func configureAddButton() {
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    private func configureTableView() {
        
        historicoTableView.delegate = self
        historicoTableView.dataSource = self
        
        historicoTableView.register(UINib(nibName : "CustomHistoricoCell", bundle : nil), forCellReuseIdentifier: "customHistoricoCell")
        
        //historicoTableView.register(CustomHistoricoCell.self, forCellReuseIdentifier: "customHistoricoCell")
        
        //historicoTableView.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    private func configureHeightCellTableView() {
        
        historicoTableView.rowHeight = UITableViewAutomaticDimension
        historicoTableView.estimatedRowHeight = 150.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let historicoDetalhesVC = segue.destination as! HistoricoDetalhesViewController
        
        if segue.identifier == "goToHistoricoDetalhes"
        {
            if let treino = sender as? Treino {
                historicoDetalhesVC.model = treino
            }
        }
    }
    
    private func retrieveAllTreinos() {
        
        _treinoRef.observeSingleEvent(of: .value) { (snapShot) in
            
            if let jsonDictTreinos = snapShot.value as? [String : AnyObject] {
                
                for jsonTreino in jsonDictTreinos {
                    
                    if let jsonDictTreino = jsonTreino.value as? [String : AnyObject] {
                        
                        let treino = Treino(JSON: jsonDictTreino)!
                        
                        treino.autoKey = jsonTreino.key
                        
                        self._treinoArray.append(treino)
                    }
                }
                
                self.reloadDataTableView()
            }
        }
    }
    
    private func reloadDataTableView() {
        
        //orderRotinaArray()
        
        configureHeightCellTableView()
        
        historicoTableView.reloadData()
    }
}

extension HistoricoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _treinoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "customHistoricoCell", for : indexPath) as! CustomHistoricoCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customHistoricoCell", for : indexPath) as! CustomHistoricoCell
        
        cell.updateUI(treino: _treinoArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToHistoricoDetalhes", sender: _treinoArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let treinoKeyRef = _treinoRef.child(_treinoArray[indexPath.row].autoKey)
            
            treinoKeyRef.removeValue() {
                (error, reference)  in
                
                if let errorRemoving = error {
                    print(errorRemoving)
                }
                else {
                    print("Historico Removed!")
                }
            }
        }
    }
}
