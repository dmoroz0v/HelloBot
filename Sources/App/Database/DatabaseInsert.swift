import Foundation
import ChatBotSDK
import Fluent
import Vapor

final class DatabaseInsertOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init(app: Application) {
        let databaseInsertContext = DatabaseInsertContext()

        let handler = DatabaseInsertFlowInputHandler()
        handler.context = databaseInsertContext

        let databaseInsertAction = DatabaseInsertOperationAction(app: app)
        databaseInsertAction.context = databaseInsertContext

        initialHandlerId = "databaseInsert"
        inputHandlers = ["databaseInsert" : handler]
        action = databaseInsertAction
        context = databaseInsertContext
    }

}

final class DatabaseInsertContext {

    var text: String?

}

final class DatabaseInsertOperationAction: FlowAction {

    let app: Application

    var context: DatabaseInsertContext?

    init(app: Application) {
        self.app = app
    }

    func execute(chat: Chat, user: User) async -> [String] {
        if let text = context?.text {
            do {
                let r = Row(userId: user.id, value: text)
                try await r.save(on: app.db)
                return ["Succeeded"]
            } catch let e {
                return [e.localizedDescription]
            }
        } else {
            return ["error"]
        }
    }

}

final class DatabaseInsertFlowInputHandler: FlowInputHandler {

    var context: DatabaseInsertContext?

    func start(chat: Chat, user: User) -> FlowInputHandlerMarkup {
        return FlowInputHandlerMarkup(texts: ["Type text"])
    }

    func handle(chat: Chat, user: User, text: String) -> FlowInputHandlerResult {
        context?.text = text
        return .end
    }

}
