//
//  ContentView.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import SwiftData
import SwiftUI

struct GarageView: View{
    @Query(sort: \Motorcycle.name) private var motorcycles: [Motorcycle]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddMotoSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            Group{
                if motorcycles.isEmpty{
                    ContentUnavailableView(
                        "Garagem vazia",
                        systemImage: "wrench.and.jawbone",
                        description: Text("Adicione sua primeira moto, para começar a reatrear o óleo, pneus e suas revisões.")
                    )
                } else {
                    List{
                        ForEach(motorcycles) { moto in
                            NavigationLink(destination: MotorcycleDetailView(moto: moto)){
                                MotorcycleRow(moto: moto)
                            }
                        }
                        .onDelete(perform: deleteMoto)
                    }
                }
            }
            .navigationTitle(Text("Minha Garagem"))
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: { showingAddMotoSheet = true}){
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMotoSheet){
                AddMotorcycleView()
            }
        }
    }
    private func deleteMoto(offsets: IndexSet){
        for index in offsets{
            let motoToDelete = motorcycles[index]
            modelContext.delete(motoToDelete)
        }
    }
}
struct MotorcycleRow: View {
    let moto: Motorcycle
    
    var body: some View {
        HStack(spacing: 16) {
            if let photoData = moto.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "motorcycle")
                            .foregroundColor(.accentColor)
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(moto.name.isEmpty ? "Sem Nome" : moto.name)
                    .font(.headline)
                
                Text(moto.brand.isEmpty ? "Sem Marca" : moto.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(moto.currentMileage) km")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Atual")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
#Preview{
    GarageView()
            .modelContainer(for: Motorcycle.self, inMemory: true)
}

