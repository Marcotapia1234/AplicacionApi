//
//  ContentView.swift
//  AplicacionApi
//
//  Created by Marco on 3/5/24.
//

import SwiftUI

struct ContentView: View {
    
    //Variable de estado que recoge los datos de la API
    @State private var datos : Datos?
    
    var body: some View {
        Spacer()
        ZStack{
            Image("principe")
                .resizable()
                .edgesIgnoringSafeArea(.all)
        
        HStack{
            Spacer()
            
            VStack(alignment: .trailing){
                Spacer()
                
                Text(datos?.content ?? "")
                    .font(.title2)
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.5))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                       )
                    )
                    .padding(.bottom)
                VStack(alignment: .trailing) {
                        Text("- \(datos?.author ?? "")")
                    .font(.title2)
                    .padding(5)
                    Text("- Longitud: \(datos?.length ?? 0)")
                        .font(.title2)
                        .padding(5)
                    Text("- Cita agregada: \(datos? .dateAdded ?? "")")
                        .font(.title2)
                        .padding(5)
                }
                .background(Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 3)
                            
                )
               )
                    
                Spacer()
                
                Button(action: llamaUrl){
                    Image(systemName: "arrow.clockwise")
                }
                .font(.title)
                .padding(.top)
            }
        }
        .multilineTextAlignment(.trailing)
        .padding()
        .onAppear(perform: llamaUrl)
    }
   }
    
    //Función para llamar a la Web que proporciona la API
    private func llamaUrl() {
        guard let url = URL(string: "https://api.quotable.io/random") else{return}
        
        //Creamos sesión de URL para pedir datos a la URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            //Si hemos obtenido JSON, tenemos que usar un decodificador para almacenarlo en nuestra variable datos, de tipo Datos.
            if let datosDecodificados = try? JSONDecoder().decode(Datos.self,from:data){
                //El Decoder va a almacenar cada etiqueta de JSON en nuestro struct
                //Asignamos la info decodificada a nuestra variable de estado
                //Lo hacemos desde el hilo principal, con DispatchQueue
                DispatchQueue.main.async {
                    self.datos = datosDecodificados
                }
            }
            
        }.resume()
    }
    
}

//La estructura ha de conformar el protocolo Decodable, para que sepa que ha de interpretar un JSON
struct Datos: Decodable {
    //Identificador para la frase
    //var _id : String
    //Identificador para el idioma, que siempre va a ser Inglés
    //var en : String
    var content : String
    var author : String
    var length: Int
    var dateAdded: String
    //Identificador para la frase, que también lo devuelve el JSON
    //var id : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
