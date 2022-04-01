#!/usr/bin/env ruby

require 'bundler/setup'
require 'net/ping'
require 'net/http'
require 'socket'
require 'colorize'

require_relative 'tests/ping_test'
require_relative 'tests/http_test'

class HealthCheck
  include PingTest
  include HTTPTest

  attr_accessor :ping_host, :http_host

  def initialize
    @ping_host = {}
    @http_host = []
  end

  def run
    File.open('hosts.txt').each do |line|
      next if line.chomp.empty?
      # format the line to only use the domain
      format_line = line.chomp.match(%r{(?<=//).*?(?=/|$)}).to_s
      ping_host[line.chomp] = IPSocket.getaddress(format_line)
    end
    ping_test unless ping_host.empty?

    File.open('hosts.txt').each { |line| http_host << line.chomp unless line.chomp.empty? }
    http_test unless http_host.empty?
  end
end

HealthCheck.new.run
