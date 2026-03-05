import SwiftUI
import SwiftData
import PhotosUI
import WidgetKit

struct MotorcycleDetailView: View {
    @Bindable var moto: Motorcycle
    
    @State private var showingAddMaintenanceSheet = false
    @State private var showingUpdateMileageAlert = false
    @State private var newMileageString = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                        if let photoData = moto.photoData, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                        } else {
                            VStack {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.accentColor)
                                Text("Adicionar Foto")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 140, height: 140)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                        }
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear) // Tira o fundo branco para a foto flutuar
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hodômetro Atual")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(moto.currentMileage) km")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button("Atualizar KM") {
                        newMileageString = String(moto.currentMileage)
                        showingUpdateMileageAlert = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Section(
                header: Text("Manutenções"),
                footer: Text("Adicione itens como Troca de Óleo, Pneus, Relação, etc.")
            ) {
                if moto.maintenanceItems.isEmpty {
                    Text("Nenhum alerta configurado.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(moto.maintenanceItems) { item in
                        MaintenanceRow(item: item)
                    }
                    .onDelete(perform: deleteMaintenance)
                }
            }
        }
        .navigationTitle(moto.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddMaintenanceSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAddMaintenanceSheet) {
            AddMaintenanceView(moto: moto)
        }
        .alert("Atualizar Hodômetro", isPresented: $showingUpdateMileageAlert) {
            TextField("Nova quilometragem", text: $newMileageString)
                .keyboardType(.numberPad)
            Button("Cancelar", role: .cancel) { }
            Button("Salvar") {
                if let newKM = Int(newMileageString) {
                    moto.currentMileage = newKM
                
                    for item in moto.maintenanceItems {
                        if item.mileageRemaining <= 100 {
                            NotificationManager.shared.scheduleMaintenanceAlert(
                                itemName: item.title,
                                remainingKM: item.mileageRemaining,
                                motoName: moto.name
                            )
                        }
                    }
                    
                    try? moto.modelContext?.save()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        } message: {
            Text("Insira a quilometragem que está marcando no painel da moto agora.")
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    moto.photoData = data // Salva no banco de dados automaticamente
                }
            }
        }
    }
    
    private func deleteMaintenance(offsets: IndexSet) {
        for index in offsets {
            moto.maintenanceItems.remove(at: index)
        }
    }
}

struct MaintenanceRow: View {
    let item: MaintenanceItem
    
    @State private var showingCompleteSheet = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text("Troca a cada \(item.intervalMileage) km")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(item.mileageRemaining) km")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(statusColor)
                    Text("restantes")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: { showingCompleteSheet = true }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Registrar Serviço")
                }
                .font(.caption)
                .fontWeight(.bold)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(8)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingCompleteSheet) {
            CompleteServiceView(item: item)
        }
    }
    
    private var statusColor: Color {
        let remaining = item.mileageRemaining
        if remaining <= 0 { return .red }
        if remaining <= 500 { return .orange }
        return .green
    }
}
