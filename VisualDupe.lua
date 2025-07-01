-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Hipedisa/VisualDupe/refs/heads/main/VisualDupe.lua"))()   

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Spawner = loadstring(game:HttpGet("https://codeberg.org/GrowAFilipino/GrowAGarden/raw/branch/main/Spawner.lua"))()
local playerNames = {}

function UpdatePlayers()
	playerNames = {}

	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Name ~= game.Players.LocalPlayer.Name then
			table.insert(playerNames, player.Name)
		end
	end

end

local myPets = {}
for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if item.Name:find("Age") then
		table.insert(myPets, item.Name)
	end	
end

-- Create main UI window
local Window = WindUI:CreateWindow({
	Title = "Grow a Garden",
	Icon = "door-open",
	Author = "OP Script",
	Folder = "CloudHub",
	Size = UDim2.fromOffset(420, 310),
	Transparent = true,
	Theme = "Dark",
	SideBarWidth = 200,
	Background = "",
	BackgroundImageTransparency = 0.42,
	HideSearchBar = true,
	ScrollBarEnabled = false,
	User = {
		Enabled = true,
		Anonymous = true,
		Callback = function()
			print("clicked")
		end,
	}
})

Window:SetToggleKey(Enum.KeyCode.LeftControl)

-- Autofarm Tab
local FarmTab = Window:Tab({
	Title = "Autofarm",
	Icon = "zap",
	Locked = false,
})

FarmTab:Section({
    Title = "Coming Soon...",
    TextXAlignment = "Center",
    TextSize = 17,
})

-- Pet Dupe Tab
local DupeTab = Window:Tab({
	Title = "Pet Dupe",
	Icon = "paw-print",
	Locked = false,
})

local selectedPet = myPets[1]

local dupeDropDown = DupeTab:Dropdown({
	Title = "Select Pet",
	Values = myPets,
	Value = selectedPet,
	Callback = function(option)
		selectedPet = option
	end
})

DupeTab:Button({
    Title = "Dupe Pet",
    Desc = "This button dupes the selected pet",
    Locked = false,
    Callback = function()
        print(selectedPet)
        local name, kg, age = string.match(selectedPet, "^(.-) %[(%d+%.?%d*) KG%] %[Age (%d+)%]")

        print(name..kg..age)
        Spawner.SpawnPet(name, tonumber(kg), tonumber(age))
	end
})

DupeTab:Button({
    Title = "Refresh Pets",
    Desc = "This checks which pets you have in your inventory",
    Locked = false,
    Callback = function()
	myPets = {}

	for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if item.Name:find("Age") then
			table.insert(myPets, item.Name)
		end	
	end

	dupeDropDown:Refresh(myPets)

	end
})

-- Seed Spawner Tab
local SeedTab = Window:Tab({
    Title = "Seed Spawner",
    Icon = "bean",
    Locked = false,
})

local seedName = "Candy Blossom"

SeedTab:Input({
    Title = "Seed Spawner",
    Desc = "Enter the name of the seed you want to spawn",
    Value = seedName,
    InputIcon = "lollipop",
    Type = "Input",
    Placeholder = "Enter seed: ",
    Callback = function(input)
		seedName = input
    end
})

SeedTab:Button({
    Title = "Spawn Seed",
    Desc = "This button spawns the selected seed",
    Locked = false,
    Callback = function()
		Spawner.SpawnSeed(seedName)
    end
})

-- Item Stealer Tab
local ItemTab = Window:Tab({
    Title = "Item Stealer",
    Icon = "user-round",
    Locked = false,
})

-- Get all players except yourself

local selectedPlayer = playerNames[1]

local itemList = "Select a player"

local Paragraph = ItemTab:Paragraph({
    Title = "View Inventory:",
    Desc = itemList,
    Color = "Red",
    Locked = false,
})

-- Player selector
local playerSelectorDropDown = ItemTab:Dropdown({
    Title = "Select Player: ",
    Values = playerNames,
    Value = selectedPlayer,
    Callback = function(option)
		selectedPlayer = option
		local player = game.Players:FindFirstChild(option)
    	if not player then return end

		itemList = ""

		for i, item in pairs(player.Backpack:GetChildren()) do
			if item:IsA("Tool") then
				itemList = itemList .. i .. ". " .. item.Name .. "\n"
			end
		end

		Paragraph:SetDesc(itemList)
	end
})

ItemTab:Button({
    Title = "Refresh Players",
    Desc = "This updates which players are in the game",
    Locked = false,
    Callback = function()
		UpdatePlayers()

		playerSelectorDropDown:Refresh(playerNames)
    end
})

local debounce = false

ItemTab:Button({
    Title = "Steal All Items",
    Desc = "Steals the items from the selected player",
    Locked = false,
    Callback = function()
		if debounce == true then
            WindUI:Popup({
                Title = "We are already stealing. Please wait!",
                Icon = "info",
                Content = "Please give us a moment. We are already stealing his pets.",
                Buttons = {
                    {
                        Title = "Cancel",
                        Callback = function() end,
                        Variant = "Tertiary",
                    },
                    {
                        Title = "Continue",
                        Icon = "arrow-right",
                        Callback = function() end,
                        Variant = "Primary",
                    }
                }
            })
			return
		end

		debounce = true
		
        local player = game.Players:FindFirstChild(selectedPlayer)
		if not player then
			print("Player not found!")
			return
		end

		WindUI:Popup({
        Title = "Stealing items...",
        Icon = "info",
        Content = "We are currently stealing the selected player's items",
        Buttons = {
            {
                Title = "Cancel",
                Callback = function() end,
                Variant = "Tertiary",
            },
            {
                Title = "Continue",
                Icon = "arrow-right",
                Callback = function() end,
                Variant = "Primary",
            }
        }
    })

		for _, item in pairs(player.Backpack:GetChildren()) do
			if item:IsA("Tool") and not item.Name:find("Shovel") then
				local clonedItem = item:Clone()
				clonedItem.Parent = game.Players.LocalPlayer.Backpack
			end

			task.wait(.3)
		end

		debounce = false

        WindUI:Popup({
            Title = "Finished stealing pets!",
            Icon = "info",
            Content = "We are currently stealing the selected player's items",
            Buttons = {
                {
                    Title = "Cancel",
                    Callback = function() end,
                    Variant = "Tertiary",
                },
                {
                    Title = "Continue",
                    Icon = "arrow-right",
                    Callback = function() end,
                    Variant = "Primary",
                }
            }
        })

	end
})

-- Autofarm Tab
local ShopTab = Window:Tab({
	Title = "Shop",
	Icon = "store",
	Locked = false,
})

ShopTab:Section({
    Title = "Coming Soon...",
    TextXAlignment = "Center",
    TextSize = 17,
})

game.Players.PlayerAdded:Connect(function()
	UpdatePlayers()
	playerSelectorDropDown:Refresh(playerNames)
end)

game.Players.PlayerRemoving:Connect(function()
	UpdatePlayers()
	playerSelectorDropDown:Refresh(playerNames)
end)