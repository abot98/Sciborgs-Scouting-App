//
//  File.swift
//  ScoutingApp2016
//
//  Created by Oran Luzon on 1/26/16.
//  Copyright © 2016 Sciborgs. All rights reserved.
//

import UIKit

class RoundSelectionView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var title: UILabel!
    var tableView: UITableView!
    var cells: [UITableViewCell!]!
    
    var matches: [JSON]!
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.addBackButton()
        
        matches = []
        cells = []
        
        title = BasicLabel(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height), text: "Matches", fontSize: 60, color: UIColor.darkGrayColor(), position: CGPoint(x: Screen.width/2, y: Screen.height/8))
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height - Screen.height/4), style: UITableViewStyle.Plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        self.addBackButton()
        
        BlueAlliance.sendRequestMatches(CompetitionCode.Javits, completion: {(matches: [JSON]) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.matches = matches
                for match in matches {
                    var matchNum = String(match["match_number"].int!)
                    if(matchNum.characters.count != 2) {
                        matchNum = "0\(matchNum)"
                    }
                    
                    self.makeCell("Qualifying Match", matchNumber: matchNum)
                    self.tableView.reloadData()
                }
            })
        })
    
        
        tableView.center = CGPoint(x: Screen.width/2, y: Screen.height/2 + Screen.height/8)
        
        self.addSubview(tableView)
        self.addSubview(title)
    }
    
    func back(){
        self.goBack()
        self.removeNavBar()
    }
    
    func makeCell(type: String, matchNumber: String){
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height - Screen.height/8))
        let matchType = UILabel(frame: cell.frame)
        let matchNum = UILabel(frame: cell.frame)
        
        matchType.text = type
        matchNum.text = matchNumber
        
        matchType.textAlignment = NSTextAlignment.Left
        matchType.center = CGPoint(x: matchType.center.x + Screen.width * 0.05, y: matchType.center.y)
        
        matchNum.textAlignment = NSTextAlignment.Center
        if(UIDevice.currentDevice().modelName == "iPhone 5s" || UIDevice.currentDevice().modelName == "iPhone 5c" || UIDevice.currentDevice().modelName == "iPhone 5" || UIDevice.currentDevice().modelName == "iPhone 4") {
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/2.5), y: matchNum.center.y)
        }else if (UIDevice.currentDevice().modelName == "iPhone 6" || UIDevice.currentDevice().modelName == "iPhone 6s"){
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/2.1), y: matchNum.center.y)
        }else if (UIDevice.currentDevice().modelName == "iPhone 6 Plus" || UIDevice.currentDevice().modelName == "iPhone 6s Plus") {
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/1.9), y: matchNum.center.y)
        }else if (UIDevice.currentDevice().modelName == "iPad 2" || UIDevice.currentDevice().modelName == "iPad 3" || UIDevice.currentDevice().modelName == "iPad 4" || UIDevice.currentDevice().modelName == "iPad Air" || UIDevice.currentDevice().modelName == "iPad Air 2") {
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/2.7), y: matchNum.center.y)
        }else if (UIDevice.currentDevice().modelName.containsString("iPad")) {
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/2.7), y: matchNum.center.y)
        }else {
            matchNum.center = CGPoint(x: matchNum.center.x + (Screen.width/2.1), y: matchNum.center.y)
        }
        

        cell.contentView.addSubview(matchType)
        cell.contentView.addSubview(matchNum)
        
        cells.append(cell)
        tableView.insertSubview(cell, atIndex: cells.count-1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Link to team profile
        
        var allTeamJSONS: [String: JSON] = [:]
        
        DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(matches[indexPath.row], color: "blue")[0], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
            var teamJSON = result
            allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue")[0])"] = teamJSON
            DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue")[1], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
                var teamJSON = result
                allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue")[1])"] = teamJSON
                DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue")[2], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
                    var teamJSON = result
                    allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue")[2])"] = teamJSON
                    DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[0], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
                        var teamJSON = result
                        allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[0])"] = teamJSON
                        DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[1], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
                            var teamJSON = result
                            allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[1])"] = teamJSON
                            DBManager.pull(ParseClass.SouthFlorida.rawValue, rowKey: "teamNumber", rowValue: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[2], finalKey: "TeamInfo", completion: {(result: JSON) -> Void in
                                var teamJSON = result
                                allTeamJSONS["\(BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red")[2])"] = teamJSON
                                
                                var scoutedCounter = 0
                                for (kind,team) in allTeamJSONS {
                                    for round in team["rounds"].arrayValue {
                                        if(round["roundNumber"].intValue == indexPath.row+1) {
                                            scoutedCounter = scoutedCounter + 1
                                        }
                                    }
            
                                }
                                self.launchViewOnTop(TeamAssignmentView(
                                    blueTeams: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "blue"),
                                    redTeams: BlueAlliance.getTeamsFromMatch(self.matches[indexPath.row], color: "red"),
                                    roundNumber:  indexPath.row+1,
                                    mode: AssignmentMode.SCOUT,
                                    teamJSON: allTeamJSONS
                                ))
                            })
                        })
                    })
                })
            })
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
