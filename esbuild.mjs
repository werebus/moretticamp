import * as esbuild from 'esbuild'

const isProduction = process.env.RAILS_ENV === 'production';
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
  loader: {
    '.css': 'empty'
  },
  logLevel: 'info'
}

if (process.argv.includes('--watch')) {
  let context = await esbuild.context(config);
  context.watch();
} else {
  await esbuild.build(config);
}
