require_relative 'validator'
require_relative 'storage'
require_relative 'constants'
require 'time'

class LogicStorage   

    # "set" means "store this data".
    def set_logic(command)
        reply = set_validator(command)

        if reply.validation
            exptime = Time.now + command[3].to_i
            Factory.callstorage.set_storage(command[1], command[2], exptime, command[4], command[5])
        end
        return reply
    end

    # "add" means "store this data, but only if the server *doesn't* already hold data for this key".
    def add_logic(command)
        reply = add_validator(command)

        if reply.validation
            exptime = Time.now + command[3].to_i
            Factory.callstorage.add_storage(command[1], command[2], exptime, command[4], command[5])
        end
        return reply
    end
   
    # "replace" means "store this data, but only if the server *does* already hold data for this key".
    def replace_logic(command)
        reply = replace_validator(command)

        if reply.validation
            exptime = Time.now + command[3].to_i
            Factory.callstorage.replace_storage(command[1], command[2], exptime, command[4], command[5])
        end
        return reply
    end
    
    # "append" means "add this data to an existing key after existing data".
    def append_logic(command)
        reply = append_validator(command)

        if reply.validation
            Factory.callstorage.append_storage(command[1], command[4], command[5])
        end
        return reply
    end
  
    # "prepend" means "add this data to an existing key before existing data".
    def prepend_logic(command)
        reply = prepend_validator(command)

        if reply.validation
            Factory.callstorage.prepend_storage(command[1], command[4], command[5])
        end
        return reply
    end
    
    # "cas" is a check and set operation which means "store this data but only if no one else has updated since I last fetched it."
    def cas_logic(command)
        reply = cas_validator(command)

        if reply.validation
            exptime = Time.now + command[3].to_i
            Factory.callstorage.cas_storage(command[1], command[2], exptime, command[4], command[5])
        end
        return reply
    end
    
end
