import SwiftUI

struct HomeView: View {
    var vm: HomeView.ViewModel
    
    var body: some View {
        ScreenView {
            Button {
                vm.logout()
            } label: {
                Text(.localizable(.logout))
            }
            .onFirstAppear {
                vm.getUsers { data in
                    print(data)
                }
            }
        }
    }
}

#Preview {
    HomeView(vm: .init())
}
