import Foundation
import ChatBotSDK

final class RevertOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init() {
        let revertContext = RevertContext()

        let handler = RevertFlowInputHandler()
        handler.context = revertContext

        let revertAction = RevertOperationAction()
        revertAction.context = revertContext

        initialHandlerId = "revert"
        inputHandlers = ["revert" : handler]
        action = revertAction
        context = revertContext
    }

}

final class RevertContext {

    var text: String?
}

final class RevertOperationAction: FlowAction {

    var context: RevertContext?

    func execute(chat: Chat, user: User) -> [String] {
        if let text = context?.text {
            return [String(text.reversed())]
        } else {
            return ["error"]
        }
    }

}

final class RevertFlowInputHandler: FlowInputHandler {

    var context: RevertContext?

    func start(chat: Chat, user: User) -> FlowInputHandlerMarkup {
        return FlowInputHandlerMarkup(texts: ["Type text"])
    }

    func handle(chat: Chat, user: User, text: String) -> FlowInputHandlerResult {
        context?.text = text
        return .end
    }
}
