//
//  CustomHistoricoCell.swift
//  Treino
//
//  Created by Fernando Cortez on 10/01/18.
//  Copyright © 2018 Fernando Cortez. All rights reserved.
//

import UIKit

class CustomHistoricoCell: UITableViewCell {
    
    @IBOutlet weak var labelDuracao: UILabel!
    @IBOutlet weak var labelNomeRotina: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelObservacao: UILabel!
    @IBOutlet weak var imageViewFinalizado: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(treino: Treino) {
        
        labelNomeRotina.text = treino.rotina?.nome
        labelData.text = DateFormatter.localizedString(from: treino.dataHoraInicio, dateStyle: .medium, timeStyle: .none)
        labelDuracao.text = treino.duracao
        labelObservacao.text = treino.observacao
        imageViewFinalizado.image = treino.finalizado ? UIImage(named: "StatusRotinaActive") : UIImage(named: "StatusRotinaArchived")
    }
    
}
