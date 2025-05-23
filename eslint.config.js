import neostandard from 'neostandard'

export default neostandard({
  env: ['browser'],
  ignores: [
    'app/assets',
    'coverage',
    'node_modules',
    'vendor',
  ],
})
