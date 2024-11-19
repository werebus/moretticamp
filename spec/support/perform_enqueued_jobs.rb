# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:each, :perform_enqueued, type: :job) do |example|
    @_perform_enqueued =
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs
    @_perform_enqueued_at =
      ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs

    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true

    example.run

    ActiveJob::Base.queue_adapter.perform_enqueued_jobs =
      @_perform_enqueued
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs =
      @_perform_enqueued_at
  end
end
