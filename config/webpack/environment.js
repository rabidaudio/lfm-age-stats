const { environment } = require('@rails/webpacker')

console.log(environment.loaders.get('sass'))
console.log(environment.loaders.get('moduleSass'))
// environment.loaders.insert('sass', {
//   test: /\.s[ac]ss$/i,
//   use: [
//     // Creates `style` nodes from JS strings
//     'style-loader',
//     // Translates CSS into CommonJS
//     'css-loader',
//     // Compiles Sass to CSS
//     'sass-loader'
//   ],
// })

module.exports = environment
