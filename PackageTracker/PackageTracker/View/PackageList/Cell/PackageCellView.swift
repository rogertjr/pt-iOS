//
//  PackageCellView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

struct PackageCellView: View {
    // MARK: - Properties
    
    // MARK: - Layout
    var body: some View {
        HStack(spacing: 12){
            Group {
                Image(systemName: "map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 120)
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color("CardBackground"))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("Street Business")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Black"))
                    
                    Text("OU257358161BR")
                        .font(.caption2.bold())
                        .foregroundColor(.gray)
                        .padding(.top,-5)
                }
                
                Text("Objeto em rota de entrega")
                    .font(.system(size: 14))
                    .foregroundColor(Color("Black").opacity(0.8))
                
                HStack {
                    Spacer()
                    
                    Button { } label: {
                        Text("Ver detalhes")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical,8)
                            .padding(.horizontal,20)
                            .background{
                                Capsule()
                                    .fill(Color("Black"))
                            }
                    }
                    .scaleEffect(0.9)
                    
                    Spacer()
                }
                .offset(y: 10)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 20,
                             style: .continuous)
                .fill(.white)
                .shadow(color: Color("Black").opacity(0.08),
                        radius: 5, x: 5, y: 5)
        }
        .onTapGesture(perform: {
            withAnimation(.easeInOut) {
                // TODO: Handle selection
            }
        })
        .padding([.leading, .trailing])
    }
}
