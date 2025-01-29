//
//  EditRemedioView.swift
//  TestesParaChallenge4
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 29/01/25.
//

import SwiftUI

struct EditRemedioView: View {
    
    let entidade: RemedioEntity
    @State var novoNome = ""
    @State var novaDosagem = ""
    @StateObject var remediosViewModel: RemediosViewModel
    
    var body: some View {
        
        VStack {
            
            TextField(entidade.nome ?? "entidade sem nome", text: $novoNome)
            TextField(String(entidade.dosagem), text: $novaDosagem)

            Button("atualizar") {
                
                remediosViewModel.updateRemedio(nome: novoNome, dosagem: Float(novaDosagem) ?? 0, horario: entidade.horario!, imagem: entidade.imagem!, entidade: entidade)
                
            }
            
        }
        
    }
}


