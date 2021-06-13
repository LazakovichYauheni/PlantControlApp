//
//  Presenter.swift
//  PlantControlApp
//
//  Created by Eugeni Lazakovich on 12.06.21.
//

import Foundation
import DifferenceKit

final class Presenter {
    var arrayOfPlants: [PlantModel] = []
    //var selectedCell = 0
    var isExpanded = false
    
    private var selectedPlant: PlantModel?
    
    func initModalArray() -> [String] {
        ["Петрушка", "Картофель", "Редис", "Базилик", "Мята"]
    }
    
    func initArray() {
        let cucumberModel = PlantModel.init(
            name: "Огурец",
            dailyWaterRate: 20,
            dailyLightRate: 33,
            humidity: 60,
            waterLevel: 86,
            lightning: 20
        )
        
        let tomatoModel = PlantModel.init(
            name: "Помидор",
            dailyWaterRate: 99,
            dailyLightRate: 34,
            humidity: 15,
            waterLevel: 38,
            lightning: 33
        )
        
        let ukropModel = PlantModel.init(
            name: "Укроп",
            dailyWaterRate: 22,
            dailyLightRate: 34,
            humidity: 20,
            waterLevel: 30,
            lightning: 40
        )
        
        arrayOfPlants.append(cucumberModel)
        arrayOfPlants.append(tomatoModel)
        arrayOfPlants.append(ukropModel)
    }
    
    func createModels(selectedIndex: Int, isNewPlant: Bool) -> [PlantTableViewDataSource.Row] {
        if arrayOfPlants.isEmpty { return [] }
        var rows: [PlantTableViewDataSource.Row] = []
        selectedPlant = arrayOfPlants[selectedIndex]
        let temp = arrayOfPlants[0]


        if !isNewPlant {
            arrayOfPlants[0] = arrayOfPlants[selectedIndex]
            arrayOfPlants[selectedIndex] = temp
        } else {
            arrayOfPlants[0] = arrayOfPlants[arrayOfPlants.endIndex - 1]
            arrayOfPlants[arrayOfPlants.endIndex - 1] = temp
            selectedPlant = arrayOfPlants[0]

        }
        
        guard let selectedPlant = selectedPlant else { return [] }
        
        if isExpanded {
            rows = [.plants(.init(title: selectedPlant.name, isExpanded: isExpanded, isArrowHidden: false))]
        } else {
            rows = arrayOfPlants.compactMap { plant in
                return .plants(.init(title: plant.name, isExpanded: isExpanded, isArrowHidden: plant.id != selectedPlant.id))
            }
        }
        
        return rows
    }
    
    func getSelectedModel() -> PlantModel? {
        return selectedPlant
    }
    
    func createNewPlant(name: String) {
        let newPlant = PlantGenerator.generatePlant(name: name)
        arrayOfPlants.append(newPlant)
    }
}
