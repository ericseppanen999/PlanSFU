// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
//process.env.NODE_ENV = process.env.NODE_ENV || 'production';
const { generateWebpackConfig } = require("shakapacker");
const CompressionPlugin = require("compression-webpack-plugin");
const BrotliPlugin = require("brotli-webpack-plugin");
const TerserPlugin = require('terser-webpack-plugin');

const options = {
  //mode: "production",
  mode: "development",
  resolve: {
    extensions: [".css", ".js", ".jsx"],
  },

  optimization: {
    minimizer: [
      new TerserPlugin({
        parallel: true,
        terserOptions: {
          ecma: 6,
        },
      }),
    ],
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
