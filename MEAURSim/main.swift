//
//  main.swift
//  MEAURSim
//
//  Created by Gabriel Perdue on 8/2/19.
//  Copyright © 2019 Gabriel Perdue. All rights reserved.
//

import Foundation


let sim = MEASimulation()

var collection = URCollection()
collection.display()

for _ in 1...400 {
    // can also just use type inference, var (w, c) = ...
    let (w, c): (WeaponCardVariant?, CharacterCard?) =
        sim.getNewCardForURCollection(collection: collection)
    
    if let weap = w {
        print(weap)
        let incrementable = collection.incrementWeaponCard(weaponVariant: weap)
        if !incrementable {
            print(weap.toString() + " was not incrementable.")
        }
    }
    if let ch = c {
        print(ch)
        let incrementable = collection.incrementCharacterCard(character: ch)
        if !incrementable {
            print(ch.toString() + " was not incrementable.")
        }
    }
}
collection.display()

print(collection.numberOfCards())
