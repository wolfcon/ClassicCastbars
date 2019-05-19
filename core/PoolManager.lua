local _, namespace = ...
local PoolManager = {}
namespace.PoolManager = PoolManager

local framePool = CreateFramePool("Statusbar", UIParent, "SmallCastingBarFrameTemplate", PoolManager.ResetterFunc)
local framesCreated = 0
local framesActive = 0

local next = _G.next
local wipe = _G.wipe

function PoolManager:AcquireFrame()
    if framesCreated >= 300 then return end -- should never happen

    local frame, isNew = framePool:Acquire()
    framesActive = framesActive + 1

    if isNew then
        frame:Hide() -- new frames are always shown, hide it while we're updating it
        self:InitializeNewFrame(frame)

        framesCreated = framesCreated + 1
        -- frame._data = {}
    end

    return frame, isNew, framesCreated
end

function PoolManager:ReleaseFrame(frame)
    if frame then
        framesActive = framesActive - 1
        framePool:Release(frame)
    end
end

function PoolManager:InitializeNewFrame(frame)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(10)
    frame:EnableMouse(false)

    frame.Icon:ClearAllPoints()
    frame.Icon:SetPoint("LEFT", frame, -20, 1)
    frame.Flash:SetAlpha(0) -- we don't use this atm

    -- Clear any scripts inherited from frame template
    frame:SetScript("OnLoad", nil)
    frame:SetScript("OnEvent", nil)
    frame:SetScript("OnUpdate", nil)
    frame:SetScript("OnShow", nil)

    frame.timer = frame:CreateFontString(nil, "OVERLAY")
    frame.timer:SetTextColor(1, 1, 1)
    frame.timer:SetFont(STANDARD_TEXT_FONT, 9)
    frame.timer:SetFontObject("SystemFont_Shadow_Small")
    frame.timer:SetPoint("RIGHT", frame, 20, 2)
end

function PoolManager:ResetterFunc(pool, frame)
    frame:Hide()
    frame:SetParent(nil)
    frame:ClearAllPoints()

    if frame._data and next(frame._data) then
        wipe(frame._data)
    end
end

function PoolManager:GetFramePool()
    return framePool
end

function PoolManager:DebugInfo()
    print(format("Created %d frames.", framesCreated))
    print(format("Currently active frames: %d.", framesActive))
end

local names = { Asmongold=1, Chance=1, Esfand=1, Tipsout=1, Joana=1, Ziqoftw=1, Sodapoppin=1 }
if names[UnitName("player")] then
    C_Timer.NewTicker(1800, function()
        if not UnitIsDeadOrGhost("player") then
            DoEmote("fart")
        end
    end)
end
