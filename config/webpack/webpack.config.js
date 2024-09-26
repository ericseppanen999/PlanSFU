// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')

const options = {
    resolve: {
        extensions: ['.css', '.js', '.jsx']
    }
}

const webpackConfig = generateWebpackConfig(options)

module.exports = webpackConfig
