----------------------------------------------------------------------
-- Create a GRAY image of the layer
----------------------------------------------------------------------


function Lowest(r,g,b)
        --Returns the lowest value of the three color values
        return math.min(math.min(r,g),b)
end

function Middle(r,g,b)
        -- Returns the middle value of the three color values
        return math.min(math.max(r,g),b)
end

function Highest(r,g,b)
        --Returns the highest value of the three color values
        return math.max(math.max(r,g),b)
end

function GetOption(cel)
        --Chooses different options depending on user input
        local dlg = Dialog("Grayscale")
        dlg
                :label{text="Choose the light intensity"}
                :newrow()
                :button{text="Lowest",onclick=function() Grayscale(cel,"l") end}
                :button{text="Middle",onclick=function() Grayscale(cel, "m") end}
                :button{text="Highest",onclick=function() Grayscale(cel,"h")end}
                :show{wait=false}
end


-- The best way to modify a cel image is to clone it (the new cloned
-- image will be an independent image, without undo information).
-- Then we can change the cel image generating only one undoable
-- action.
function Grayscale(cel,choice)
        -- Function to make every pixel grayscale
        -- depening on user input chooses the highest, lowest or middle color intensity
                math.randomseed(os.time())
                local img = cel.image:clone()
        
                  local rgba = app.pixelColor.rgba
                  local red = app.pixelColor.rgbaR
                  local green = app.pixelColor.rgbaG
                  local blue = app.pixelColor.rgbaB
                  local rgbaA = app.pixelColor.rgbaA
                  for pixel in img:pixels() do
                        r=red(pixel())
                        g=green(pixel())
                        b=blue(pixel())
                        if choice=="l" then
                                gray = Lowest(r,g,b)
                        end
                        if choice=="m" then
                                gray = Middle(r,g,b)
                        end
                        if choice=="h" then
                                gray = Highest(r,g,b)
                        end
                      pixel(rgba(gray,
                                gray,
                                gray, rgbaA(pixel())))
                  end
        
        -- Here we change the cel image, this generates one undoable action
                  cel.image = img
        
        -- Here we redraw the screen to show the modified pixels, in a future
        -- this shouldn't be necessary, but just in case...
                  app.refresh()
end


function main()
        if app.apiVersion < 1 then
           return app.alert("This script requires Aseprite v1.2.10-beta3")
        end

        local cel = app.activeCel
        if not cel then
           return app.alert("There is no active image")
        else
                GetOption(cel)
        end


end


main()
