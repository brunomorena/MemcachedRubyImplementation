require_relative 'logic'
require_relative 'constants'
require 'socket'
require 'time'
 
t = Time.now
logic = Logic.new
server = TCPServer.new(HOSTNAME, PORT)

loop do

  Thread.start(server.accept) do |client|
    puts "Server is running in port #{PORT}"
    client.puts "Connection established\r\n"
    client.puts t.strftime("Time is %H:%M:%S\r\n")
  
    while input = client.gets 
      
      command = input.split
      command_name = command[0]      
  
      case command_name
      when 'set'
        data_block = client.gets.strip 
        response = logic.set_logic(command, data_block)
        client.puts response

      when 'add'
        data_block = client.gets.strip
        response = logic.add_logic(command, data_block)
        client.puts response
        
      when 'replace'
        data_block = client.gets.strip
        response = logic.replace_logic(command, data_block)
        client.puts response

      when 'append'
        data_block = client.gets.strip
        response = logic.append_logic(command, data_block)
        client.puts response
        
      when 'prepend'
        data_block = client.gets.strip
        response = logic.prepend_logic(command, data_block)
        client.puts response

      when 'cas'
        data_block = client.gets.strip
        response = logic.cas_logic(command, data_block)
        client.puts response

      when 'get'
        response = logic.get_logic(command)
        client.puts response
        
      when 'gets'
        response = logic.gets_logic(command)
        client.puts response

      when 'purge'
        response = logic.purge_expired_keys
        client.puts response

      else
        client.puts ERROR
      end
    end
  end
end  
