module("luci.controller.wifibusy", package.seeall)

function index()
	entry({"admin", "status", "realtime", "wifibusy"}, template("admin_status/wifibusy"), "Wifi Busy", 5).leaf = true
	entry({"admin", "status", "realtime", "wifibusy_status"}, call("action_wifibusy")).leaf = true
end

function action_wifibusy(iface)
	luci.http.prepare_content("application/json")

	if(iface:match("^wlan%d$")) then
		local bwc = io.open("/tmp/lib/wifibusy/" .. iface)
		if(bwc ~= nil) then
			while true do
				local ln = bwc:read("*l")
				if not ln then break end
				luci.http.write(ln)
			end

			bwc:close()
		end
	end
end

