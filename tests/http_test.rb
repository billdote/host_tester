module HTTPTest
  def http_resolver(host, timeout = 10, max_attempts = 10)
    attempts = 0
    begin
      until attempts >= max_attempts
        attempts += 1

        uri = URI.parse(host)
        http = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl?(uri), open_timeout: timeout, read_timeout: timeout)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        # try to follow HTTP redirects to get final response code
        case response
        when Net::HTTPRedirection
          location = response['Location']
          new_uri = URI.parse(location)
          host = if new_uri.relative?
                   (uri + location).to_s
                 else
                   new_uri.to_s
                 end
        else
          break
        end
      end
      raise 'Too many http redirects' if attempts == max_attempts
      response
    rescue Net::OpenTimeout
      'REQUEST TIMED OUT'
    end
  end

  def http_test
    http_host.each do |host|
      response = http_resolver(host)

      if response == 'REQUEST TIMED OUT'
        puts "response from #{host}: " + response.red
      elsif response.code =~ /^2.*/
        puts "response from #{host}: " + "#{response.code} OK".green
      else
        puts "response from #{host}: " + "#{response.code} NOT OK".red
      end
    end
  end

  def ssl?(uri)
    # use ssl for HTTPS objects
    uri.instance_of?(URI::HTTPS) ? true : false
  end
end
