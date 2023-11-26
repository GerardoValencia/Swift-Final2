//
//  ContentView.swift
//  API Perros
//
//  Created by Gerardo Valencia Rodríguez on 25/11/23.
//

import SwiftUI

struct DogImageResponse: Codable {
    let message: String
    let status: String
}

struct URLImage: View {
    
    let url: URL
    
    var body: some View {
        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "exclamationmark.shield")
                .resizable()
        }
    }
}


struct ContentView: View {
    
    @State private var selectedBreed: String = "akita"
    @State private var dogImageURL: URL?
    
    let dogBreeds = ["akita", "borzoi", "bouvier", "dingo", "husky", "shiba"]
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Select a good boi 🐶")
                .font(.title)
                .foregroundColor(.indigo)
            
            Picker("Please choose a good boi", selection: $selectedBreed) {
                ForEach(dogBreeds, id: \.self) { breed in
                    Text(breed.capitalized).tag(breed)
                }
            }
            .pickerStyle(InlinePickerStyle())
            .padding()
            
            Button (action: {
                fetchDogImage()
            }) {
                Text("Here's a good boi! 🐕")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            if let imageURL = dogImageURL {
                URLImage(url: imageURL)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 250)
                    .cornerRadius(40)
                    .padding()
            }
            
            Spacer()
        }
        .onAppear {
            fetchDogImage()
        }
    }
    
    private func fetchDogImage() {
        guard let url = URL(string: "https://dog.ceo/api/breed/\(selectedBreed)/images/random") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in 
            if let data = data, error == nil {
                if let decodedResponse = try? JSONDecoder().decode(DogImageResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.dogImageURL = URL(string: decodedResponse.message)
                    }
                    return
                }
            }
            print("Couldn't find the dog: \(error?.localizedDescription ?? "Fallo en la Matrix")")
        }
        .resume()
    }
}

#Preview {
    ContentView()
}
