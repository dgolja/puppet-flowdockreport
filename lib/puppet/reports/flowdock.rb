require 'puppet'
require 'yaml'

begin
  require 'flowdock'
rescue LoadError
  Puppet.warning "You need the `flowdock` gem to use the Flowdock report"
end

Puppet::Reports.register_report(:flowdock) do
  desc "Process reports via flowdock API."

  configfile = File.join([File.dirname(Puppet.settings[:config]), "flowdock.yaml"])
  begin
    config = YAML.load_file(configfile)
  rescue => e
    fail Puppet::ParseError, "Flowdock report config file #{configfile} is not valid. #{e.message}"
  end

  DISABLED_FILE = File.join([File.dirname(Puppet.settings[:config]), 'flowdock_disabled'])
  EXTERNAL_USER = config['external_user_name'] || 'PuppetFlowdock'

  FLOWS = config['flows'] || {}

  #define default emojis

  EMOJIS = {
    'changed' => ':wind_chime:',
    'failed' => ':fail:',
    'unchanged' => ':neutral_face:'
  }

  def process
    return if File.exists?(DISABLED_FILE)
    
    FLOWS.each do |_,settings|
      report_statusues = settings['statuses'] || ['failed']
      mention = settings['mention'] || []
      # add a special flowdock keyword to alert the user(s)
      mention.map! {|v| v.match(/^@/) ? v : "@#{v}"}

      # are we interested in this report ?
      next unless report_statusues.include?(self.status)

      # check if we care about tne environment and if so if it's the right one
      if settings['environment']
        next unless settings['environment'].include?(self.environment)
      end

      # check if the hostname match the requests
      if settings['host']
        next unless self.host =~ Regexp.new(settings['host'])
      end

      content = "#{EMOJIS[self.status]} Puppet run on #{self.host} #{self.status} #{mention.collect { |p| p.to_s}.join(", ")}"
      # create Flow object
      flow = Flowdock::Flow.new(:api_token => settings['api'], :external_user_name => EXTERNAL_USER)

      # send message to Chat
      flow.push_to_chat(:content => content, :tags => [self.host, self.environment, self.status])
      Puppet.debug(content)
    end

  end
end
