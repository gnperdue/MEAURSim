//
//  MEASim.swift
//  MEAURSim
//
//  Created by Gabriel Perdue on 8/2/19.
//  Copyright © 2019 Gabriel Perdue. All rights reserved.
//

import Foundation


class MEASimulation {
    
    func getNewCardForURCollection(collection: URCollection) -> (WeaponCardVariant?, CharacterCard?) {
        func getCharacterCard(collection: URCollection) -> CharacterCard? {
            let underX = collection.getCharacterCardsRankedUnderX()
            if underX.isEmpty {
                let underXX = collection.getCharacterCardsRankedUnderXX()
                if !underXX.isEmpty {
                    return underXX.randomElement()
                }
            } else {
                return underX.randomElement()
            }
            return nil
        }
        func getWeaponCardVariant(collection: URCollection) -> WeaponCardVariant? {
            let underX = collection.getWeaponCardsRatedUnderX()
            if !underX.isEmpty {
                return underX.randomElement()
            }
            return nil
        }
        let variantRandomRoll = Float.random(in: 0..<1)
        if variantRandomRoll < 0.1 {
            let eligbleVariantSet = collection.getEligibleVariants()
            if !eligbleVariantSet.isEmpty {
                return (eligbleVariantSet.randomElement(), nil)
            }
        }
        let weaponProbability = collection.canAddWeaponCards() ? Float.random(in: 0..<1) : 0.0
        let characterProbability = collection.canAddCharacterCards() ? Float.random(in: 0..<1) : 0.0
        let candidateWeaponCard: WeaponCardVariant? = getWeaponCardVariant(collection: collection)
        let candidateCharacterCard: CharacterCard? = getCharacterCard(collection: collection)
        print(weaponProbability, characterProbability)
        if characterProbability > weaponProbability {
            if let c = candidateCharacterCard {
                return (nil, c)
            }
            if let w = candidateWeaponCard {
                return (w, nil)
            }
        } else {
            if let w = candidateWeaponCard {
                return (w, nil)
            }
            if let c = candidateCharacterCard {
                return (nil, c)
            }
        }
        return (nil, nil)
    }

}
