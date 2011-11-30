module Travis
  class Hub
    module NewRelic
      module HubInstrumentation
        def receive(message, payload)
          params = {
            :message => message,
            :payload => payload
          }
          perform_action_with_newrelic_trace(:category => :controller, :name => :receive, :params => params) do
            super
          end
        end
      end

      def self.monitor
        puts "Starting New Relic with env:#{ENV['ENV']}"
        require 'newrelic_rpm'

        Travis::Hub.class_eval do
          include NewRelic::Agent::Instrumentation::ControllerInstrumentation
          include Travis::Hub::NewRelic::HubInstrumentation
        end

        NewRelic::Agent.manual_start(:env => ENV['ENV'])
      rescue Exception => e
        puts 'New Relic Agent refused to start!'
        puts e.message
        puts e.backtrace
      end
    end
  end
end
