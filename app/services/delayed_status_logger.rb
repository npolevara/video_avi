class DelayedStatusLogger < Delayed::Plugin

  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_jobs.log'))

  callbacks do |lifecycle|
    lifecycle.around(:execute) do |worker, *args, &block|
      Rails.logger.tagged "X - Worker:#{worker.name_prefix.strip}", "Queues:#{worker.queues.join(',')}" do
        block.call(worker, *args)
      end
    end
  end
end
