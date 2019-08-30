//
//  main.swift
//  MEAURSim
//
//  Created by Gabriel Perdue on 8/2/19.
//  Copyright © 2019 Gabriel Perdue. All rights reserved.
//

import Foundation

// The correct way to invoke the program will be to supply a `-n` flag to
// indicate the number of URs to draw or a `-c` flag to indicate a specific
// card to stop on. Note - we don't plan on carefully parsing the card to
// manage spelling errors, etc.

enum OptionType: String {
    case number = "n"       // total number of URs
    case card = "c"         // specific card for stopping condition
    case unknown
    
    init(value: String) {
        switch value {
        case "n":
            self = .number
        case "c":
            self = .card
        default:
            self = .unknown
        }
    }
}

func getOption(_ option: String) -> OptionType {
    return OptionType(value: option)
}


let argCount = CommandLine.argc
let argument = CommandLine.arguments[1]
let subRange = argument.index(after: argument.startIndex)..<argument.endIndex
let option = getOption(String(argument[subRange]))

// TODO - if the option type is a card, set the value we loop until to
// the max possible number of URs. If it is a number, set the loop until that
// number and set the stopping card condition to nil.

let value: Int
if let v = Int(CommandLine.arguments[2]) {
    value = v
} else {
    value = 0
}

print("Argument count: \(argCount) Option: \(option) value: \(value)")


let sim = MEASimulation()

var collection = URCollection()
collection.display()

for _ in 1...value {
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
