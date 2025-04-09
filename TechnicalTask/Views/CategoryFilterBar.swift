//
//  CategoryFilterBar.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI
// MARK: Filter Bar

struct CategoryFilterBar: View {
    @ObservedObject var viewModel: RacesViewModel
    
    var body: some View {
            HStack(alignment: .center, spacing: 10) {
                ForEach(RaceCategory.allCases, id: \.self) { category in
                    FilterButton(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory.contains(category),
                        action: {
                            if viewModel.selectedCategory.contains(category) {
                                viewModel.selectedCategory.removeAll(where: {$0 == category})
                            } else {
                                viewModel.selectedCategory.append(category)
                            }
                            
                        }
                    )
                }
        }
        .padding(.vertical, 8)
    }
}
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(isSelected ? .black : .gray)
                .padding()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? .blue.opacity(0.3) : .gray, lineWidth: 1)
                )
        }
    }
}

