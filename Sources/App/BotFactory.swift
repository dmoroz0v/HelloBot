import Foundation
import TgBotSDK
import Vapor

public final class BotFactory {

    public init() {}

    public func tgBot(_ app: Application) -> TgBotSDK.Bot {
        return TgBotSDK.Bot(
            botAssembly: BotAssemblyImpl(app: app),
            token: Environment.get("BOT_TOKEN") ?? "",
            apiEndpoint: "https://api.telegram.org/bot"
        )
    }
}
