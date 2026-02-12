function errorHandler(err, req, res, next) {
    if (typeof err === "string") {
        helplog(err, req, res, 1);
        return res.status(200).json({ message: err, code: 1 });
    }
    if (err.name === "ValidationError") {
        helplog(err, req, res, 2);
        return res.status(400).json({ message: err.message + "  😢", code: 2 });
    }
    if (err.name === "UnauthorizedError") {
        helplog(err, req, res, 3);
        return res.status(401).json({ message: "Invalid Token", code: 3 });
    }
    if (err.name === "ForbiddenError") {
        helplog(err, req, res, 4);
        return res.status(401).json({ message: "Invalid Token", code: 4 });
    }
    if (err.name === "JsonWebTokenError") {
        helplog(err, req, res, 5);
        return res.status(401).json({ message: "Invalid Token", code: 5 });
    }
    if (err.name === "AssertionError") {
        helplog(err, req, res, 6);
        return res.status(200).json({ message: err.message, code: 6 });
    }
    if (err.name === "ZodError") {
        helplog(err, req, res, 6);
        return res.status(200).json({ message: err.issues?.[0]?.message ?? err.message, issues: err.issues, code: 7 });
    }
    helplog(err, req, res, 500);
    return res
        .status(500)
        .json({ message: "Une erreur est survenue, veuillez réessayer plus tard", code: 500 });
}
function helplog(err, req, res, code) {
    console.log("💡💡💡", {
        name: err.name,
        message: err,
        code,
    });
    // global.logger.error(
    //     `${err.status || 500} - ${code} - ${err.message || err} - ${req.originalUrl
    //     } - ${req.method} - ${req.ip}- ${JSON.stringify(
    //         req.body
    //     )}- ${JSON.stringify(req.query)}- ${JSON.stringify(req.headers)}`
    // );
}
module.exports = errorHandler;
