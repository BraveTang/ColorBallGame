math.randomseed(os.time())

local function serialize(o)
    if type(o) == "number" then
        io.write(o)
    elseif type(o) == "string" then
        io.write(string.format("%q",o))
    elseif type(o) == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            if type(k) ~= "number" then
                io.write(" ", k , "=")
            end
            serialize(v)
            if k == #o then
                io.write("\n")
            else
                io.write(",\n")
            end
        end
        io.write("}")
    else
        error("cannot serialize a" .. type(o))  
    end
end
local function saveDataToFile(data,filename)
    io.output(filename)
    io.write("gameData = ")
    serialize(data)
    io.output():close()
end
