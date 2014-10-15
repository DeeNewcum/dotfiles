// ========================================================================================
// ==  At work, certain websites are blocked.  I sometimes open an SSH tunnel via:       ==
// ==            ssh -D 8080 myself@myserver                                             ==
// ==  but if I send everything through that tunnel, web browsing is definitely slower.  ==
// ==  This script sends ONLY the parts of the web that are blocked through the tunnel,  ==
// ==  leaving the unblocked URLs to go to the faster route.                             ==
// ==                                                                                    ==
// ==  It also automatically falls back, so you if I'm logged in from home, it notices   ==
// ==  the proxy is down, it will get everything directly.                               ==
// ========================================================================================


// documentation:
//      http://findproxyforurl.com/pac-functions/

// ways to debug this script:
//      inotifywait -m autoproxy.pac  -e open
//

    // alert("hhhhey");

function FindProxyForURL(url, host) {

    if (dnsDomainIs(host, ".reddit.com")) {
        // Subreddits that are blocked at work.
        if (shExpMatch(url.toLowerCase(), "*reddit.com/r/polyamory*")
         || shExpMatch(url.toLowerCase(), "*reddit.com/r/bisexual*")
         || shExpMatch(url.toLowerCase(), "*reddit.com/r/sexpositive*")
        ) {
            return "SOCKS localhost:8080; DIRECT";
                    // Use the proxy if it's available;  otherwise try to access it directly.
        }
    }
    return "DIRECT";
}
