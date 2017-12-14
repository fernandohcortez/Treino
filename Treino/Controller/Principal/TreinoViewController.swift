//
//  TreinoViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 29/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TreinoViewController: UIViewController {

    @IBOutlet weak var tableViewTreino: UITableView!
    
    private let _rotinaRef = Database.database().reference().child("Rotinas")
    
    private var _rotinaArray : [Rotina] = [Rotina]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureTableView()
        
        addObserversRef()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       hideBackButton()
    }
    
    func configureTableView() {
        
        tableViewTreino.delegate = self
        tableViewTreino.dataSource = self
        
        tableViewTreino.register(UINib(nibName : "CustomRotinaCell", bundle : nil), forCellReuseIdentifier: "customRotinaCell")
        
        tableViewTreino.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {

        tableViewTreino.rowHeight = UITableViewAutomaticDimension
        tableViewTreino.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        configureHeightCellTableView()
        
        tableViewTreino.reloadData()
    }
    
    func hideBackButton() {
        
         self.tabBarController?.navigationItem.rightBarButtonItem = nil
         self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @IBAction func btnNovaRotinaPressed(_ sender: UIButton) {
    
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTreinoDetalhes"
        {
            if let rotina = sender as? Rotina {
                
                let treinoDetalhesPageVC = segue.destination as! TreinoDetalhesPageViewController

                for var exercicio in rotina.exercicios {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let treinoDetalhesVC = storyboard.instantiateViewController(withIdentifier :"treinoDetalhesViewController") as! TreinoDetalhesViewController
                    
                    treinoDetalhesVC.delegate = treinoDetalhesPageVC
                    
                    treinoDetalhesVC.model = rotina
                    
                    treinoDetalhesVC.setRotinaExerciciosModel(exercicio)
                    
                    if exercicio === rotina.exercicios.last! {
                        treinoDetalhesVC.setAsLastExercise()
                    }
                    
                    treinoDetalhesPageVC.addTreinoDetalhesViewController(treinoDetalhesVC)
                }
            }
        }
        else if segue.identifier == "goToRotinaDetalhes" {
            
            let rotinaDetalhesVC = segue.destination as! RotinaDetalhesViewController
            
            if let rotina = sender as? Rotina {
                rotinaDetalhesVC.model = rotina
            }
        }
    }
    
    func addObserversRef() {
        
        let rotinaRefStatusAtivo = _rotinaRef.queryOrdered(byChild: "status").queryEqual(toValue: "A")
        
        rotinaRefStatusAtivo.observe(.childAdded) { (snapShot) in
            
            SVProgressHUD.show()
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let rotina = Rotina(JSON: jsonArray)!
                
                rotina.autoKey = snapShot.key
                
                self._rotinaArray.append(rotina)
            }
            
            self.recarregarTableView()
            
            SVProgressHUD.dismiss()
        }
        
        _rotinaRef.observe(.childChanged) { (snapShot) in
            
            SVProgressHUD.show()
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let rotina = Rotina(JSON: jsonArray)!
                
                rotina.autoKey = snapShot.key
                
                // Arquivado
                if rotina.status == "Q" {

                    self._rotinaArray.remove({ $0.autoKey == rotina.autoKey })
                }
                // Ativo
                else if rotina.status == "A" {
                    
                    if let index = self._rotinaArray.index(where: { $0.autoKey == rotina.autoKey}) {
                        self._rotinaArray[index] = rotina
                    }
                    else {
                        self._rotinaArray.append(rotina)
                    }
                }
            }
            
            self.recarregarTableView()
            
            SVProgressHUD.dismiss()
        }
        
        _rotinaRef.observe(.childRemoved) { (snapShot) in
            
            SVProgressHUD.show()
            
            self._rotinaArray.remove({ $0.autoKey == snapShot.key })
            
            self.recarregarTableView()
            
            SVProgressHUD.dismiss()
        }
    }
}

extension TreinoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _rotinaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaCell", for : indexPath) as! CustomRotinaCell
        
        cell.updateUI(rotina: _rotinaArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToTreinoDetalhes", sender: _rotinaArray[indexPath.row])
    }
}
