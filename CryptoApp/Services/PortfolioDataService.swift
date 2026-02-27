//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/27/26.
//

import Foundation
import CoreData
import Combine

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self?.getPortfolio()
        }
    }
    
    //MARK: - Public method
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if entity.amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - Private method
    private func getPortfolio() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request) as! [PortfolioEntity]
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    // add
    private func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    // update
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    // delete
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // save
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
