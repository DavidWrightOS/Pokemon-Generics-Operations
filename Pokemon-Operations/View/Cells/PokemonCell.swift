//
//  PokemonCell.swift
//  Pokemon-Operations
//
//  Created by David Wright on 3/23/20.
//

import UIKit

class PokemonCell: UITableViewCell {

    // MARK: - Properties

    static let reuseID = "PokemonCell"
    
    var pokemon: PokemonResult? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private Methods

    private func updateViews() {
        guard let pokemon = pokemon else { return }
        nameLabel.text = pokemon.name
        
    }
}
