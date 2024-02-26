import SwiftUI

struct test: View {
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = UIScreen.main.bounds.width
    
    @State private var flags = [Bool](repeating: false, count: TSUM_ARRAY.count)
    @State private var currentTsumArray: [String] = []
    @State private var searchText = ""
    
    var body: some View {
        Button(action: {
            checkAllTsumToggle()
        }, label: {
            Text("Button")
        })
        NavigationStack {
            List {
                ForEach (0..<TSUM_ARRAY.count, id: \.self) { num in
                    if searchText.isEmpty || TSUM_ARRAY[num].name.contains(searchText) { Toggle(TSUM_ARRAY[num].name, isOn: $flags[num]) }
                }
            }
            .searchable(text: $searchText)
        }
        
    }

    private func checkAllTsumToggle() {
        currentTsumArray.removeAll()
        for (index, tsumBool) in flags.enumerated() {
            if tsumBool {
                currentTsumArray.append(TSUM_ARRAY[index].name)
            }
        }
        print(currentTsumArray)
    }
}

#Preview {
    test()
}
