// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require("shakapacker");
const CompressionPlugin = require("compression-webpack-plugin");
const BrotliPlugin = require("brotli-webpack-plugin");

const options = {
  resolve: {
    extensions: [".css", ".js", ".jsx"],
  },
  plugins: [
    new CompressionPlugin({
      filename: "[path][base].gz",
      algorithm: "gzip",
      test: /\.(js|css|html|svg)$/,
      threshold: 10240,
      minRatio: 0.8,
    }),

    new BrotliPlugin({
      filename: "[path][base].br",
      test: /\.(js|css|html|svg)$/,
      threshold: 10240,
      minRatio: 0.8,
    }),
  ],
};

module.exports = generateWebpackConfig(options);
