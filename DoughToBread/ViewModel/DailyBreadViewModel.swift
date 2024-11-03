//
//  DailyBreadViewModel.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation
//might need to import firestore/firebase if we choose to store verses in firebase

class DailyBreadViewModel: ObservableObject {
    @Published var dailyBread: DailyBread
    var startDate: Date{
        var components = DateComponents()
                components.year = 2024
                components.month = 11
                components.day = 3
                return Calendar.current.date(from: components) ?? Date()
    }
    var scriptures: [DailyBread] = []
    var daysSinceStart: Int = 0
    
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
