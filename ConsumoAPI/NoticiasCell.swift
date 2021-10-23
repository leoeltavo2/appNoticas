//
//  NoticiasCell.swift
//  ConsumoAPI
//
//  Created by Mac3 on 22/10/21.
//

import UIKit

class NoticiasCell: UITableViewCell {

    @IBOutlet weak var imagenNoticias: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblTexto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
