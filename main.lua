local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Gym Automation Panel",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "Made by eru 😜",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Auto Gym", 4483362458) -- Icon ID

-- Credit Label di dalam UI
MainTab:CreateLabel("Made by eru 😜")

-- Variable Pengaturan
local isRunning = false
local holdDuration = 5
local cooldownMinutes = 5

local VirtualInputManager = game:GetService("VirtualInputManager")

local function holdE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(holdDuration)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Loop Utamasi
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
                
                -- Jeda Cooldown (diubah ke detik)
                local cdSeconds = cooldownMinutes * 60
                for i = cdSeconds, 1, -1 do
                    if not isRunning then break end
                    task.wait(1)
                end
            end
        else
            task.wait(1) -- Cek status toggle setiap detik jika matikan
        end
    end
end)

-- UI Controls
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
