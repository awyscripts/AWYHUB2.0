local stringChar = string.char
local stringByte = string.byte
local stringSub = string.sub
local tableInsert = table.insert
local tableConcat = table.concat
local bitLib = bit32 or bit
local XOR = bitLib.bxor

local function decryptXOR(encStr, key)
    local result = {}
    for i = 1, #encStr do
        local encByte = stringByte(stringSub(encStr, i, i))
        local keyByte = stringByte(stringSub(key, 1 + ((i-1) % #key), 1 + ((i-1) % #key)))
        tableInsert(result, stringChar(XOR(encByte, keyByte)))
    end
    return tableConcat(result)
end

local function loadEncryptedScript(url, key)
    local encrypted = game:HttpGet(url)
    local decrypted = decryptXOR(encrypted, key)
    loadstring(decrypted)()
end

loadEncryptedScript("https://raw.githubusercontent.com/awyscripts/AWY-HUB/dff1280b0cbc7653f53e7beb0a78d803d1a5060d/awydhc.lua", "MinhaChaveSecreta123")
