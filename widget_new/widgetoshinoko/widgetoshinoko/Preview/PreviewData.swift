extension WidgetItem {
    static var preview: WidgetItem {
        MockData.widgets[0]
    }
    
    static var previewList: [WidgetItem] {
        MockData.widgets
    }
}

#if DEBUG
extension WidgetListViewModel {
    static var preview: WidgetListViewModel {
        let viewModel = WidgetListViewModel(repository: MockWidgetRepository())
        return viewModel
    }
}
#endif
