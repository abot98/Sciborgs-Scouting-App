//
//  Team.swift
//  ScoutingApp2016
//
//  Created by Yoli Meydan on 1/15/16.
//  Copyright © 2016 Sciborgs. All rights reserved.
//

import Foundation
import Parse
import Bolts

public enum Defences {
    case Portcullis
    case ChevalDeFrise
    case Moat
    case Ramparts
    case Drawbridge
    case SallyPort
    case RockWall
    case RoughtTerrain
    case LowBar
}

//Represents data for a SPECIFIC ROUND

class Team {
    
    var matches: [Int]?
    var teamNumber: Int?
    var roundNumber: Int?
    
    var jsonObject: [String: AnyObject]
    
    var numTimesCrossedPortcullis: Int = 0
    var numTimesCrossedChevalDeFrise: Int = 0
    var numTimesCrossedMoat: Int = 0
    var numTimesCrossedRamparts: Int = 0
    var numTimesCrossedDrawbridge: Int = 0
    var numTimesCrossedSallyPort: Int = 0
    var numTimesCrossedRockWall: Int = 0
    var numTimesCrossedRoughTerrain: Int = 0
    var numTimesCrossedLowBar: Int = 0
    
    var comment: String?
    
    var pfObject: PFObject?
    
    init(teamNumber: Int!, roundNumber: Int!) {
        self.teamNumber = teamNumber
        self.roundNumber = roundNumber
        
        jsonObject = ["teamNumber": self.teamNumber!]
        jsonObject = ["roundNumber": self.roundNumber!]
        
        comment = ""
        
        pfObject = PFObject(className: "Team\(self.teamNumber!)")
    }
    
    func crossedDefence(defence: Defences) {
        switch(defence) {
        case Defences.Portcullis:
            numTimesCrossedPortcullis++
            break
        case Defences.ChevalDeFrise:
            numTimesCrossedChevalDeFrise++
            break
        case Defences.Moat:
            numTimesCrossedMoat++
            break
        case Defences.Ramparts:
            numTimesCrossedRamparts++
            break
        case Defences.Drawbridge:
            numTimesCrossedDrawbridge++
            break
        case Defences.SallyPort:
            numTimesCrossedSallyPort++
            break
        case Defences.RockWall:
            numTimesCrossedRockWall++
            break
        case Defences.RoughtTerrain:
            numTimesCrossedRoughTerrain++
            break
        case Defences.LowBar:
            numTimesCrossedLowBar++
            break
        }
    }
    
    func addComment(comment: String!) {
        self.comment = comment
    }
    
    func finalizeJSON() {
        
        jsonObject["crossedPortcullis"] = self.numTimesCrossedPortcullis
        jsonObject["crossedChevalDeFrise"] = self.numTimesCrossedChevalDeFrise
        jsonObject["crossedMoat"] = self.numTimesCrossedMoat
        jsonObject["crossedRamparts"] = self.numTimesCrossedRamparts
        jsonObject["crossedDrawbridge"] = self.numTimesCrossedDrawbridge
        jsonObject["crossedSallyPort"] = self.numTimesCrossedSallyPort
        jsonObject["crossedRockWall"] = self.numTimesCrossedRockWall
        jsonObject["crossedRoughTerrain"] = self.numTimesCrossedRoughTerrain
        jsonObject["crossedLowBar"] = self.numTimesCrossedLowBar
        
        jsonObject["Comment"] = self.comment

        let valid = NSJSONSerialization.isValidJSONObject(jsonObject)
        if(valid) {
            pfObject!.addObject(jsonObject, forKey: "Round\(self.roundNumber!)")
            pfObject!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if(succeeded) {
                    print("Sent JSON")
                }else {
                    print("Didnt send: \(error?.description)")
                }
            }
        }
    }
    
    func getPFObject() -> PFObject {
        return pfObject!
    }
    
    func resetData() {
        numTimesCrossedPortcullis = 0
        numTimesCrossedChevalDeFrise = 0
        numTimesCrossedMoat = 0
        numTimesCrossedRamparts = 0
        numTimesCrossedDrawbridge = 0
        numTimesCrossedSallyPort = 0
        numTimesCrossedRockWall = 0
        numTimesCrossedRoughTerrain = 0
        numTimesCrossedLowBar = 0
        
        comment = ""
        roundNumber = 0
    }
}















