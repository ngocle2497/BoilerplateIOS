import SwiftUI

struct SignInView: View {
    var vm: SignInView.ViewModel
    
    var body: some View {
        ScreenView {
            VStack {
                Button {
                    vm.shownAuthenticatedScreen()
                } label: {
                    Text(.localizable(.login))
                        .title2Bold()
                }
                Button {
                    vm.showSignUpScreen()
                } label: {
                    Text(.localizable(.register))
                        .title2Regular()
                }
            }
        }
        
    }
}

#Preview {
    SignInView(vm: .init())
}
