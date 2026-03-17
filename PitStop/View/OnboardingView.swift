//
//  OnboardingView.swift
//  PitStop
//
//  Created by Jota Pe on 16/03/26.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(image: "motorcycle.fill", title: "Bem-vindo à sua Garagem Virtual", subtitle: "Esqueça as planilhas e caderninhos. Controle as revisões, os gastos e a vida útil das peças da sua moto em um só lugar."),
        OnboardingPage(image: "waveform", title: "Atualize com a sua voz", subtitle: "Chegou de viagem? Diga 'E aí Siri, atualizar KM no PitStop'. Mantenha sua moto em dia sem precisar abrir o app."),
        OnboardingPage(image: "bell.badge.fill", title: "Alertas Inteligentes", subtitle: "Nós fazemos a matemática por você. Seja avisado automaticamente antes que o óleo vença ou a relação precise de troca."),
        OnboardingPage(image: "checkmark.seal.fill", title: "Tudo pronto para acelerar?", subtitle: "Adicione sua primeira moto e comece a ter o controle total hoje mesmo.")
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: pages[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 30)
                        
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(pages[index].subtitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            if currentPage == pages.count - 1 {
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text("Adicionar minha primeira Moto")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .transition(.opacity)
            } else {
                Spacer()
                    .frame(height: 70)
            }
        }
    }
}
