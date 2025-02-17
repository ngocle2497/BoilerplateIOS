import SwiftUI

struct HomeView: View {
    var vm: HomeView.ViewModel
    
    var body: some View {
        ScreenView {
            Button {
                vm.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}

#Preview {
    HomeView(vm: .init())
}
