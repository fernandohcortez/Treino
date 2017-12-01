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
    
    var rotinaArray : [Rotina] = [Rotina]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRotina.delegate = self
        tableViewRotina.dataSource = self
        
        tableViewRotina.register(UINib(nibName : "CustomRotinaCell", bundle : nil), forCellReuseIdentifier: "customRotinaCell")
        
        CarregarRotinas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnIncluirPressed)
        )
    }
    
    @objc func btnIncluirPressed(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rotinaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaCell", for : indexPath) as! CustomRotinaCell
        
        cell.updateUI(rotina: rotinaArray[indexPath.row])
        
        
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

            let rotina = Rotina(JSONString: snapShot.value as! String)!
            
            
            //rotina.nome = snapShot.value(forKey: "nome") as! String
            //rotina.status = snapShot.value(forKey: "status") as! String
            //rotina.observacao = snapShot.value(forKey: "observacao") as! String
            //rotina.dataCriacao = snapShot.value(forKey: "dataCriacao") as! Date
            //rotina.dataUltimaAtualizacao = snapShot.value(forKey: "dataUltimaAtualizacao") as! Date
            
            self.rotinaArray.append(rotina)
            
            //self.configureTableView()
            self.tableViewRotina.reloadData()
        }
    }

}
