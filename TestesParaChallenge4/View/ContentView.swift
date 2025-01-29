//
//  ContentView.swift
//  TestesParaChallenge4
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 29/01/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @StateObject var remediosViewModel = RemediosViewModel()
    @State var inputText = ""
    @State var inputTextDosagem = ""
    @State var horaSelecionada = Date()
    @State private var imagem: UIImage?
    @State var photosPickerItem: PhotosPickerItem?


    
    var body: some View {
        VStack {
            
            TextField("nome", text: $inputText)
            TextField("dosagem", text: $inputTextDosagem)
            DatePicker("Selecione a Hora", selection: $horaSelecionada, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
      
                Image(uiImage: imagem ?? UIImage(named: "remedios")!.resized(to:300)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
            }
            
            Button("Selecionar Imagem") {
            }

            Button("adicionar") {
                guard let imagem = imagem else { return }

//                let date = NSDate()
                var dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
//                var data = dateFormatter.string(from: date as Date)
                
                
                
                guard let imageData = imagem.pngData() else {
                            print("Erro ao converter imagem para Data")
                            return
                        }
                
                remediosViewModel.addRemedio(nome: inputText, dosagem: Float(inputTextDosagem) ?? 0.0, horario: dateFormatter.string(from: horaSelecionada), imagem: imageData)
     
            }
            
            List {
                ForEach(remediosViewModel.entidadeSalvas) {
                    entidade in
                    
                    HStack {
                        
                        if let data = entidade.imagem {
                            Image(uiImage: UIImage(data: data)!.resized(to:300)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(uiImage: UIImage(named: "remedios")!.resized(to:300)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                            
                        }
                     
                          
                        
                        Text("nome: \(entidade.nome ?? "sem nome"), dosagem: \(entidade.dosagem), horario: \(entidade.horario ?? "sem horario")")
                    }
                    
                    
                }.onDelete(perform: { indexSet in
                    remediosViewModel.deleteRemedio(index: indexSet)
                })
            }
            
        }
        .onChange(of: photosPickerItem, { _, _ in
            Task {
                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        imagem = image
                    }
                }
                
                photosPickerItem = nil

            }
            
        })
       

        .padding()
    }
}

extension UIImage {
    func resized(to maxWidth: CGFloat) -> UIImage? {
        let aspectRatio = self.size.height / self.size.width
        let height = maxWidth * aspectRatio
        let size = CGSize(width: maxWidth, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

#Preview {
    ContentView()
}
