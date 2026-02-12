function terminate(server, options = { coredump: false, timeout: 500 }) {
  const exit = (code) => {
    options.coredump ? process.abort() : process.exit(0);
  };
  return (code, reason) => (err, promise) => {
    if (err && err instanceof Error) {
      /*
            global.logger.error(
              `!!!!ETEINT!!!!>>${reason}-${code}-${err.stack}`
            );
      */
      console.log(err.message, err.stack);
    }
    server.close(exit);
    setTimeout(exit, options.timeout).unref();
  };
}

module.exports = terminate;
