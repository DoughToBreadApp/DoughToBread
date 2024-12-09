//
//  DailyBreadViewModel.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation
//class for loading in scriptures and setting start day for first scripture
//this file provides the functionality required for decoding the JSON objects into DailyBread objects
//the code reads in the JSON file "scriptures" and decodes the objects into the scriptures array 
//where the scripture of the day will be accessed
//if the scriptures ever need to be changed, the stakeholder can provide a document of all new scriptures to add
//to replace the current scriptures in the JSON file, or a list of scriptures to add to the current JSON file
class DailyBreadViewModel: ObservableObject {
    @Published var dailyBread: DailyBread
    //var startDate holds first day daily bread starts
    //currently 11/03/2024
    var startDate: Date{
        var components = DateComponents()
                components.year = 2024
                components.month = 11
                components.day = 3
                return Calendar.current.date(from: components) ?? Date()
    }
    //array for loading in scriptures from JSON file "scriptures"
    var scriptures: [DailyBread] = []
    //keeps track of which scripture to output
    var daysSinceStart: Int = 0
    
    //constructor
    init(dailyBread: DailyBread = DailyBread(title: "Sample Title", verse: "Sample Verse", body: "Sample body")) {
        self.dailyBread = dailyBread
        getScriptures()
        calcDaysSinceStart()
    }
    
    func getScriptures() {
        //load in scriptures into daily bread array from JSON file
        if let bundlePath = Bundle.main.path(forResource: "scriptures", ofType: "json") {
            let url = URL(fileURLWithPath: bundlePath)
            do {
                        let data = try Data(contentsOf: url)
                        
                        // Decode the JSON data into an array of DailyBread objects
                        scriptures = try JSONDecoder().decode([DailyBread].self, from: data)
                        print(scriptures[0])
                    } catch {
                        print("Error loading or decoding JSON: \(error)")
                    }
                } else {
                    print("Could not find scriptures.json in the bundle.")
                }

    }
    //calculates the days that have passed since the start date
    func calcDaysSinceStart() {
        //get the current date
        let today = Date()
        let calendar = Calendar.current
        var days: DateComponents
        print(calendar)
        //get the number of days that have passed since the previously defined start date (11/01/24)
        //daysSinceStart = calendar.dateComponents([.day], from: startDate).day ?? 0
        days = calendar.dateComponents([.day], from: startDate, to: today)
        //cycle through scriptures so the index is within bounds
        daysSinceStart = (days.day! % scriptures.count) + 1
        print("days since start: \(daysSinceStart)")
    }
    
    //returns the verse of the day
    func getTodaysVerse() -> DailyBread {
        //use the daysSinceStart var to get the correct verse for the day
        if scriptures.isEmpty {
            return DailyBread(title: "empty", verse: "empty", body: "empty")
        }
        else {
            return scriptures[daysSinceStart - 1]
        }
    }
}
