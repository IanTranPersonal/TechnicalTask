//
//  CategoryFilterBar.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI
// MARK: Filter Bar

struct CategoryFilterBar: View {
    @Environment(\.sizeCategory) var sizeCategory
    var viewModel: RacesViewModel
    
    var body: some View {
            HStack(alignment: .center, spacing: 10) {
                ForEach(RaceCategory.allCases, id: \.self) { category in
                    FilterButton(
                        title: getTextString(category),
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
    private func getTextString(_ race: RaceCategory) -> String {
        sizeCategory <= .accessibilityExtraLarge ? race.displayName : race.imageName
    }
}
struct FilterButton: View {
    @Environment(\.sizeCategory) var sizeCategory
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textOrImage(title)
                .foregroundStyle(isSelected ? Color.primary : Color.gray)
                .padding()
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? .blue : .gray, lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    func textOrImage(_ title: String) -> some View {
        if sizeCategory <= .accessibilityExtraExtraLarge {
            Text(title)
                .font(.subheadline)
        } else {
            Image(systemName: title)
        }
    }
}

