//
//  RemediosViewModel.swift
//  TestesParaChallenge4
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 29/01/25.
//

import Foundation
import CoreData

class RemediosViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var entidadeSalvas: [RemedioEntity] = []
    
    init() {
        
        self.container = NSPersistentContainer(name: "RemediosContainer")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            } else {
                print("foi")
            }
        }
        fetchRemedios()
    }
    
    func deleteRemedio(index: IndexSet) {
        guard let index = index.first else { return }
        let entidade = entidadeSalvas[index]
        container.viewContext.delete(entidade)
        saveData()
        
    }
    
    func marcarComoDesativado(index: IndexSet) {
        guard let index = index.first else { return }
        let entidade = entidadeSalvas[index]
        entidade.ativo = false
        saveData()
    }
    
    func fetchRemedios() {
        let request = NSFetchRequest<RemedioEntity>(entityName: "RemedioEntity")
        
        do {
           entidadeSalvas = try container.viewContext.fetch(request)
            
        } catch let error {
            print(error)
        }
        
    }
    
    func addRemedio(nome: String, dosagem: Float, horario: String, imagem: Data) {
        let newRemedio = RemedioEntity(context: container.viewContext)
        newRemedio.nome = nome
        newRemedio.dosagem = dosagem
        newRemedio.horario = horario
        newRemedio.imagem = imagem
        newRemedio.ativo = true
        saveData()
    }
    
    func updateRemedio(nome: String, dosagem: Float, horario: String, imagem: Data, entidade: RemedioEntity) {

        entidade.nome = nome
        entidade.dosagem = dosagem
        entidade.horario = horario
        entidade.imagem = imagem
        saveData()
        
    }
    
    func saveData() {
        
        do {
            
            try container.viewContext.save()
            fetchRemedios()
            
        } catch let error {
            
            print(error)
        }
        
    }
    
}
