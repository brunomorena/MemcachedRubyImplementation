require_relative 'storage'
require_relative 'constants'

##############################
# Storage validators

def set_validator(command)
    if !storage_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !bytes_asigned(command[4], command[5])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !max_time(command[3])
        validation = false
        msg = MAX_EXPTIME
    else
        validation = true
        msg =STORED    
    end
    return reply = Reply.new(validation, msg)
end

def add_validator(command)
    if !storage_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !bytes_asigned(command[4], command[5])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !max_time(command[3])
        validation = false
        msg = MAX_EXPTIME
    elsif stored_key(command[1]) && !expired_key(command[1])
        validation = false
        msg = KEY_ALREADY_STORED
    else
        validation = true
        msg = STORED 
    end
    return reply = Reply.new(validation, msg)
end

def replace_validator(command)
    if !storage_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !bytes_asigned(command[4], command[5])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !max_time(command[3])
        validation = false
        msg = MAX_EXPTIME
    elsif !stored_key(command[1])
        validation = false
        msg = NO_KEY_STORED
    elsif expired_key(command[1])
        validation = false
        msg = EXPIRED_KEY
    else
        validation = true 
        msg = STORED     
    end
    return reply = Reply.new(validation, msg)
end

def append_validator(command)
    if !storage_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !bytes_asigned(command[4], command[5])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !stored_key(command[1])
        validation = false
        msg = NO_KEY_STORED
    elsif expired_key(command[1])
        validation = false
        msg = EXPIRED_KEY
    else
        validation = true 
        msg = STORED     
    end
    return reply = Reply.new(validation, msg)
end

def prepend_validator(command)
    if !storage_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !bytes_asigned(command[4], command[5])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !stored_key(command[1])
        validation = false
        msg = NO_KEY_STORED
    elsif expired_key(command[1])
        validation = false
        msg = EXPIRED_KEY
    else
        validation = true
        msg = STORED     
    end
    return reply = Reply.new(validation, msg)
end

def cas_validator(command)
    if !cas_arguments(command)
        validation = false
        msg = ARGUMENTS_NUMBER
    elsif !numeric_arguments(command)
        validation = false
        msg = ARGUMENTS_TYPE
    elsif !numeric(command[5])
        validation = false
        msg = ARGUMENTS_TYPE       
    elsif !bytes_asigned(command[4], command[6])
        validation = false
        msg = BYTES_NOT_MATCH
    elsif !max_time(command[3])
        validation = false
        msg = MAX_EXPTIME
    elsif !stored_key(command[1])
        validation = false
        msg = NO_KEY_STORED
    elsif expired_key(command[1])
        validation = false
        msg = EXPIRED_KEY   
    elsif !modified(command[1], command[5])
        validation = false
        msg = EXISTS
    else
        validation = true
        msg = STORED 
    end
    return reply = Reply.new(validation, msg)
end

##############################
# Retrieval validators

def get_validator(command)

    if !get_arguments(command)
        validation= false 
        msg = GET_ARGUMENTS_NUMBER 
    else
        validation= true
        msg = ""
    end
    return reply = Reply.new(validation, msg) 
end

def gets_validator(command)
    return reply = Reply.new(true, "")
end

##############################
# Auxiliary validators

def numeric(object)
    true if Integer(object) rescue false 
end

def numeric_arguments(command)
    if numeric(command[2]) && numeric(command[3]) && numeric(command[4])
        return true
    else
        return false
    end 
end

def bytes_asigned(bytes, data_block) 
    if bytes.to_i == data_block.length
        return true
    else
        return false
    end
end

def max_time(exptime)
    if exptime.to_i <= MAX_TIME
        return true
    else 
        return false
    end
end

def storage_arguments(command)
    if command.length == 6
        return true
    else
        return false
    end
end

def cas_arguments(command)
    if command.length == 7
        return true
    else
        return false
    end
end

def get_arguments(command)
    if command.length == 2
        return true
    else
        return false
    end
end

def stored_key(key)
    return Factory.callstorage.stored_key(key)        
end

def modified(key, cas_unique)
    if Factory.callstorage.cas_unique(key).to_i == cas_unique.to_i 
        return true
    else
        return false
    end
end

def expired_key(key)
    return Factory.callstorage.expired_key(key)
end