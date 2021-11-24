//import SwiftUI
//
//struct StoryFeedbackView: View {
//    typealias ViewModel = AnyViewModel<StoryFeedbackView.ViewState, StoryFeedbackView.Input>
//
//    struct ViewState {
//        enum Progress {
//            case none
//            case loading
//            case saved
//        }
//
//        struct Answer: Equatable, Hashable {
//            static let defaultAnswers = [
//                Answer(emoji: "😭", text: "1"),
//                Answer(emoji: "🙁", text: "2"),
//                Answer(emoji: "😐", text: "3")
//            ]
//
//            let emoji: String
//            let text: String
//        }
//
//        var answers = Answer.defaultAnswers
//        var selected = Answer.defaultAnswers.first!
//        var progress = Progress.none
//    }
//
//    enum Input {
//        case select(answer: ViewState.Answer)
//        case submit
//    }
//
//    @ObservedObject var viewModel: ViewModel
//    let onClose: () -> Void
//    private let backgroundColor = Color(white: 1)
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//
//            ScrollView {
//                VStack(alignment: .leading, spacing: 70) {
//                    Spacer()
//                    header
//                    answers
//                    Spacer()
//                }.padding(.spacingL)
//            }
//
//            footer
//
//            HStack {
//                Spacer()
//                closeButton
//            }
//        }
//        .overlay(progressOverlay)
//    }
//}
//
//// MARK: - Subviews
//
//private extension StoryFeedbackView {
//    var header: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text("headertext")
//                .font(.subheadline)
//                .foregroundColor(Color.white.opacity(0.6))
//            Text("headline")
//                .font(Font.system(size: 32).weight(.bold))
//                .foregroundColor(.white)
//        }
//    }
//
//    var answers: some View {
//        VStack(spacing: 28) {
//            ForEach(viewModel.answers, id: \.self) { answer in
//                AnswerButton(
//                    model: answer,
//                    isSelected: answer == viewModel.selected,
//                    action: viewModel.action(.select(answer: answer))
//                )
//            }
//        }
//    }
//
//    var footer: some View {
//        VStack(alignment: .center, spacing: 0) {
//            Spacer()
//            VStack(alignment: .center, spacing: 0) {
//                Text("Text")
//                    .font(.caption2, weight: .regular)
//                    .foregroundColor(Color.white.opacity(0.5))
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, .paddingXXL)
//                BottomStickyButton(
//                    title: "Text",
//                    background: .color(.clear),
//                    action: {
//                        tracker.trackSend()
//                        viewModel.trigger(.submit)
//                    }
//                )
//                .padding(.horizontal, .paddingS)
//            }
//            .padding(.top, .spacingM)
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [backgroundColor.opacity(0.9), backgroundColor]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//            )
//        }
//    }
//
//    var closeButton: some View {
//        Button(action: {
//            tracker.trackClose()
//            onClose()
//        }) {
//            Image(symbol: .close)
//                .font(.title3, weight: .heavy)
//                .foregroundColor(Color(hex: "E8F2FE"))
//                .padding(.spacingM)
//        }
//    }
//
//    @ViewBuilder
//    var progressOverlay: some View {
//        switch viewModel.progress {
//        case .none:
//            EmptyView()
//        case .loading:
//            ProgressOverlay(backgroundColor: Color.black.opacity(0.1))
//        case .saved:
//            Color.clear.onAppear(perform: onClose)
//        }
//    }
//}
//
//// MARK: - Private views
//
//private struct AnswerButton: View {
//    let model: StoryFeedbackView.ViewState.Answer
//    var isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: .paddingM) {
//                Text(model.emoji)
//                    .font(Font.system(size: 30))
//                    .scaleEffect(isSelected ? 1.3 : 1)
//                Text(model.text)
//                    .font(isSelected ? .headline : .body, weight: isSelected ? .heavy: .semibold)
//                Spacer()
//                if isSelected {
//                    Image(symbol: .checkmark)
//                        .font(.headline, weight: .heavy)
//                }
//            }.foregroundColor(Color.white.opacity(isSelected ? 1 : 0.5))
//        }
//    }
//}
//
//// MARK: - Previews
//
//struct StoryFeedbackView_Previews: PreviewProvider, ScreenPreviewProvider {
//    static var previews: some View {
//        screen.previewAsScreen()
//    }
//
//    static var screen: some View {
//        StoryFeedbackView(viewModel: PreviewModel().eraseToAnyViewModel(), onClose: {})
//    }
//}
//
//private final class PreviewModel: ViewModel {
//    @Published private(set) var state = StoryFeedbackView.ViewState()
//
//    func trigger(_ input: StoryFeedbackView.Input) {
//        switch input {
//        case .select(let answer):
//            state.selected = answer
//        case .submit:
//            break
//        }
//    }
//}
//
//// MARK: - AnyViewModel
//
///*
// A type-erasing wrapper conforming to the `ViewModel`
// protocol with the associated types being the specified generic types State and Input.
// */
//@dynamicMemberLookup
//public final class AnyViewModel<State, Input>: ViewModel {
//    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
//    private let wrappedState: () -> State
//    private let wrappedTrigger: (Input) -> Void
//
//    public var objectWillChange: AnyPublisher<Void, Never> {
//        wrappedObjectWillChange()
//    }
//
//    public var state: State {
//        wrappedState()
//    }
//
//    // MARK: - Init
//
//    public init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
//        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
//        self.wrappedState = { viewModel.state }
//        self.wrappedTrigger = viewModel.trigger
//    }
//
//    // MARK: - Internal
//
//    public func trigger(_ input: Input) {
//        wrappedTrigger(input)
//    }
//
//    public func action(_ input: Input) -> () -> Void {
//        return { [weak self] in
//            self?.wrappedTrigger(input)
//        }
//    }
//
//    public func bind<Value>(
//        _ keyPath: KeyPath<State, Value>,
//        _ trigger: ((Value) -> Input)?
//    ) -> Binding<Value> {
//        Binding<Value>(
//            get: { [unowned self] in self.state[keyPath: keyPath] },
//            set: { [weak self] in
//                if let trigger = trigger {
//                    self?.trigger(trigger($0))
//                }
//            }
//        )
//    }
//
//    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
//        state[keyPath: keyPath]
//    }
//
//    public func sink(_ closure: @escaping (State) -> Void) -> AnyCancellable {
//        return objectWillChange
//            .makeConnectable()
//            .autoconnect()
//            .sink {
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    closure(self.state)
//                }
//          }
//    }
//}
//
//// MARK: - Extensions
//
//extension AnyViewModel: Identifiable where State: Identifiable {
//    public var id: State.ID {
//        state.id
//    }
//}
