module.exports = {
  colors: true,
  entry: "./client/app.coffee",
  output: {
      path: __dirname + "/client",
      filename: "bundle.js"
  },
  module: {
    loaders: [
      { test: /\.coffee/, loader: "coffee-loader" },
    ]
  }  
}
