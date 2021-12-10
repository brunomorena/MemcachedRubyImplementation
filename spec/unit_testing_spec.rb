require_relative '../logic'

logic = Logic.new

describe Logic do 
    
    context "When testing the set command" do
        it "should store the data and return a success message" do
            command = ["set", "foo", "3", "300", "5"]
            data_block = "hello"
            expect(logic.set_logic(command, data_block)).to eq(STORED)
        end
        it "should not store the data and return an error message about arguments number" do
            command = ["set", "foo", "3", "300"]
            data_block = "hola"
            expect(logic.set_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end
        it "should not store the data and return an error message about arguments type" do
            command = ["set", "foo", "3e", "300", "5t"]
            data_block = "hello"
            expect(logic.set_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end
        it "should not store the data and return an error message about bytes asigned" do
            command = ["set", "foo", "3", "300", "5"]
            data_block = "hello world"
            expect(logic.set_logic(command, data_block)).to eq(BYTES_NOT_MATCH)
        end
        it "should not store the data and return an error message about expiration time" do
            command = ["set", "foo", "3", "2592001", "5"]
            data_block = "hello"
            expect(logic.set_logic(command, data_block)).to eq(MAX_EXPTIME)
        end
    end

    context "When testing the add command" do
        it "should store the data and return a success message" do
            command = ["add", "bar", "5", "400", "5"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(STORED)
        end

        it "should not store the data and return an error message about arguments number" do
            command = ["add", "bar", "5", "300", "5", "2", "1"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end

        it "should not store the data and return an error message about arguments type" do
            command = ["add", "bar", "six", "30O", "5"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end

        it "should not store the data and return an error message about bytes asigned" do
            command = ["add", "bar", "5", "400", "2"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(BYTES_NOT_MATCH)
        end

        it "should not store the data and return an error message about expiration time" do
            command = ["add", "bar", "5",  "2592001", "5"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(MAX_EXPTIME)
        end

        it "should not store the data and return an error message about the key is already stored" do
            command = ["add", "foo", "5", "400", "5"]
            data_block = "world"
            expect(logic.add_logic(command, data_block)).to eq(KEY_ALREADY_STORED)
        end    
    end

    context "When testing the replace command" do
        it "should replace the data and return a success message" do
            command = ["replace", "foo", "7", "400", "3"]
            data_block = "bye"
            expect(logic.replace_logic(command, data_block)).to eq(STORED)
        end

        it "should not replace the data and return an error message about arguments number" do
            command = ["replace", "foo", "400", "3"]
            data_block = "bye"
            expect(logic.replace_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end

        it "should not replace the data and return an error message about arguments type" do
            command = ["replace", "foo", "7", "4OO", "l1"]
            data_block = "bye"
            expect(logic.replace_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end

        it "should not replace the data and return an error message about the key is not stored" do
            command = ["replace", "buu", "7", "400", "3"]
            data_block = "bye"
            expect(logic.replace_logic(command, data_block)).to eq(NO_KEY_STORED)
        end
        
        it "should not replace the data and return an error message about the key is not stored" do
            command_set = ["set", "buz", "7", "-1", "3"] #key immediately expired
            data_block_set = "exp"
            logic.set_logic(command_set, data_block_set)
            command = ["replace", "buz", "7", "400", "3"]
            data_block = "bye"
            expect(logic.replace_logic(command, data_block)).to eq(EXPIRED_KEY)
        end
        

    end

    context "When testing the append command" do
        it "should add the data to an existing key after existing data and return a success message" do
            command = ["append", "foo", "0", "800", "6"]
            data_block = "-after"
            expect(logic.append_logic(command, data_block)).to eq(STORED)
        end

        it "should not add the data to an existing key after existing data and return a message about arguments number" do
            command = ["append", "foo", "0", "6"]
            data_block = "-after"
            expect(logic.append_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end

        it "should not add the data to an existing key after existing data and return a message about arguments type" do
            command = ["append", "foo", "0", "500s", "6"]
            data_block = "-after"
            expect(logic.append_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end

        it "should not add the data to an existing key after existing data and return a message about the key is not stored" do
            command = ["append", "fof", "0", "800", "6"]
            data_block = "-after"
            expect(logic.append_logic(command, data_block)).to eq(NO_KEY_STORED)
        end
    end

    context "When testing the prepend command" do
        it "should add the data an existing key before existing data and return a success message" do
            command = ["append", "foo", "0", "900", "7"]
            data_block = "before-"
            expect(logic.prepend_logic(command, data_block)).to eq(STORED)
        end

        it "should not add the data an existing key before existing data and return a message about arguments number" do
            command = ["append", "foo", "7"]
            data_block = "before-"
            expect(logic.prepend_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end

        it "should not add the data an existing key before existing data and return a message about arguments type" do
            command = ["append", "foo", "cero", "900s", "7"]
            data_block = "before-"
            expect(logic.prepend_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end

        it "should not add the data to an existing key after existing data and return a message about the key is not stored" do
            command = ["append", "fof", "0", "900", "7"]
            data_block = "before-"
            expect(logic.prepend_logic(command, data_block)).to eq(NO_KEY_STORED)
        end
    end

    context "When testing the cas command" do
        it "should check and store the data only if no one else has updated since the time last fetched it, and return a success message" do
            command = ["cas", "bar", "8", "600", "11", "2"]
            data_block = "checkandset"
            expect(logic.cas_logic(command, data_block)).to eq(STORED)
        end

        it "should check and not store the data, and return an error message about arguments number" do
            command = ["cas", "bar", "8", "600", "11"]
            data_block = "checkandset"
            expect(logic.cas_logic(command, data_block)).to eq(ARGUMENTS_NUMBER)
        end

        it "should check and not store the data, and return an error message about arguments type" do
            command = ["cas", "bar", "8", "600s", "11", "two"]
            data_block = "checkandset"
            expect(logic.cas_logic(command, data_block)).to eq(ARGUMENTS_TYPE)
        end

        it "should check and not store the data, and return an error message about the key is not stored" do
            command = ["cas", "bat", "8", "600", "11", "2"]
            data_block = "checkandset"
            expect(logic.cas_logic(command, data_block)).to eq(NO_KEY_STORED)
        end

        it "should check and not store the data, and return an error message about that the item you are trying to store has been modified since you last fetched it" do
            command = ["cas", "foo", "8", "600", "11", "1"]
            data_block = "checkandset"
            expect(logic.cas_logic(command, data_block)).to eq(EXISTS)
        end

    end

    context "When testing the get command" do
        it "should return a text line followed by a data block and an end message" do
            command = ["get", "foo"]
            expect(logic.get_logic(command)).to eq("VALUE " + "foo" + " " + "7" + " " + "16" + "\r\n" + "before-bye-after" + "\r\n" + "END\r\n")
        end

        it "should return an error message about that arguments number" do
            command = ["get", "foo", "bar"]
            expect(logic.get_logic(command)).to eq(GET_ARGUMENTS_NUMBER)
        end

        it "should return an message about that the key is not found" do
            command = ["get", "none"]
            expect(logic.get_logic(command)).to eq(NO_KEY_FOUND)
        end

    end

    context "When testing the gets command" do
        it "should return a text line followed by a data block per each key entered and an end message" do
            command = ["gets", "foo", "bar"]
            expect(logic.gets_logic(command)).to eq("VALUE " + "foo" + " " + "7" + " " + "16" + " " +  "6" + "\r\n" + "before-bye-after" + "\r\n" + "VALUE " + "bar" + " " + "8" + " " + "11" + " " + "7" + "\r\n" + "checkandset" + "\r\n" + "END\r\n")
        end

        it "should return a text line followed by a data block for an existing key entered, a message about that the key is not found and an end message" do
            command = ["gets", "foo", "none"]
            expect(logic.gets_logic(command)).to eq("VALUE " + "foo" + " " + "7" + " " + "16" + " " +  "6" + "\r\n" + "before-bye-after" + "\r\n" + NO_KEY_FOUND + "END\r\n")
        end

        it "should return a message about that the key is not found and an end message" do
            command = ["gets", "none"]
            expect(logic.gets_logic(command)).to eq(NO_KEY_FOUND + "END\r\n")
        end

        it "should return an end message" do
            command = ["gets"]
            expect(logic.gets_logic(command)).to eq("END\r\n")
        end

    end


 end


