import SwiftUI

// MARK: Custom View Builder
struct CustomRefreshView<Content: View>: View {
    var content: Content
    var showsIndicator: Bool
    // MARK: Async Call Back
    var onRefresh: ()async->()
    
    init(showsIndicator: Bool = false,
         @ViewBuilder content: @escaping () -> Content,
         onRefresh: @escaping ()async->()) {
        self.showsIndicator = showsIndicator
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicator) {
            VStack(spacing: 0) {
                GeometryReader { _ in
                    VStack {
                        Text(verbatim: "Reloading")
                            .frame(maxWidth: .infinity)
                    }
                    .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.2), value: scrollDelegate.isEligible)
                    .overlay(content: {
                        // MARK: Arrow And Text
                        VStack(spacing: 12){
                            Image(systemName: "arrow.down")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                                .padding(8)
                                .background(.primary,in: Circle())
                            
                            Text(verbatim: "Pull To Refresh")
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                        }
                        .opacity(scrollDelegate.isEligible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    })
                    .frame(height: 150)
                    .opacity(scrollDelegate.progress)
                    .offset(y: scrollDelegate.isEligible ? -(scrollDelegate.contentOffset < 0 ? 0 : scrollDelegate.contentOffset) : -(scrollDelegate.scrollOffset < 0 ? 0 : scrollDelegate.scrollOffset))
                }
                .frame(height: 0)
                .offset(y: -75 + (75 * scrollDelegate.progress))
                
                content
                    .offset(y: scrollDelegate.progress * 150)
            }
            .offset(coordinateSpace: "CustomRefreshView_SCROLL") { offset in
                // MARK: Storing Content Offset
                scrollDelegate.contentOffset = offset
                
                // MARK: Stopping The Progress When Its Elgible For Refresh
                if !scrollDelegate.isEligible {
                    var progress = offset / 150
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    // MARK: Haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .coordinateSpace(name: "CustomRefreshView_SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { newValue in
            // MARK: Calling Async Method
            if newValue {
                Task {
                    await onRefresh()
                    // MARK: After Refresh Done Resetting Properties
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
}


// MARK: For Simultanous Pan Gesture
class ScrollViewModel: NSObject,ObservableObject,UIGestureRecognizerDelegate {
    // MARK: Properties
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    // MARK: Offsets and Progress
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    let gestureID: String = UUID().uuidString
    
    // MARK: Since We need to Know when the user Left the Screen to Start Refresh
    // Adding Pan Gesture To UI Main Application Window
    // With Simultaneous Gesture Desture
    // Thus it Wont disturb SwiftUI Scroll's And Gesture's
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Adding Gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Removing When Leaving The View
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == gestureID
        })
    }
    
    // MARK: Finding Root Controller
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            print("User Released Touch")
            // MARK: Your Max Duration Goes Here
            if !isRefreshing{
                if scrollOffset > 150 {
                    isEligible = true
                }else{
                    isEligible = false
                }
            }
        }
    }
}

// MARK: Offset Modifier
fileprivate extension View {
    @ViewBuilder
    func offset(coordinateSpace: String,offset: @escaping (CGFloat)->())->some View {
        self
            .overlay {
                GeometryReader{proxy in
                    let minY = proxy.frame(in: .named(coordinateSpace)).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            offset(value)
                        }
                }
            }
    }
}

// MARK: Offset Preference Key
fileprivate struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView(showsIndicator: false) {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
        }
    }
}
