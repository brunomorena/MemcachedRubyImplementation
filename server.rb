require_relative 'factory'
require_relative 'logic_storage'
require_relative 'logic_retrieval'
require_relative 'logic_purge'
require_relative 'reply'
require_relative 'constants'
require 'socket'
require 'time'

class Server
  
  t = Time.now
  factory = Factory.instance
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
          command.append(data_block) 
          response = Factory.logic_storage.set_logic(command)
          client.puts response.reply

        when 'add'
          data_block = client.gets.strip
          command.append(data_block) 
          response = Factory.logic_storage.add_logic(command)
          client.puts response.reply
          
        when 'replace'
          data_block = client.gets.strip
          command.append(data_block) 
          response = Factory.logic_storage.replace_logic(command)
          client.puts response.reply

        when 'append'
          data_block = client.gets.strip
          command.append(data_block) 
          response = Factory.logic_storage.append_logic(command)
          client.puts response.reply
          
        when 'prepend'
          data_block = client.gets.strip
          command.append(data_block) 
          response = Factory.logic_storage.prepend_logic(command)
          client.puts response.reply

        when 'cas'
          data_block = client.gets.strip
          command.append(data_block) 
          response = Factory.logic_storage.cas_logic(command)
          client.puts response.reply

        when 'get'
          response = Factory.logic_retrieval.get_logic(command)
          client.puts response.reply
          
        when 'gets'
          response = Factory.logic_retrieval.gets_logic(command)
          client.puts response.reply

        when 'purge'
          response = Factory.logic_purge.purge_expired_keys
          client.puts response.reply

        else
          client.puts ERROR
        end
      end
    end
  end 
end