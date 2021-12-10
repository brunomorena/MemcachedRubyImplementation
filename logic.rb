require_relative 'validator'
require_relative 'storage'
require_relative 'constants'
require 'time'

class Logic
    
    def initialize
        @callstorage = Storage.new
    end

    # "set" means "store this data".
    def set_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = set_validator(full_command)

        if validation
            exptime = Time.now + command[3].to_i
            @callstorage.set_storage(command[1], command[2], exptime, command[4], data_block)
        end
        return reply
    end
    
    # "add" means "store this data, but only if the server *doesn't* already hold data for this key".
    def add_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = add_validator(full_command)

        if validation
            exptime = Time.now + command[3].to_i
            @callstorage.add_storage(command[1], command[2], exptime, command[4], data_block)
        end
        return reply
    end
   
    # "replace" means "store this data, but only if the server *does* already hold data for this key".
    def replace_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = replace_validator(full_command)

        if validation
            exptime = Time.now + command[3].to_i
            @callstorage.replace_storage(command[1], command[2], exptime, command[4], data_block)
        end
        return reply
    end
    
    # "append" means "add this data to an existing key after existing data".
    def append_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = append_validator(full_command)

        if validation
            @callstorage.append_storage(command[1], command[4], data_block)
        end
        return reply
    end
  
    # "prepend" means "add this data to an existing key before existing data".
    def prepend_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = prepend_validator(full_command)

        if validation
            @callstorage.prepend_storage(command[1], command[4], data_block)
        end
        return reply
    end
    
    # "cas" is a check and set operation which means "store this data but only if no one else has updated since I last fetched it."
    def cas_logic(command, data_block)
        full_command = command.append(data_block)
        validation, reply = cas_validator(full_command)

        if validation
            exptime = Time.now + command[3].to_i
            @callstorage.cas_storage(command[1], command[2], exptime, command[4], data_block)
        end
        return reply
    end      

    def get_logic(command)
        validation, reply = get_validator(command)
        
        if validation
            reply = @callstorage.get_retrieval(command[1]) 
        end
        return reply
    end 
     
    def gets_logic(command)
        reply = @callstorage.gets_retrieval(command)
        return reply 
    end
    
    def purge_expired_keys
        @callstorage.purge_expired_keys
        return PURGED_EXP_KEYS
    end

end


