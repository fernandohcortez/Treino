//
//  customRotinaCell.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class CustomRotinaCell: UITableViewCell {

    @IBOutlet private weak var labelNome: UILabel!
    @IBOutlet private weak var labelExercicios: UILabel!
    @IBOutlet private weak var imageViewStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(rotina: Rotina) {
        
        labelNome.text = rotina.nome
        labelExercicios.text = rotina.observacao
        imageViewStatus.image = rotina.status == "A" ? UIImage(named: "StatusRotinaActive") : UIImage(named: "StatusRotinaArchived")
    }
}
