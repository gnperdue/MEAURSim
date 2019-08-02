//
//  MEACards.swift
//  MEAURSim
//
//  Created by Gabriel Perdue on 8/2/19.
//  Copyright © 2019 Gabriel Perdue. All rights reserved.
//

import Foundation


protocol Stringable {
    func toString() -> String
}


enum Rank: Int, CaseIterable, Hashable, Stringable {
    case None, I, II, III, IV, V, VI, VII, VIII, IX, X
    mutating func increment() {
        let allCases = type(of: self).allCases
        if self != .X {
            self = allCases[allCases.firstIndex(of: self)! + 1]
        }
    }
    func toString() -> String {
        switch self {
        case .None:
            return "None"
        case .I:
            return "I"
        case .II:
            return "II"
        case .III:
            return "III"
        case .IV:
            return "IV"
        case .V:
            return "V"
        case .VI:
            return "VI"
        case .VII:
            return "VII"
        case .VIII:
            return "VIII"
        case .IX:
            return "IX"
        case .X:
            return "X"
        }
    }
}


enum CharacterCard: CaseIterable, Equatable, Hashable, Stringable {
    case AngaraAvenger, AngaraExemplar, AsariDuelist, BatarianVanguard
    case HumanKineticist, KroganGladiator, SalarianOperator
    func toString() -> String {
        switch self {
        case .AngaraAvenger:
            return "Angara Avenger"
        case .AngaraExemplar:
            return "Angara Exemplar"
        case .AsariDuelist:
            return "Asari Duelist"
        case .BatarianVanguard:
            return "Batarian Vanguard"
        case .HumanKineticist:
            return "Human Kineticist"
        case .KroganGladiator:
            return "Krogan Gladiator"
        case .SalarianOperator:
            return "Salarian Operator"
        }
    }
}


enum WeaponCard: CaseIterable, Equatable, Hashable, Stringable {
    case N7Valkyrie, PAW, Soned, Sovoa
    case N7Eagle, N7Hurricane, Rozerad, Silhesh, Ushior
    case Dhan, N7Crusader, N7Piranha, Shorty
    case BlackWidow, Inferno, KishockHarpoonGun, N7Valiant, Naladen
    func toString() -> String {
        switch self {
        case .N7Valkyrie:
            return "N7 Valkyrie"
        case .PAW:
            return "P.A.W."
        case .Soned:
            return "Soned"
        case .Sovoa:
            return "Sovoa"
        case .N7Eagle:
            return "N7 Eagle"
        case .N7Hurricane:
            return "N7 Hurricane"
        case .Rozerad:
            return "Rozerad"
        case .Silhesh:
            return "Silhesh"
        case .Ushior:
            return "Ushior"
        case .Dhan:
            return "Dhan"
        case .N7Crusader:
            return "N7 Crusader"
        case .N7Piranha:
            return "N7 Piranha"
        case .Shorty:
            return "Shorty"
        case .BlackWidow:
            return "Black Widow"
        case .Inferno:
            return "Inferno"
        case .KishockHarpoonGun:
            return "Kishock Harpoon Gun"
        case .N7Valiant:
            return "N7 Valiant"
        case .Naladen:
            return "Naladen"
        }
    }
}


enum Variant: CaseIterable, Equatable, Hashable, Stringable {
    case Base, Siphon, Concussive, Bulwark
    func toString() -> String {
        switch self {
        case .Base:
            return ""
        case .Siphon:
            return "Siphon"
        case .Concussive:
            return "Concussive"
        case .Bulwark:
            return "Bulwark"
        }
    }
}


struct WeaponCardVariant: Equatable, Hashable, Stringable {
    var weapon: WeaponCard
    var variant: Variant
    func toString() -> String {
        return variant == Variant.Base ? weapon.toString() :
            weapon.toString() + " " + variant.toString()
    }
}


class Rankable {
    var rank: Rank
    init(rank: Rank) {
        self.rank = rank
    }
}


class URWeaponCard: Rankable, Equatable, Stringable {
    var weaponVariant: WeaponCardVariant
    init(weapon: WeaponCard, variant: Variant, rank: Rank) {
        self.weaponVariant = WeaponCardVariant(weapon: weapon, variant: variant)
        super.init(rank: rank)
    }
    func toString() -> String {
        return weaponVariant.toString() + " " + rank.toString()
    }
    func incrementRank() -> Bool {
        if rank.rawValue < 10 {
            rank.increment()
            return true
        }
        return false
    }
    static func == (lhs: URWeaponCard, rhs: URWeaponCard) -> Bool {
        return lhs.weaponVariant == rhs.weaponVariant && lhs.rank == rhs.rank
    }
}


class URCharacterCard: Rankable, Equatable, Stringable {
    // could just make veteranRank start with Rank.None, but want to play
    // with optionals here...
    var character: CharacterCard
    var veteranRank: Rank?
    init(character: CharacterCard, rank: Rank, veteranRank: Rank?) {
        self.character = character
        self.veteranRank = veteranRank
        super.init(rank: rank)
        if let vr = veteranRank {
            if vr.rawValue < 10 {
                self.rank = Rank.X
            }
        }
    }
    func toString() -> String {
        let baseDescription = character.toString() + " " + rank.toString()
        if let vr = veteranRank {
            if vr != Rank.None {
                return baseDescription + vr.toString()
            }
        }
        return baseDescription
    }
    func incrementRank() -> Bool {
        // once rank hits ten, start adding to veteran rank
        if rank.rawValue < 10 {
            rank.increment()
            return true
        }
        if let veteranRaw = veteranRank?.rawValue {
            if veteranRaw < 10 {
                veteranRank?.increment()
                return true
            }
        } else {
            veteranRank = Rank.I
        }
        return false
    }
    static func == (lhs: URCharacterCard, rhs: URCharacterCard) -> Bool {
        return lhs.character == rhs.character && lhs.rank == rhs.rank && lhs.veteranRank == rhs.veteranRank
    }
}


class URCollection {
    var characters: [URCharacterCard] = []
    var weaponsBase: [URWeaponCard] = []
    var weaponsVariants: [URWeaponCard] = []
    init() {
        initURCharacterCardList()
        initURWeaponCardList()
    }
    
    func initURCharacterCardList() {
        for c in CharacterCard.allCases {
            characters.append(URCharacterCard(character: c, rank: Rank.None, veteranRank: nil))
        }
    }
    
    func initURWeaponCardList() {
        for w in WeaponCard.allCases {
            for v in Variant.allCases {
                if v == Variant.Siphon && w == WeaponCard.Sovoa {
                    continue
                }
                else {
                    let urw = URWeaponCard(weapon: w, variant: v, rank: Rank.None)
                    if v == Variant.Base {
                        weaponsBase.append(urw)
                    } else {
                        weaponsVariants.append(urw)
                    }
                }
            }
        }
    }
    
    func getEligibleVariants() -> Set<WeaponCardVariant> {
        var eligibleVariants = Set<WeaponCardVariant>()
        for w in weaponsBase {
            if w.rank == Rank.X {
                for v in [Variant.Siphon, Variant.Concussive, Variant.Bulwark] {
                    eligibleVariants.insert(WeaponCardVariant(weapon: w.weaponVariant.weapon, variant: v))
                }
            }
        }
        for w in weaponsVariants {
            if w.rank == Rank.X {
                let wv = WeaponCardVariant(weapon: w.weaponVariant.weapon, variant: w.weaponVariant.variant)
                eligibleVariants.remove(wv)
            }
        }
        return eligibleVariants
    }
    
    func getCharacterCardsRankedUnderX() -> Set<CharacterCard> {
        var eligibleCharacterCards = Set<CharacterCard>()
        for c in characters {
            if c.rank.rawValue < 10 {
                eligibleCharacterCards.insert(c.character)
            }
        }
        return eligibleCharacterCards
    }
    
    func getCharacterCardsRankedUnderXX() -> Set<CharacterCard> {
        var eligibleCharacterCards = Set<CharacterCard>()
        for c in characters {
            if let v = c.veteranRank?.rawValue {
                if v < 10 {
                    eligibleCharacterCards.insert(c.character)
                }
            } else {
                eligibleCharacterCards.insert(c.character)
            }
        }
        return eligibleCharacterCards
    }
    
    func getWeaponCardsRatedUnderX() -> Set<WeaponCardVariant> {
        var eligibleWeaponCardVariants = Set<WeaponCardVariant>()
        for w in weaponsBase {
            if w.rank.rawValue < 10 {
                eligibleWeaponCardVariants.insert(w.weaponVariant)
            }
        }
        // we only get a Variant here is all the Base Weapon cards are X
        if eligibleWeaponCardVariants.isEmpty {
            for w in weaponsVariants {
                if w.rank.rawValue < 10 {
                    eligibleWeaponCardVariants.insert(w.weaponVariant)
                }
            }
        }
        return eligibleWeaponCardVariants
    }
    
    func incrementCharacterCard(character: CharacterCard) -> Bool {
        if let idx = characters.firstIndex(where: {$0.character == character}) {
            return characters[idx].incrementRank()
        }
        return false
    }
    
    func incrementWeaponCard(weaponVariant: WeaponCardVariant) -> Bool {
        if let idx = (weaponsBase + weaponsVariants).firstIndex(where: {$0.weaponVariant == weaponVariant}) {
            return (weaponsBase + weaponsVariants)[idx].incrementRank()
        }
        return false
    }
    
    func display(verbose: Bool = false) {
        for c in characters {
            if !verbose && c.rank == Rank.None { continue }
            print(c.toString())
        }
        for w in (weaponsBase + weaponsVariants) {
            if !verbose && w.rank == Rank.None { continue }
            print(w.toString())
        }
    }
    
    func numberOfCharacters() -> Int {
        var n = 0
        for c in characters {
            n += c.rank.rawValue
            if let veteranRank = c.veteranRank?.rawValue {
                n += veteranRank
            }
        }
        return n
    }
    
    func numberOfWeapons() -> Int {
        var n = 0
        for w in (weaponsBase + weaponsVariants) {
            n += w.rank.rawValue
        }
        return n
    }
    
    func numberOfCards() -> Int {
        return numberOfCharacters() + numberOfWeapons()
    }
    
    func contains(character: URCharacterCard) -> Bool {
        if characters.firstIndex(of: character) != nil {
            return true
        }
        return false
    }
    
    func contains(weapon: URWeaponCard) -> Bool {
        if weaponsBase.firstIndex(of: weapon) != nil {
            return true
        }
        if weaponsVariants.firstIndex(of: weapon) != nil {
            return true
        }
        return false
    }
    
    func canAddCharacterCards() -> Bool {
        return numberOfCharacters() != 140
    }
    
    func canAddWeaponCards() -> Bool {
        return numberOfWeapons() != 720
    }
}
