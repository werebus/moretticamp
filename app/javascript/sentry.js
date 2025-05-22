import * as Sentry from '@sentry/browser'

Sentry.init({
  dsn: 'https://c19a3cc721b0690f4e3cd46684281381@o4509191950303232.ingest.us.sentry.io/4509191952400384',
  sendDefaultPii: true,
  release: 'moretti-camp',
  integrations: [
    Sentry.browserTracingIntegration(),
  ],
  tracesSampleRate: 1.0,
  tracePropagationTargets: [
    'localhost',
    /^https:\/\/moretti.camp/
  ]
})
