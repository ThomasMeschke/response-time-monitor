# frozen_string_literal: true

require_relative 'app/config'
require_relative 'app/service'
require_relative 'app/service_monitor'
require_relative 'app/template_engine'
require_relative 'app/web_server'

Thread.abort_on_exception = false

@services = []
Config['services'].each do |service_config|
  service = Service.new(
    service_config['name'],
    service_config['url'],
    service_config['path'],
    service_config['port']
  )
  service.good_below_ms ||= service_config['good_below_ms']
  service.bad_above_ms ||= service_config['bad_above_ms']
  @services << service
end

svc_monitor = ServiceMonitor.new(@services)

web_server = WebServer.new(Config['server-addr'], Config['server-port'])

@template = TemplateEngine.new(Config['template-file'])

def on_client_connected
  lambda { |client|
    unless client.gets.chomp.empty?
    end
    result = @template.render(binding)
    client.puts 'HTTP/1.1 200 OK'
    client.puts ''
    client.puts result
    client.close
  }
end

svc_monitor.watch
web_server.listen(&on_client_connected)
