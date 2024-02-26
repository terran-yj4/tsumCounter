import SwiftUI

struct InfomationsView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State private var isShowAlertOfReset = false
    @State private var isShowAlertOfReg6 = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("アプリ情報、更新情報など記載予定")
            Spacer()
            Text("使い方\n\nカウンター:\n1. 各ツムのスキルレベルを入力します\n2. 「計算する」ボタンを押します\n3. 全ツムスキルマックスまでに必要なコイン数を計算して、表示してくれます\n\n※カウンターでは画面右下にある絞り込み機能を使うとツムを見つけやすくなります")
            Spacer()
            Button(action: {
                isShowAlertOfReg6.toggle()
            }, label: {
                Text("全常駐ツムSLv.6設定")
                    .frame(height: screenHeight/16 - 10)
            }).alert("全常駐ツムのスキルレベルを6に設定していいですか？\n※『ナイトメア・ビフォア・クリスマス』を除く", isPresented: $isShowAlertOfReg6) {
                Button("キャンセル", role: .cancel){}
                Button("はい") {
                    var tsumArrayTR6 = loadTsums() ?? []
                    for index in tsumArrayTR6.indices {
                        if tsumArrayTR6[index].type == .regular{
                            tsumArrayTR6[index].slv = Int((tsumArrayTR6[index].slvtype).filter("0123456789".contains)) ?? 0
                            print(tsumArrayTR6[index].slvtype, Int((tsumArrayTR6[index].slvtype).filter("0123456789".contains)) ?? 0)
                        }
                    }
                    saveTsums(tsums: tsumArrayTR6)
                }
            }
            Button(action: {
                isShowAlertOfReset.toggle()
            }, label: {
                Text("データ全消去")
                    .frame(height: screenHeight/16 - 10)
            }).alert("今まで入力したデータを全て消去してもいいですか？", isPresented: $isShowAlertOfReset) {
                Button("消去する", role: .destructive) {
                    saveTsums(tsums: TSUM_ARRAY)
                }
            }
            Spacer()
        }
        
    }
    func saveTsums(tsums: [Tsum]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(tsums) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "TSUMS_ARRAY")
    }
    func loadTsums() -> [Tsum]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "TSUMS_ARRAY"),
              let tsums = try? jsonDecoder.decode([Tsum].self, from: data) else {
            return nil
        }
        return tsums
    }
}

#Preview {
    InfomationsView()
}
