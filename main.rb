# frozen_string_literal: true

require_relative 'app/config'
require_relative 'app/service'
require_relative 'app/service_monitor'
require_relative 'app/template_engine'
require_relative 'app/web_server'

@services = []
Config['services'].each { |service|
    @services << Service.new(
        service['name'], 
        service['url'], 
        service['path'], 
        service['port'], 
        service['good_below_ms'], 
        service['bad_above_ms']
    )
}

svc_monitor = ServiceMonitor.new(@services)

webserver = WebServer.new(Config['server-addr'], Config['server-port'])

@tmpl = TemplateEngine.new(Config['template-file'])

def on_client_connected
    lambda { |client|
        while !client.gets.chomp.empty? do
        end
        result = @tmpl.render(binding)
        client.puts "HTTP/1.1 200 OK"
        client.puts ""
        client.puts result
        client.close
    }
end

svc_monitor.watch
webserver.listen &on_client_connected
