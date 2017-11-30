//
//  RotinaViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RotinaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewRotina: UITableView!
    
    var rotinaArray : [Rotina] = [Rotina]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRotina.delegate = self
        tableViewRotina.dataSource = self
        
        CarregarRotinas()
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rotinaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaCell", for : indexPath) as! CustomRotinaCell
        
        cell.labelNome.text = rotinaArray[indexPath.row].nome
        cell.labelExercicios.text = "Teste Teste Teste"
        
        if rotinaArray[indexPath.row].status == "A" {
            cell.status = CustomRotinaCell.StatusRotina.Ativo
        }
        else {
            cell.status = CustomRotinaCell.StatusRotina.Arquivado
        }
        
        
        //if cell.senderUsername.text == Auth.auth().currentUser?.email {
        //    cell.avatarImageView.backgroundColor = UIColor.flatMint()
        //    cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        //}
        //else {
       //     cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
       //     cell.messageBackground.backgroundColor = UIColor.flatGray()
       // }
        
        return cell
    }
    
    func CarregarRotinas() {
        
        let rotinaDB = Database.database().reference().child("Rotinas")
        
        rotinaDB.observe(.childAdded) { (snapShot) in

            let rotina = Rotina()
            rotina.nome = snapShot.value(forKey: "Nome") as! String
            rotina.status = snapShot.value(forKey: "Status") as! String
            rotina.observacao = snapShot.value(forKey: "Observacao") as! String
            rotina.dataCriacao = snapShot.value(forKey: "DataCriacao") as! Date
            rotina.dataUltimaAtualizacao = snapShot.value(forKey: "DataUltimaAtualizacao") as! Date
            
            self.rotinaArray.append(rotina)
            
            //self.configureTableView()
            self.tableViewRotina.reloadData()
        }
    }

}
