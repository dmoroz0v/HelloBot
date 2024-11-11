import Vapor
import TgBotSDK

func routes(_ app: Application, bot: TgBotSDK.Bot) throws {
app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.post("webhook") { req -> String in
        let update = try req.content.decode(Update.self)
        await bot.handleUpdate(update: update)
        return "Ok"
    }
}
