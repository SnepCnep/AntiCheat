-- [//[ Update Checker ]\\] --
local getCurrentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or "1.0.0"
local githubUrl = "https://raw.githubusercontent.com/SnepCnep/FiveM-anticheat/main/FiveM-anticheat/src/data/version.json"

CreateThread(function()
    
    PerformHttpRequest(githubUrl, function(code, response, headers)
        if code == 200 and response then
            local req = json.decode(response)
            print("\27[1;33m--------------------------------------------------------------------------")
            if getCurrentVersion ~= req.version then
                print("\27[1;34mSC-AntiCheat: \27[1;36mThere is a new version available!")
                print("\27[1;36mPlease update to version: \27[1;37m" .. (req.version or "Unknown"))
            else
                print("\27[1;34mSC-AntiCheat: \27[1;36mYou are running the latest version!")
            end
            print("\27[1;33m--------------------------------------------------------------------------")
            print("\27[1;32m-> Author  : \27[1;37m SnepCnep")
            print("\27[1;32m-> Version : \27[1;37m " .. getCurrentVersion)
            print("\27[1;32m-> Status  : \27[1;37m ".. (req.status or "Unknown"))
            print("\27[1;33m--------------------------------------------------------------------------")
            if GetCurrentResourceName() == "anticheat" or GetCurrentResourceName() == "FiveM-AntiCheat" then
                print("\27[1;31m-> Please change the resource name instead of using the default name!^7")
            end
        else
            print("^4 Failed to check for updates. Error code: " .. code .. "^7")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
    
end)