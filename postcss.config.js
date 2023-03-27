module.exports = {
  syntax: 'postcss-scss',
  plugins: [
    require('@csstools/postcss-sass')( { includePaths: ['node_modules'], quietDeps: true } ),
    require('postcss-nesting'),
    require('autoprefixer'),
  ],
}
