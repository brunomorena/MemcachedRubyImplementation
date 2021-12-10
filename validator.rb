require_relative 'storage'
require_relative 'constants'


def set_validator(full_command)
    if !storage_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !bytes_asigned(full_command[4], full_command[5])
        return false, BYTES_NOT_MATCH
    elsif !max_time(full_command[3])
        return false, MAX_EXPTIME
    else
        return true, STORED    
    end
end

def add_validator(full_command)
    if !storage_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !bytes_asigned(full_command[4], full_command[5])
        return false, BYTES_NOT_MATCH
    elsif !max_time(full_command[3])
        return false, MAX_EXPTIME
    elsif stored_key(full_command[1]) && !expired_key(full_command[1])
        return false, KEY_ALREADY_STORED
    else
        return true, STORED 
    end
end

def replace_validator(full_command)
    if !storage_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !bytes_asigned(full_command[4], full_command[5])
        return false, BYTES_NOT_MATCH
    elsif !max_time(full_command[3])
        return false, MAX_EXPTIME
    elsif !stored_key(full_command[1])
        return false, NO_KEY_STORED
    elsif expired_key(full_command[1])
        return false, EXPIRED_KEY
    else
        return true, STORED     
    end
end

def append_validator(full_command)
    if !storage_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !bytes_asigned(full_command[4], full_command[5])
        return false, BYTES_NOT_MATCH
    elsif !stored_key(full_command[1])
        return false, NO_KEY_STORED
    elsif expired_key(full_command[1])
        return false, EXPIRED_KEY
    else
        return true, STORED     
    end
end

def prepend_validator(full_command)
    if !storage_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !bytes_asigned(full_command[4], full_command[5])
        return false, BYTES_NOT_MATCH
    elsif !stored_key(full_command[1])
        return false, NO_KEY_STORED
    elsif expired_key(full_command[1])
        return false, EXPIRED_KEY
    else
        return true, STORED     
    end
end

def cas_validator(full_command)
    if !cas_arguments(full_command)
        return false, ARGUMENTS_NUMBER
    elsif !numeric_arguments(full_command)
        return false, ARGUMENTS_TYPE
    elsif !numeric(full_command[5])
        return false, ARGUMENTS_TYPE       
    elsif !bytes_asigned(full_command[4], full_command[6])
        return false, BYTES_NOT_MATCH
    elsif !max_time(full_command[3])
        return false, MAX_EXPTIME
    elsif !stored_key(full_command[1])
        return false, NO_KEY_STORED
    elsif expired_key(full_command[1])
        return false, EXPIRED_KEY   
    elsif !modified(full_command[1], full_command[5])
        return false, EXISTS
    else
        return true, STORED 
    end
end

def get_validator(command)

    if !get_arguments(command)
        return false, GET_ARGUMENTS_NUMBER 
    else
        return true
    end 
end

# def gets_validator(command)
# end

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

def storage_arguments(full_command)
    if full_command.length == 6
        return true
    else
        return false
    end
end

def cas_arguments(full_command)
    if full_command.length == 7
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
    return @callstorage.stored_key(key)        
end

def modified(key, cas_unique)
    if @callstorage.cas_unique(key).to_i == cas_unique.to_i 
        return true
    else
        return false
    end
end

def expired_key(key)
    return @callstorage.expired_key(key)
end

