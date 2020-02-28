--- GUI Stuff
local pos = gui.Reference("VISUALS", "Overlay", "Enemy")
local enable = gui.Checkbox( pos, "esp.picture.enemy.active", "Enable Picture ESP", 0)
local picture = gui.Combobox( pos, "esp.picture.enemy.type", "Picture", "Nick Furry", "Actual Nick Furry", "Elon Musk", "Elon Musk 2" ,"XaNe", "Hot Girl", "Rias Gremory", "Donald Trump", "Custom")
local customType = gui.Combobox( pos, "esp.picture.enemy.customtype", "Image Hoster", "Imgur")
local customLink = gui.Editbox( pos, "esp.picture.enemy.customlink", "Custom Link")

--- Variables
local x1, y1, x2, y2;
local imageLink = "https://i.imgur.com/a3Js0C3.jpg"
local imageData = http.Get(imageLink);
local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(imageData);
local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight)

--- Update Function for the button.
local function update()

    if picture:GetValue() == 0 then
        imageLink = "https://pics.me.me/nick-furry-gag-priel8-nick-furys-true-form-44429196.png"
    elseif picture:GetValue() == 1 then
        imageLink = "https://i.imgur.com/TW3Crg4.png"
    elseif picture:GetValue() == 2 then
        imageLink = "https://i.imgur.com/ZruIM1Z.jpg"
    elseif picture:GetValue() == 3 then
        imageLink = "https://i.imgur.com/bmM6gUP.png"
    elseif picture:GetValue() == 4 then
        imageLink = "https://i.ytimg.com/vi/hEDYqAAL_48/hqdefault.jpg"
    elseif picture:GetValue() == 5 then
        imageLink = "https://images.vectorhq.com/images/previews/dfa/girl-with-big-ass-psd-407902.png"
    elseif picture:GetValue() == 6 then
        imageLink = "https://i.imgur.com/O5mew0e.png"
    elseif picture:GetValue() == 7 then
        imageLink = "https://purepng.com/public/uploads/large/purepng.com-donald-trumpdonald-trumpdonaldtrumppresidentpoliticsbusinessmanborn-in-queens-1701528042636xgni1.png"
    else
        if customType:GetValue() == 0 then
            imageLink = "https://i.imgur.com/" .. customLink:GetValue()
        end
    end

    if not imageLink then
        return
    end

    imageData = http.Get(imageLink);

    if string.sub(imageLink, -3) == "jpg" then
        imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(imageData);
    else
        imgRGBA, imgWidth, imgHeight = common.DecodePNG(imageData);
    end

    texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight)
end

--- Lonely update button
local updatebutton = gui.Button(pos, "Update ESP", update)

--- The draw code (Wow, really not that hard.)
callbacks.Register("DrawESP", function(builder)

    if enable:GetValue() then
        x1, y1, x2, y2 = builder:GetRect()
        draw.SetTexture(texture)
        draw.FilledRect(x1, y1, x2, y2)
    end
    
end)

--- Auto updater by Shady#0001

--- Auto updater variables
local SCRIPT_FILE_NAME = GetScriptName();
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/superyor/pictureESP/master/Picture%20ESP.lua";
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/superyor/pictureESP/master/version.txt"; --- in case of update i need to update this. (Note by superyu'#7167 "so i don't forget it.")
local VERSION_NUMBER = "1.3"; --- This too
local version_check_done = false;
local update_downloaded = false;
local update_available = false;

--- Auto Updater GUI Stuff
local PICTUREESP_UPDATER_TAB = gui.Tab(gui.Reference("Settings"), "PictureESP.updater.tab", "PictureESP Autoupdater")
local PICTUREESP_UPDATER_GROUP = gui.Groupbox(PICTUREESP_UPDATER_TAB, "Auto Updater for PictureESP™ | v" .. VERSION_NUMBER, 15, 15, 600, 600)
local PICTUREESP_UPDATER_TEXT = gui.Text(PICTUREESP_UPDATER_GROUP, "")

--- Auto updater by ShadyRetard/Shady#0001
local function handleUpdates()

    if (update_available and not update_downloaded) then
        PICTUREESP_UPDATER_TEXT:SetText("Update is getting downloaded.")
        local new_version_content = http.Get(SCRIPT_FILE_ADDR);
        local old_script = file.Open(SCRIPT_FILE_NAME, "w");
        old_script:Write(new_version_content);
        old_script:Close();
        update_available = false;
        update_downloaded = true;
    end

    if (update_downloaded) then
        PICTUREESP_UPDATER_TEXT:SetText("Update available, please reload the script.")
        return;
    end

    if (not version_check_done) then
        version_check_done = true;
        local version = http.Get(VERSION_FILE_ADDR);
        if (version ~= VERSION_NUMBER) then
            update_available = true;
        end
        PICTUREESP_UPDATER_TEXT:SetText("Your client is up to date. Current Version: v" .. VERSION_NUMBER)
    end
end

callbacks.Register("Draw", handleUpdates)
