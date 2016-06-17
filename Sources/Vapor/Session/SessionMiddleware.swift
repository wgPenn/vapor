/**
    Looks for the `vapor-session` cookie on incoming
    requests and attempts to initialize a Session based on the
    identifier found.

    If an active Session is found on the request when the response
    is being made, the Session identifier is returned as a `vapor-session` cookie.
*/
class SessionMiddleware: Middleware {

    var driver: SessionDriver

    init(session: SessionDriver) {
        driver = session
    }

    func respond(to request: HTTP.Request, chainingTo chain: HTTP.Responder) throws -> HTTP.Response {
        // mutable -- MUST be declared at top of function
        if
            let sessionIdentifier = request.cookies["vapor-session"]
            where driver.contains(identifier: sessionIdentifier)
        {
            request.session = Session(identifier: sessionIdentifier, driver: driver)
        } else {
            request.session = Session(driver: driver)
        }

        let response = try chain.respond(to: request)

        // TODO: Tanner, halp
//        if let identifier = request.session?.identifier {
//            response.cookies["vapor-session"] = identifier
//        }

        return response
    }

}
