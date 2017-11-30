//
//  customRotinaCell.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class CustomRotinaCell: UITableViewCell {

    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelExercicios: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!
    
    enum StatusRotina {
        case Ativo
        case Arquivado
    }
    
    var status : StatusRotina?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if status == StatusRotina.Ativo {
            imageViewStatus.image = UIImage(named: "StatusRotinaActive")
        }
        else if status == StatusRotina.Arquivado {
            imageViewStatus.image = UIImage(named: "StatusRotinaArchived")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
