local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- PASTIIN LINK DI BAWAH INI ADALAH LINK "RAW" GITHUB (Ada tulisan raw.githubusercontent.com)
local keyFileURL = "https://raw.githubusercontent.com/username/repository-kamu/main/keys.lua"

local validKeys = {}
local success, result = pcall(function()
    return loadstring(game:HttpGet(keyFileURL))()
end)

if success and type(result) == "table" then
    validKeys = result
else
    warn("Gagal mengambil data key dari GitHub. Cek URL RAW kamu!")
end

local isKeyAccepted = false

-- Buat Window Utama
local Window = Rayfield:CreateWindow({
   Name = "Gym Automation Panel",
   LoadingTitle = "Checking Key...",
   LoadingSubtitle = "Made by eru 😜",
   ConfigurationSaving = { Enabled = false }
})

-- Tab Verifikasi Key
local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
   Name = "Masukkan Key Kamu",
   PlaceholderText = "Input Key Di Sini...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
       if validKeys[Text] then
           Rayfield:Notify({Title = "Berhasil", Content = "Key Valid! Membuka Fitur...", Duration = 3})
           isKeyAccepted = true
       else
           Rayfield:Notify({Title = "Gagal", Content = "Key Tidak Valid atau Gagal Download!", Duration = 3})
       end
   end,
})

-- Tunggu sampai user memasukkan key yang valid
repeat task.wait(0.5) until isKeyAccepted

---------------------------------------------------------
-- FITUR GYM UTAMA
---------------------------------------------------------

local MainTab = Window:CreateTab("Auto Gym", 4483362458)
MainTab:CreateLabel("Made by eru 😜")

local isRunning = false
local holdDuration = 5
local cooldownMinutes = 5

local VirtualInputManager = game:GetService("VirtualInputManager")

local function holdE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(holdDuration)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

task.spawn(function()
    while true do
        if isRunning then
            Rayfield:Notify({Title = "Status", Content = "Melakukan Hold E (1/2)", Duration = 3})
            holdE()
            
            task.wait(1)
            
            if isRunning then
                Rayfield:Notify({Title = "Status", Content = "Melakukan Hold E (2/2)", Duration = 3})
                holdE()
                
                Rayfield:Notify({Title = "Status", Content = "Cooldown dimulai (" .. cooldownMinutes .. " menit)", Duration = 5})
                
                local cdSeconds = cooldownMinutes * 60
                for i = cdSeconds, 1, -1 do
                    if not isRunning then break end
                    task.wait(1)
                end
            end
        else
            task.wait(1)
        end
    end
end)

local Toggle = MainTab:CreateToggle({
   Name = "Enable Auto Gym (Hold E)",
   CurrentValue = false,
   Flag = "AutoGymToggle",
   Callback = function(Value)
       isRunning = Value
   end,
})

local SliderHold = MainTab:CreateSlider({
   Name = "Hold Duration (Detik)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "s",
   CurrentValue = 5,
   Flag = "HoldDurationSlider",
   Callback = function(Value)
       holdDuration = Value
   end,
})

local SliderCD = MainTab:CreateSlider({
   Name = "Cooldown Duration (Menit)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "m",
   CurrentValue = 5,
   Flag = "CooldownSlider",
   Callback = function(Value)
       cooldownMinutes = Value
   end,
})
