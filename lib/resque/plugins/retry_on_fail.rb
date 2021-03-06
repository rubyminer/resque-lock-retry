module Resque
  module Plugins

    # If you want your job to retry when an exception is encountered, extend
    # this module. Override +retried_exceptions+ to return an array of the
    # exceptions that are ok to retry on. There are no defaults.
    module RetryOnFail
      include Retried

      # Convenience method to test whether your class will retry on a given
      # exception type.
      def retried_on_exception?(ex)
        !! retried_exceptions.any? { |e| e >= ex }
      end

      # Override in your subclass to control how long to wait before
      # re-queueing the job when a lock is encountered. Note that the job will
      # block other jobs while this wait occurs. Return nil to perform no
      # delay.
      def retried_exceptions
        []
      end

      # Use resque's failure hook.
      def on_failure_retry_on_fail(e, *args)
        try_again(*args) if retried_on_exception?(e.class)
      end

    end
  end
end