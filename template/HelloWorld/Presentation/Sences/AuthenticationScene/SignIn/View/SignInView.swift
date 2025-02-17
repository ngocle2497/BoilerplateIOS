import SwiftUI

struct SignInView: View {
    var vm: SignInView.ViewModel
    
    var body: some View {
        ScreenView {
            VStack {
                Button {
                    vm.shownAuthenticatedScreen()
                } label: {
                    Text("Show Home Screen")
                        .title2Bold()
                }
                Button {
                    vm.showSignUpScreen()
                } label: {
                    Text("Show Sign Up Screen")
                        .title2Regular()
                }
            }
        }
        
    }
}

#Preview {
    SignInView(vm: .init())
}
