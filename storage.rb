require_relative 'storery'
require_relative 'constants'

class Storage

    def initialize
        @storage = {} # hash
    end

    def set_storage(key, flags, exptime, bytes, data_block)
        @storage[key] = Storery.new(flags, exptime, bytes, data_block)
        @storage[key].cas_increment
    end  

    def add_storage(key, flags, exptime, bytes, data_block)
        @storage[key] = Storery.new(flags, exptime, bytes, data_block)
        @storage[key].cas_increment
    end
    
    def replace_storage(key, flags, exptime, bytes, data_block)
        @storage.delete(key)
        @storage[key] = Storery.new(flags, exptime, bytes, data_block)
        @storage[key].cas_increment
    end
    
    def append_storage(key, bytes, data_block)
        @storage[key].bytes = @storage[key].bytes.to_i + bytes.to_i
        actual_data = @storage[key].data_block
        new_data = actual_data + data_block
        @storage[key].data_block = new_data  
        @storage[key].cas_increment  
    end
   
    def prepend_storage(key, bytes, data_block)
        @storage[key].bytes = @storage[key].bytes.to_i + bytes.to_i
        actual_data = @storage[key].data_block
        new_data = data_block + actual_data 
        @storage[key].data_block = new_data    
        @storage[key].cas_increment
    end
    
    def cas_storage(key, flags, exptime, bytes, data_block)
        @storage[key] = Storery.new(flags, exptime, bytes, data_block)
        @storage[key].cas_increment
    end

    def get_retrieval(key)
        if stored_key(key) && !expired_key(key)
            reply = "VALUE " + key + " " + @storage[key].flags.to_s + " " + @storage[key].bytes.to_s + "\r\n" + @storage[key].data_block + "\r\n" + "END\r\n"
        else
            reply = NO_KEY_FOUND
        end
        return reply
    end
    
    def gets_retrieval(command)
        n = command.length
        reply = ""
        i = 1
        while i <= n-1 do 
            if stored_key(command[i]) && !expired_key(command[i])
                reply = reply + "VALUE " + command[i] + " " + @storage[command[i]].flags.to_s + " " + @storage[command[i]].bytes.to_s + " " + @storage[command[i]].cas_unique.to_s + "\r\n" + @storage[command[i]].data_block + "\r\n"
            else
                reply = reply + NO_KEY_FOUND
            end
            i+= 1 
        end
        reply = reply + "END\r\n"
        return reply
    end

    def purge_expired_keys
        @storage.each do |key, value|
            if expired_key(key)
                @storage.delete(key)
            end
        end
    end

##############################
# Auxiliary functions

    def stored_key(key)
        if @storage.has_key?(key) 
            return true        
        else
           return false 
        end
    end

    def cas_unique(key)
        return @storage[key].cas_unique
    end

    def expired_key(key)
        actual_time = Time.now
        diff = @storage[key].exptime - actual_time
        if diff <= 0
            @storage.delete(key)
            return true
        else
            return false
        end
    end

end