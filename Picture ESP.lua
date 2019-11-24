--- GUI Stuff
local pos = gui.Reference("VISUALS", "Shared")
local enable = gui.Checkbox( pos, "msc_picture_esp_active", "Enable Picture ESP", 0)
local picture = gui.Combobox( pos, "msc_picture_esp_type", "Picture", "Nick Furry", "Elon Musk", "XaNe")


--- Variables
local x1, y1, x2, y2;
local imageLink = "https://pics.me.me/nick-furry-gag-priel8-nick-furys-true-form-44429196.png"
local imageData = http.Get(imageLink);
local imgRGBA, imgWidth, imgHeight = common.DecodePNG(imageData);
local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight)

--- Update Function for the button.
local function update()

    if picture:GetValue() == 0 then
        imageLink = "https://pics.me.me/nick-furry-gag-priel8-nick-furys-true-form-44429196.png"
    elseif picture:GetValue() == 1 then
        imageLink = "https://i.imgur.com/ZruIM1Z.jpg"
    else 
        imageLink = "https://i.ytimg.com/vi/hEDYqAAL_48/hqdefault.jpg"
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
local VERSION_NUMBER = "1.0.0"; --- This too
local version_check_done = false;
local update_downloaded = false;
local update_available = false;

callbacks.Register("Draw", function()
    if (update_available and not update_downloaded) then
            if (gui.GetValue("lua_allow_cfg") == false) then
                draw.Color(255, 0, 0, 255);
                draw.Text(0, 0, "[Picture ESP] An update is available, please enable Lua Allow Config and Lua Editing in the settings tab");
            else
                local new_version_content = http.Get(SCRIPT_FILE_ADDR);
                local old_script = file.Open(SCRIPT_FILE_NAME, "w");
                old_script:Write(new_version_content);
                old_script:Close();
                update_available = false;
                update_downloaded = true;
            end
        end

        if (update_downloaded) then
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Picture ESP] An update has automatically been downloaded, please reload the Picture ESP script");
            return;
        end

        if (not version_check_done) then
            if (gui.GetValue("lua_allow_http") == false) then
                draw.Color(255, 0, 0, 255);
                draw.Text(0, 0, "[Picture ESP] Please enable Lua HTTP Connections in your settings tab to use this script");
                return;
            end

            version_check_done = true;
            local version = http.Get(VERSION_FILE_ADDR);
            if (version ~= VERSION_NUMBER) then
                update_available = true;
            end
    end
end);