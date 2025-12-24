local TEXT = "hackedbydougtest"
local TYPE_DELAY = 0.05
local MESSAGE_DELAY = 1

local VK = {
    A=0x41,B=0x42,C=0x43,D=0x44,E=0x45,F=0x46,G=0x47,
    H=0x48,I=0x49,J=0x4A,K=0x4B,L=0x4C,M=0x4D,
    N=0x4E,O=0x4F,P=0x50,Q=0x51,R=0x52,S=0x53,
    T=0x54,U=0x55,V=0x56,W=0x57,X=0x58,Y=0x59,Z=0x5A,
    SPACE=0x20,
    ENTER=0x0D
}

local function press(key)
    keypress(key)
    task.wait(0.01)
    keyrelease(key)
end

while true do
    -- Open chat
    press(VK.ENTER)
    task.wait(0.15)

    -- Type message
    for i = 1, #TEXT do
        local char = TEXT:sub(i, i)

        if char == " " then
            press(VK.SPACE)
        else
            local upper = char:upper()
            local key = VK[upper]
            if key then
                press(key)
            end
        end

        task.wait(TYPE_DELAY)
    end

    -- Send message
    press(VK.ENTER)
    task.wait(MESSAGE_DELAY)
end
