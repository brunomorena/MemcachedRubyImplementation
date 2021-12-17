require_relative 'validator'
require_relative 'storage'
require_relative 'constants'
require 'time'

class LogicRetrieval
    
    # After this command, the client expects zero or one item, each of which is received as a text line followed by a data block.
    def get_logic(command)
        reply = get_validator(command)
        
        if reply.validation
            reply.reply =  Factory.callstorage.get_retrieval(command[1]) 
        end
        return reply
    end 
    
    # After this command, the client expects zero or more items, each of which is received as a text line followed by a data block.
    def gets_logic(command)
        reply = gets_validator(command)
        reply.reply = Factory.callstorage.gets_retrieval(command)
        return reply 
    end
    
end
