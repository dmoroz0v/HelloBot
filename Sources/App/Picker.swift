import Foundation
import ChatBotSDK

final class PickerOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init() {
        let pickerContext = PickerContext()

        let handler = PickerFlowInputHandler(context: pickerContext)

        let pickerAction = PickerOperationAction(context: pickerContext)

        initialHandlerId = "pick"
        inputHandlers = ["pick" : handler]
        action = pickerAction
        context = pickerContext
    }

}

final class PickerContext {

    var text: String?

}

final class PickerOperationAction: FlowAction {

    let context: PickerContext

    init(context: PickerContext) {
        self.context = context
    }

    func execute(chat: Chat, user: User) -> [String] {
        if let text = context.text {
            return ["You picked '\(text)'"]
        } else {
            return ["error"]
        }
    }

}

final class PickerFlowInputHandler: FlowInputHandler {

    private struct Data {
        var page: Int
        var items: [String]
    }

    let context: PickerContext

    private var data: Data?

    init(context: PickerContext) {
        self.context = context
    }

    func start(chat: Chat, user: User) -> FlowInputHandlerMarkup {
        let data = Data(
            page: 1,
            items: [
                "item1", "item2", "item3", "item4",
                "item5", "item6", "item7", "item8",
            ]
        )
        var keyboard: ReplyKeyboardMarkup?
        keyboard = ChatBotSDK.ReplyKeyboardMarkup(
            keyboard: [
                [
                    ChatBotSDK.KeyboardButton(text: data.items[(data.page - 1) * 4 + 0]),
                    ChatBotSDK.KeyboardButton(text: data.items[(data.page - 1) * 4 + 1])
                ],
                [
                    ChatBotSDK.KeyboardButton(text: data.items[(data.page - 1) * 4 + 2]),
                    ChatBotSDK.KeyboardButton(text: data.items[(data.page - 1) * 4 + 3])
                ],
                [
                    ChatBotSDK.KeyboardButton(text: "next")
                ],
            ],
            resizeKeyboard: true,
            oneTimeKeyboard: true
        )
        self.data = data
        return FlowInputHandlerMarkup(texts: ["Pick item"], keyboard: keyboard, interrupt: false)
    }

    func handle(chat: Chat, user: User, text: String) -> FlowInputHandlerResult {

        guard var data = data else {
            return .end
        }

        if text == "next" {
            data.page += 1
        } else if text == "prev" {
            data.page -= 1
        }

        if text == "next" || text == "prev" {
            let keyboard = ReplyKeyboardMarkup(
                keyboard: [
                    [
                        KeyboardButton(text: data.items[(data.page - 1) * 4 + 0]),
                        KeyboardButton(text: data.items[(data.page - 1) * 4 + 1])
                    ],
                    [
                        KeyboardButton(text: data.items[(data.page - 1) * 4 + 2]),
                        KeyboardButton(text: data.items[(data.page - 1) * 4 + 3])
                    ],
                    [
                        KeyboardButton(text: data.page == 2 ? "prev" : "next")
                    ],
                ],
                resizeKeyboard: true,
                oneTimeKeyboard: true
            )

            let inputMarkup = FlowInputHandlerMarkup(
                texts: ["Pick item"],
                keyboard: keyboard,
                interrupt: false
            )

            return .stay(markup: inputMarkup)
        } else if !text.isEmpty {
            context.text = text
        }

        return .end
    }

}
