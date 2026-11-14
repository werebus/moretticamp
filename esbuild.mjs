import fs from 'node:fs'
import path from 'node:path'
import * as esbuild from 'esbuild'

const isProduction = process.env.RAILS_ENV === 'production'
const revisionPath = path.join(process.cwd(), 'REVISION')
const revision = fs.existsSync(revisionPath)
  ? fs.readFileSync(revisionPath, 'utf8').trim()
  : undefined
const sentryRelease = revision

if (isProduction && !sentryRelease) {
  throw new Error('A production build requires a REVISION file for the Sentry release.')
}

const config = {
  entryPoints: [
    'app/javascript/sentry.js',
    'app/javascript/application.js'
  ],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  minify: isProduction,
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  define: {
    'globalThis.SENTRY_RELEASE': sentryRelease
      ? JSON.stringify(sentryRelease)
      : 'undefined'
  },
  loader: {
    '.css': 'empty'
  },
  logLevel: 'info'
}

if (process.argv.includes('--watch')) {
  const context = await esbuild.context(config)
  context.watch()
} else {
  await esbuild.build(config)
}
