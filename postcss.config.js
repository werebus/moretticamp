module.exports = {
  syntax: 'postcss-scss',
  plugins: [
    require('@csstools/postcss-sass')({
      includePaths: ['node_modules'],
      quietDeps: true,
      silenceDeprecations: ['import']
    }),
    require('postcss-nesting'),
    require('autoprefixer'),
  ],
}
