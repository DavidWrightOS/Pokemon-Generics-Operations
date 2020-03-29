//
//  Pokemon.swift
//  Pokemon-Operations
//
//  Created by David Wright on 3/23/20.
//

import Foundation

struct Pokemon: Decodable {
    
    // MARK: - Properties
    
    let name: String
    let height: Int
    let weight: Int
    let imageURL: URL
    let abilities: String
    let types: String
    
    // MARK: - Coding Keys
    
    enum PokemonKeys: String, CodingKey {
        case name
        case height
        case weight
        case sprites
        case abilities
        case types

        // Nested Coding Keys
        enum SpriteKeys: String, CodingKey {
            case imageURL = "front_default"
        }
        
        enum AbilitiesKeys: String, CodingKey {
            case ability
            
            enum AbilityKeys: String, CodingKey {
                case abilityName = "name"
            }
        }
        
        enum TypesKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case typeName = "name"
            }
        }
    }
    
    // MARK: - Decoder

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        // Decode 'name', 'height' and 'weight'
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        
        // Decode 'imageURL'
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        imageURL = try spriteContainer.decode(URL.self, forKey: .imageURL)
        
        // Decode 'abilities'
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        var abilityString = ""
        while !abilitiesContainer.isAtEnd {
            let abilitiesOuterContainer = try abilitiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilitiesKeys.self)
            let abilityInnerContainer = try abilitiesOuterContainer.nestedContainer(keyedBy: PokemonKeys.AbilitiesKeys.AbilityKeys.self, forKey: .ability)
            let ability = try abilityInnerContainer.decode(String.self, forKey: .abilityName).capitalized
            abilityString += " \(ability)"
        }
        abilities = abilityString
        
        // Decode 'types'
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        var typeString = ""
        while !typesContainer.isAtEnd {
            let typeOuterContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypesKeys.self)
            let typeInnerContainer = try typeOuterContainer.nestedContainer(keyedBy: PokemonKeys.TypesKeys.TypeKeys.self, forKey: .type)
            let type = try typeInnerContainer.decode(String.self, forKey: .typeName).capitalized
            typeString += " \(type)"
        }
        types = typeString
    }
    
    // MARK: - Encoder
    
    func encode(with encoder: Encoder) throws {

        
        // Encode 'name', 'height' and 'weight'
        
        
        // Encode 'imageURL'
        
        
        // Encode 'abilities'
        
        
        // Encode 'types'
        
    }
}
