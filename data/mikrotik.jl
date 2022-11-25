using JSON
FILE = "/home/colinxs/public/data/ipv6.json"
for (k,v) in JSON.parsefile(FILE)
    if (v["Source"] || v["Destination"]) && !v["Global"]
        for a in v["Addresses"]
            println("""/ipv6 firewall address-list add address=$a comment="defconf: $(join(v["RFC"], ", ")) - $k" list=NoForward_IPv4""")
        end
    elseif !(v["Source"] || v["Destination"])
        for a in v["Addresses"]
            println("""/ipv6 firewall address-list add address=$a comment="defconf: $(join(v["RFC"], ", ")) - $k" list=Bogon_IPv4""")
        end
    end
end
