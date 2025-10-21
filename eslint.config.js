import neostandard from 'neostandard'

export default neostandard({
  env: ['browser'],
  ignores: [
    '.bundle',
    'app/assets',
    'coverage',
    'node_modules',
    'vendor',
  ],
})
