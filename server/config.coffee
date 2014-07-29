module.exports =
  port: 5555
  name: "my game"
  title: "game title"
  session:
    secret: "epicsecret"
    key: "rpsgame.sid"
    name: "rpsgame"
  mongo:
    url: "mongodb://127.0.0.1:27017/rps-game"
    host: "127.0.0.1"
    port: "27017"
    sessionDb: "rps-game-session"
  facebook:
    clientID: "333406160152539"
    clientSecret: "772f3905c21a7cb5e5d3eb189476850b"
    callback: "/auth/facebook/callback"
