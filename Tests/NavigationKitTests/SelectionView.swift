//
//  SelectionView.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public struct SelectionView<Item: Selectable>: View {
    @StateObject private var viewModel: SelectionViewModel<Item>
    @State private var isShowingSheet = false
    private let title: String
    private let presentationType: SelectionPresentationType
    
    public init(
        title: String,
        items: [Item],
        presentationType: SelectionPresentationType = .half,
        delegate: (any SelectionDelegate<Item>)? = nil
    ) {
        self.title = title
        self.presentationType = presentationType
        
        let repository = SelectionRepository(items: items)
        let useCase = SelectionUseCase(repository: repository, delegate: delegate)
        self._viewModel = StateObject(wrappedValue: SelectionViewModel(useCase: useCase))
    }
    
    public var body: some View {
        Button(action: {
            isShowingSheet = true
        }) {
            SelectionHeaderView(
                viewModel: viewModel,
                style: presentationType.style
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowingSheet) {
            NavigationStack {
                SelectionListView(
                    items: viewModel.getItems(),
                    selectedItem: viewModel.selectedItem,
                    style: presentationType.style,
                    onSelect: viewModel.select
                )
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(SelectionConstants.Strings.doneButton) {
                            isShowingSheet = false
                        }
                    }
                }
            }
            .presentationDetents(presentationType.detents)
            .presentationDragIndicator(
                presentationType.showsDragIndicator ? .visible : .hidden
            )
        }
    }
}
