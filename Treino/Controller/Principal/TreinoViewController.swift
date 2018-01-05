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

        configureComponents()
        
        addObserversRef()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        hideBackButton()
        
        configureRightNavBarButtonAsReorder()
    }
    
    private func configureComponents() {

        configureTableView()
    }
    
    private func configureRightNavBarButtonAsReorder() {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnReorderPressed)
        )
    }
    
    private func configureRightNavBarButtonAsDone() {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnReorderDonePressed)
        )
    }
    
    @objc private func btnReorderPressed(sender: UIBarButtonItem) {
        
        configureRightNavBarButtonAsDone()
        
        tableViewTreino.setEditing(true, animated: false)
    }
    
    @objc private func btnReorderDonePressed(sender: UIBarButtonItem) {
        
        saveDataWithTransaction()
        
        configureRightNavBarButtonAsReorder()
        
        tableViewTreino.setEditing(false, animated: false)
    }
    
    private func configureTableView() {
        
        tableViewTreino.delegate = self
        tableViewTreino.dataSource = self
        
        tableViewTreino.register(UINib(nibName : "CustomRotinaCell", bundle : nil), forCellReuseIdentifier: "customRotinaCell")
        
        tableViewTreino.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    private func configureHeightCellTableView() {

        tableViewTreino.rowHeight = UITableViewAutomaticDimension
        tableViewTreino.estimatedRowHeight = 150.0
    }
    
    private func reloadTableView() {
        
        configureHeightCellTableView()
        
        tableViewTreino.reloadData()
    }
    
    private func hideBackButton() {
        
         //self.tabBarController?.navigationItem.rightBarButtonItem = nil
         self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @IBAction func btnNovaRotinaPressed(_ sender: UIButton) {
    
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTreinoDetalhesIniciar"
        {
            if let rotina = sender as? Rotina {
                
                let treinoDetalhesIniciarVC = segue.destination as! TreinoDetalhesIniciarViewController
                
                treinoDetalhesIniciarVC.model = rotina
            }
        }
        else if segue.identifier == "goToRotinaDetalhes" {
            
            let rotinaDetalhesVC = segue.destination as! RotinaDetalhesViewController
            
            if let rotina = sender as? Rotina {
                rotinaDetalhesVC.model = rotina
            }
        }
    }
    
    private func addObserversRef() {
        
        let rotinaRefStatusAtivo = _rotinaRef.queryOrdered(byChild: "status").queryEqual(toValue: "A")
        
        rotinaRefStatusAtivo.observe(.childAdded) { (snapShot) in
            
            self.enableDisableComponentsDuringProcessing(enable: false)
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let rotina = Rotina(JSON: jsonArray)!
                
                rotina.autoKey = snapShot.key
                
                self._rotinaArray.append(rotina)
                
                self._rotinaArray.sort {$0.ordem < $1.ordem}
                
                self.reloadTableView()
            }
            
            self.enableDisableComponentsDuringProcessing(enable: true)
        }
        
        _rotinaRef.observe(.childChanged) { (snapShot) in
            
            self.enableDisableComponentsDuringProcessing(enable: false)
            
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
            
            self.reloadTableView()
            
            self.enableDisableComponentsDuringProcessing(enable: true)
        }
        
        _rotinaRef.observe(.childRemoved) { (snapShot) in
            
            self.enableDisableComponentsDuringProcessing(enable: false)
            
            self._rotinaArray.remove({ $0.autoKey == snapShot.key })
            
            self.reloadTableView()
            
            self.enableDisableComponentsDuringProcessing(enable: true)
        }
    }
    
    private func saveDataWithTransaction() {
        
        enableDisableComponentsDuringProcessing(enable: false)
        
        let rotinaRefStatusAtivoRef = _rotinaRef.queryOrdered(byChild: "status").queryEqual(toValue: "A").ref
        
        rotinaRefStatusAtivoRef.runTransactionBlock(
            { currentData in
                return self.saveDataTransactionBlock(with: currentData)
                
        }) { error, completion, snapshot in
            
            self.saveDataTransactionBlockCompleted(error, completion)
        }
    }
    
    private func saveDataTransactionBlock(with currentData: MutableData) -> TransactionResult {
        
        guard let jsonDictRotinas = currentData.value as? [String : AnyObject] else { return .abort() }
        
        var jsonDictRotinasOrdered = [String : AnyObject]()
        
        for jsonRotina in jsonDictRotinas {
            
            if let jsonDictRotina = jsonRotina.value as? [String : AnyObject],
                let ordemArray = self._rotinaArray.index(where: {$0.autoKey == jsonRotina.key}),
                let rotina = Rotina(JSON: jsonDictRotina) {
                
                rotina.autoKey = jsonRotina.key
                rotina.ordem = ordemArray
                
                jsonDictRotinasOrdered.updateValue(rotina.toJSON() as AnyObject, forKey: jsonRotina.key)
            }
        }
        
        currentData.value = jsonDictRotinasOrdered
        
        return .success(withValue: currentData)
    }
    
    private func saveDataTransactionBlockCompleted(_ error: Error?, _ completion: Bool){
        
        if let error = error {
            Message.CreateAlert(viewController: self, message: error.localizedDescription)
        }
        else if !completion {
            Message.CreateAlert(viewController: self, message: "Rotinas não encontradas. O processo foi abortado.")
        }
        
        self.enableDisableComponentsDuringProcessing(enable: true)
    }
    
    private func enableDisableComponentsDuringProcessing(enable:Bool) {
        
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = enable
        self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = enable
        
        tableViewTreino.isUserInteractionEnabled = enable
        
        enable ? SVProgressHUD.dismiss() : SVProgressHUD.show()
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
        
        performSegue(withIdentifier: "goToTreinoDetalhesIniciar", sender: _rotinaArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        reorderRowTableView(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    private func reorderRowTableView(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        
        let movedTreino = _rotinaArray[sourceIndexPath.row]
        _rotinaArray.remove(at: sourceIndexPath.row)
        _rotinaArray.insert(movedTreino, at: destinationIndexPath.row)
        
        reloadTableView()
    }
}
