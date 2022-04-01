module PingTest
  def up?(host)
    check = Net::Ping::External.new(host)
    check.ping?
  end

  def ping_test
    ping_host.each do |key, host|
      if up?(host) == true
        puts "#{key} pingable? " + 'YES'.green
      else
        puts "#{key} pingable? " + 'NO'.red
      end
    end
  end
end
