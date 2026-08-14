import neostandard from 'neostandard'
import { globalIgnores } from 'eslint/config'

export default [
  globalIgnores([
    '.bundle/',
    'app/assets/',
    'coverage',
    'vendor/',
  ]),

  ...neostandard({
    env: ['browser'],
  }),
]
