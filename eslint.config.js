import neostandard from 'neostandard'

export default [
  { ignores: ['app/assets/builds/*'] },
  ...neostandard({env: ['browser']}),
]
