class DelayedStatusLogger < Delayed::Plugin

  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_jobs.log'))

  callbacks do |lifecycle|
    lifecycle.around(:execute) do |worker, *args, &block|
      puts "--->lifecycle worker: #{worker}"
      Rails.logger.tagged "X - Worker:#{worker.name_prefix.strip}", "Queues:#{worker.queues.join(',')}" do
        block.call(worker, *args)
        puts "---> RL worker: #{worker}"
      end
    end

    lifecycle.after(:perform) do |worker, job|
      puts "---> worker: #{worker}"
      puts "---> job: #{job}"
    end

    lifecycle.around(:invoke_job) do |job, *args, &block|
      Rails.logger.tagged "Job:#{job.id}" do
        block.call(job, *args)
      end
    end
  end
end
