import Combine

class TechStackSearchViewModel: ObservableObject {
    @Published var searchTech: String = ""
    @Published var selectedTech = [String]()

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        $searchTech
//            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.filteredTech = self.allTech
                } else {
                    self.filteredTech = self.allTech.filter { tech in
                        let englishMatch = tech.title.localizedCaseInsensitiveContains(searchText)
//                        let koreanMatch = tech.koreanTitle.contains(searchText)
                        let jamoMatch = tech.koreanTitle.contains(Jamo.getJamo(searchText))
                        return englishMatch || jamoMatch
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
