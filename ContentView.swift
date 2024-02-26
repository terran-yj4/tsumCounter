import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SkillLevelCount()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("カウンター")
                    }
                }
            InfomationsView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("アプリ情報")
                }
        }
    }
}

#Preview {
    ContentView()
}
