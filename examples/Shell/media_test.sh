#!/bin/bash
shell_version="1.2.2";
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
Disney_Auth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
Disney_Header="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
HuluUS_Content='{"device_identifier":"2B3BACF5B121715649E5D667D863612E:403a","deejay_device_id":190,"version":1,"all_cdn":true,"content_eab_id":"EAB::1ed6c0d7-2bc0-4b8a-8639-74fa7361a5d8::61217916::135257891","region":"US","xlink_support":false,"device_ad_id":"CCCF1C80-2D18-E857-2F1F-A1E9C9B40F82","limit_ad_tracking":false,"ignore_kids_block":false,"language":"en","guid":"2B3BACF5B121715649E5D667D863612E","rv":194750,"kv":451178,"unencrypted":true,"include_t2_revenue_beacon":"1","cp_session_id":"9258D295-FEF1-9A3E-2C4C-898C18AF2EB1","interface_version":"1.9.0","network_mode":"wifi","play_intent":"resume","playback":{"version":2,"video":{"codecs":{"values":[{"type":"H264","width":1920,"height":1080,"framerate":60,"level":"4.2","profile":"HIGH"}],"selection_mode":"ONE"}},"audio":{"codecs":{"values":[{"type":"AAC"}],"selection_mode":"ONE"}},"drm":{"values":[{"type":"WIDEVINE","version":"MODULAR","security_level":"L3"},{"type":"PLAYREADY","version":"V2","security_level":"SL2000"}],"selection_mode":"ALL"},"manifest":{"type":"DASH","https":true,"multiple_cdns":true,"patch_updates":true,"hulu_types":true,"live_dai":true,"multiple_periods":false,"xlink":false,"secondary_audio":true,"live_fragment_delay":3},"segments":{"values":[{"type":"FMP4","encryption":{"mode":"CENC","type":"CENC"},"https":true}],"selection_mode":"ONE"}}}';
HuluUS_Cookie="_hulu_assignments=eyJ2MSI6W119; bm_mi=35D6F5FDB843EBDBB36F2563EA2F905E~mduMYozDcKPxgnTnPbzGFdcOP7sL5laOvrw84v4azoN9hvFV/DVFJN+l5W4y1J0bThCyGjkKxzcmJMdwkhJnwQUsxQQvgoMRNvcER2ewPlvT/3bmwC+auTWnyDkPIIMpDKHNtBMXP+oyVHwZPqLmOmQoPmpZFA8roNv9r/Jveo+ib+lkx3li9clr7lbSmlyePLwuV5mgsNbVR6j8ySH99U42Mqaym3u4oX/Az+5viuECqFnU9GjZ5vyG4HueFdvf/BmVfvWGJqlfdCvJIb+U9A==; _h_csrf_id=aa68dcc9ba46d7cec1855834beb2b6ac2d67bf9fb321e6b5c8e9da75b4fb91ff; ak_bmsc=5F4C29E6C5485141C7E6B1148B6064E7~000000000000000000000000000000~YAAQF84zuIqZ6ep5AQAA7y4cNAz08B6KWT5/8gfBXXngCOxzgadCnkxuJ29Q3LiXizDsKmOB8p934pKVKGkL2wR7bGWH3erDn+2bPhlhenwPNr+eG42SIEQ47iieXR4Oaej2nUzgtlj9HXVGdDJyESv3gOI6Xcu1Svzq4ilosGur2NcgzmWX/ulrhWlTWROD06otoWBk+/2r14XHZgTguBHTriJSyP+8MvtkJM3m/ho332McuA8ldX+QLfFrT/JcUtXzOpjM6/FhYFOr4CmV5s1ILDKfInOmvlkV9YBNRHEpAEuNV3lBP4nuUvmlBYl1pywWakotbdGzFV+UziHf7uJgTuoTU9nHUTM9rewlaxecad0oIyJHYdRDL4oUBeek2L9RL2sZLxXE2iVqnyL3HXDMem4gq+1PNQ+EUFLi9mY=; _hulu_pgid=8396803; _hulu_uid=168956133; _hulu_e_id=CR7dX_MmCn_5Kf-m_PKR4g; _hulu_bluekai_hashed_uid=77d8272a48433b34232a5e018423d810; _p_edit_token=Fg4o-Wx5CztBgorxmtv3SQ; _hulu_dt=3qZnlwE6aqYevqV4EyyjU7HOcJ8-6h_O%2FeEQnz8lu2hylIv5Gg--H%2Ft7tif1%2FRYPgAiy_WuOpoK5_yjFMP3DVNhI%2FosTJcX6IpcpLvxcczINNGo1YUYYH2_P3Z3Y73TOnzogcP7y0uXHGLEfC_Yp6lqXa0M_j0VnE%2Fbm1OHSDiRRi9p3YiOl4zw0xeeBDO4iUPFhqT1OTKA4npSkU00aGWMj2KIugmSJCK8hWEWQfbYSRkat1maUuM8WJ70t%2F1PHoVuK30Y9K5CxdZMlhbxP49N4n196Wa4j%2FWDIMJ7gsgkEhPVF5tvV5xLZ56%2Fa%2FzDOrHh1xZLngL_Q2DJt36CCSa%2FpyWNMrO3Hi9oO0U1w7yZT8Q95Q9TEUEVxd2llJQg8eRyKIXdQL7XizNer6BX0IZ84hXB2dzwn3KVVp49cOgBMl3AsZeQplK1YeCJGM1a0HoFtYqGxH3xzjvOUGAdg5W3frMkQedRwVYpysGqZGBOsFQ0Cl_sZGlmk5UEofBh%2Fsr9YOoH5KOyFT0R6Iq7n0cF1cCnkV_aA8al7a3ahuCQc48NFKqh5v9DkajJdBbH82VK851%2F0Hj3sc9s54LN98ofQZWnvln%2FMcooXfqQPUr8maUTwYykYqIpnlSpeUVkUgYnQZmu4QKmhoZ_R5pamd0W0mT8MZLNxBYm8ShjS%2FZciaSU1hI9%2F4FJu1dgEDOfquvG6XROPrw9QPIIpyPuhXsc0bz2VPHEJ9rgcSwSnIslsW_aFZOfD_7tA6P88YmDxDRWcmfCWPyT108%2FJPbvrkOAEG_v%2FXIQWKTMCzYJrk5tty7MfYT8khkY5YuJwfvjstiTRYtuQUjlu3l_yErmfJnEyNYtlTPqpH7jN3H6OFsWtZUVMNN3l6TX4imKSZInzCBwxMWI5qRdbUTEGXHBAonE08GALMfk-; XSRF-TOKEN=a24fd2ec-8632-49b1-a998-4785a8082804; _hulu_session=0i7960bmMkeCewflAevUkVrv1Zg-hTnsUnywh03JxBkx0diffw--4Fg3LER0t0f211ZFa%2F8EG0IVK3REieWnY4_neDyxsS1qQU_lJv8fWfPQurddXDEvIxiFJN698lsfYDkJeP8I9lz17zrzbbYXOjYcjF_%2FG0Yd8yC_ThifCKXP8fgzesXEukW25VoXr83JMa59NwMK9F7o_B92SU8kNBWftLrWSFoy9B9GMEf40R5gFixS9yUgItvMHmEq6JP6N2cOZhl9MDMETmsOYCA3kW9OvUqcrTlu3daklnpksIi%2Fwu3f7HMTc%2FqCkHptW_Q6R98mC%2F68A6WZVhC9lQmvgfhQ%2FLbFkkkokqMxhoRzO_5JckaLlFHsF1udOFTu17BlUrYGsAZx3SvPfnDVhsaeyu07SmRtr0yEASsDqdI5Zsy1ov_qqzb23LJcKDVHjoYXHbLhty2GX3fL6q92xtfVXfwmo9V%2FsY1i6rhaBEVrdZcamFsufYt8qKHe6CklB8aX_Yvon34RFPS7BV0S4H%2FqENXDGhBOFun2yLShlDFU3b7wFqVpnqIF%2FxS85xa2ml75aohHOFmMADKrpHJnekK57qqi0ZxBNJs4t7_QLRCfU6pzg9ohmj_2bJ1oCWD9xA0pUV5CT15UWsS4%2FgYzxr821QQuHo2krBkAJaGVxXNVFMx4%2FAgjIat_swZZfanojuxgBVoQyCt06JFZmG1eCk4PgkK%2Fl6Q1y347haNQVA49O0Qa1aQvCQtxF5lSmjT_8Fv6d_ToiuM6DzJYEovonvWMN_AiKH3olIHJgeh5csClKjyz7MHGPy91vroU%2FWjnRfIT2m5YI2SUrBbnUQYXsOVATRL%2Fda98BA29F7H3C5YCVBvEg6jPfXSLSR1y509GoyAFIOTIHixBVbyl8I1tbILNmr3NiYnnbpRvfylATsz_zy3kJZ_01HfB0WE5V%2F0lz9_2tOqzcK8CW5v%2FxD3o%2F75FA%2F6lFK2QT8E-; _hulu_pid=168956133; _hulu_pname=Hayden; _hulu_is_p_kids=0; guid=81F1FEC9945F68CD681F45315ADB0096; AMCVS_0A19F13A598372E90A495D62%40AdobeOrg=1; AMCV_0A19F13A598372E90A495D62%40AdobeOrg=-408604571%7CMCIDTS%7C18801%7CMCMID%7C41103232120510992910533052126393276069%7CMCAID%7CNONE%7CMCOPTOUT-1624379254s%7CNONE%7CvVersion%7C4.6.0; _hulu_metrics_context_v1_=%7B%22cookie_session_guid%22%3A%22445360c897752737afb5c6a53548f3a7%22%2C%22referrer_url%22%3A%22%22%2C%22curr_page_uri%22%3A%22app%3Awatch%22%2C%22primary_ref_page_uri%22%3A%22urn%3Ahulu%3Ahub%3Ahome%22%2C%22secondary_ref_page_uri%22%3A%22www.hulu.com%2Fwelcome%22%2C%22curr_page_type%22%3A%22watch%22%2C%22primary_ref_page_type%22%3A%22home%22%2C%22secondary_ref_page_type%22%3A%22landing%22%2C%22secondary_ref_click%22%3Anull%2C%22primary_ref_click%22%3A%22The%20Future%20Diary%22%2C%22primary_ref_collection%22%3A%22282%22%2C%22secondary_ref_collection%22%3Anull%2C%22primary_ref_collection_source%22%3A%22heimdall%22%2C%22secondary_ref_collection_source%22%3Anull%2C%22ref_collection_position%22%3A0%7D; metrics_tracker_session_manager=%7B%22session_id%22%3A%2281F1FEC9945F68CD681F45315ADB0096-3ce0d9b1-fed1-4da7-907f-2b4e715c3c82%22%2C%22creation_time%22%3A1624371865113%2C%22visit_count%22%3A1%2C%22session_seq%22%3A36%2C%22idle_time%22%3A1624372056067%7D; bm_sv=78952BDC542C106C5EF42E1FB31E33F4~s4ubemiuyh97XfkOxWkvvouJJFqFbnNLNUDvA8lw5npJJr8J+KeOM5fLCjgrrnZOTqo0sYedZtDYrPIz067XEP1QDQ3TTvrg4PxZ2SmTUPrY5ydoJJIUIsvaGzK+89tqZwLC9LZQa5wueZClFqVDlA==";


Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";


clear;
echo -e "###############################################################";
echo -e "#  流解锁测试 StreamUnlockTest";
echo -e "#  当前版本: ${Font_SkyBlue}v${shell_version}${Font_Suffix}";
echo -e "#  ${Font_Yellow}开源地址: https://github.com/LovelyHaochi/StreamUnlockTest${Font_Suffix}";
echo -e "###############################################################";
echo -e "#  国家代码对照表: ${Font_Yellow}http://www.loglogo.com/front/countryCode/${Font_Suffix}"
echo -e "#  测试时间: $(date)"
echo -e "###############################################################";

export LANG="en_US.UTF-8";
export LANGUAGE="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

function InstallJQ() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}正在安装依赖: epel-release${Font_Suffix}";
        yum install epel-release -y -q > /dev/null;
        echo -e "${Font_Green}正在安装依赖: jq${Font_Suffix}";
        yum install jq -y -q > /dev/null;
    elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}正在更新软件包列表...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}正在安装依赖: jq${Font_Suffix}";
        apt-get install jq -y > /dev/null;
    else
        echo -e "${Font_Red}请手动安装jq${Font_Suffix}";
        exit;
    fi
}

function InstallCurl() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}正在安装依赖: curl${Font_Suffix}";
        yum install curl -y > /dev/null;
    elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}正在更新软件包列表...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}正在安装依赖: curl${Font_Suffix}";
        apt-get install curl -y > /dev/null;
    else
        echo -e "${Font_Red}请手动安装curl${Font_Suffix}";
        exit;
    fi
}

function PharseJSON() {
    # 使用方法: PharseJSON "要解析的原JSON文本" "要解析的键值"
    # Example: PharseJSON ""Value":"123456"" "Value" [返回结果: 123456]
    echo -n $1 | jq -r .$2;
}

function GameTest_Steam(){
    echo -n -e " Steam:\t\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 https://store.steampowered.com/app/761830 2>&1 | grep priceCurrency | cut -d '"' -f4);
    
    if [ ! -n "$result" ]; then
        echo -n -e "\r Steam:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    else
        echo -n -e "\r Steam:\t\t\t\t\t${Font_Green}Yes(Currency: ${result})${Font_Suffix}\n";
    fi
}

function MediaUnlockTest_ABC() {
    echo -n -e " ABC:\t\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl -${1} --max-time 10 -fsSL -H 'Content-Type: application/x-www-form-urlencoded' -X POST -d 'type=gt&brand=001&device=001' https://prod.gatekeeper.us-abc.symphony.edgedatg.go.com/vp2/ws/utils/2020/geo/video/geolocation.json 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
		local isAllowed=$(PharseJSON "${result}" "user.allowed");
        if [ "${isAllowed}" = "true" ]; then
			local Country=$(PharseJSON "${result}" "user.country" | tr 'a-z' 'A-Z')
            echo -n -e "\r ABC:\t\t\t\t\t${Font_Green}Yes(Country: ${Country})${Font_Suffix}\n";
        else
            echo -n -e "\r ABC:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        echo -n -e "\r ABC:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

function MediaUnlockTest_DAZN() {
    echo -n -e " DAZN:\t\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl -${1} --max-time 10 -fsSL -H 'Content-Type: application/json' -X POST -d '{"LandingPageKey": "generic", "Languages": "zh-TW,zh,en-US,en","Platform": "web", "Version": "2"}' https://startup.core.indazn.com/misl/v5/Startup 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
		local isAllowed=$(PharseJSON "${result}" "Region.isAllowed");
        if [[ "${isAllowed}" == "true" ]]; then
			local Country=$(PharseJSON "${result}" "Region.Country" | tr 'a-z' 'A-Z')
            echo -n -e "\r DAZN:\t\t\t\t\t${Font_Green}Yes(Region: ${Country})${Font_Suffix}\n";
        else
            echo -n -e "\r DAZN:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        echo -n -e "\r DAZN:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

function MediaUnlockTest_HBONow() {
    echo -n -e " HBO Now:\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 --write-out "%{url_effective}\n" --output /dev/null https://play.hbonow.com/ 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
        if [ "${result}" = "https://play.hbonow.com" ] || [ "${result}" = "https://play.hbonow.com/" ]; then
            echo -n -e "\r HBO Now:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        elif [ "${result}" = "http://hbogeo.cust.footprint.net/hbonow/geo.html" ] || [ "${result}" = "http://geocust.hbonow.com/hbonow/geo.html" ]; then
            echo -n -e "\r HBO Now:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        else
            echo -n -e "\r HBO Now:\t\t\t\t${Font_Yellow}Failed${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        echo -n -e "\r HBO Now:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

function MediaUnlockTest_HBOMax() {
    echo -n -e " HBO Max:\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 "https://www.hbomax.com" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
        if [[ "${result}" == *"Not in service area"* ]]; then
            echo -n -e "\r HBO Max:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        else
            echo -n -e "\r HBO Max:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        echo -n -e "\r HBO Max:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

# 流媒体解锁测试-动画疯
function MediaUnlockTest_BahamutAnime() {
    echo -n -e " Bahamut Anime:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --user-agent "${UA_Browser}" --max-time 10 -fsSL 'https://ani.gamer.com.tw/ajax/token.php?adID=89422&sn=14667' 2>&1);
    if [[ "$tmpresult" == "curl"* ]]; then
        echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        return;
    fi
    local result="$(PharseJSON "$tmpresult" "animeSn")";
    if [ "$result" != "null" ]; then
        resultverify="$(echo $result | grep -oE '[0-9]{1,}')";
        if [ "$?" = "0" ]; then
            echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        else
            echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        local result="$(PharseJSON "$tmpresult" "error.code")";
        if [ "$result" != "null" ]; then
            resultverify="$(echo $result | grep -oE '[0-9]{1,}')";
            if [ "$?" = "0" ]; then
                echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
            else
                echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
            fi
        else
            echo -n -e "\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    fi
}

# 流媒体解锁测试-哔哩哔哩大陆限定
function MediaUnlockTest_BilibiliChinaMainland() {
    echo -n -e " BiliBili China Mainland Only:\t\t->\c";
    local randsession="$(cat /dev/urandom | head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 "https://api.bilibili.com/pgc/player/web/playurl?avid=82846771&qn=0&type=&otype=json&ep_id=307247&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                echo -n -e "\r BiliBili China Mainland Only:\t\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                echo -n -e "\r BiliBili China Mainland Only:\t\t${Font_Red}No${Font_Suffix}\n";
            else
                echo -n -e "\r BiliBili China Mainland Only:\t\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            echo -n -e "\r BiliBili China Mainland Only:\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        echo -n -e "\r BiliBili China Mainland Only:\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

# 流媒体解锁测试-哔哩哔哩港澳台限定
function MediaUnlockTest_BilibiliHKMCTW() {
    echo -n -e " BiliBili Hongkong/Macau/Taiwan:\t->\c";
    local randsession="$(cat /dev/urandom | head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 "https://api.bilibili.com/pgc/player/web/playurl?avid=18281381&cid=29892777&qn=0&type=&otype=json&ep_id=183799&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                echo -n -e "\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                echo -n -e "\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}No${Font_Suffix}\n";
            else
                echo -n -e "\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            echo -n -e "\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        echo -n -e "\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

# 流媒体解锁测试-哔哩哔哩台湾限定
function MediaUnlockTest_BilibiliTW() {
    echo -n -e " Bilibili Taiwan Only:\t\t\t->\c";
    local randsession="$(cat /dev/urandom | head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 "https://api.bilibili.com/pgc/player/web/playurl?avid=50762638&cid=100279344&qn=0&type=&otype=json&ep_id=268176&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                echo -n -e "\r Bilibili Taiwan Only:\t\t\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                echo -n -e "\r Bilibili Taiwan Only:\t\t\t${Font_Red}No${Font_Suffix}\n";
            else
                echo -n -e "\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            echo -n -e "\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        echo -n -e "\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
}

# 流媒体解锁测试-Abema.TV
#
function MediaUnlockTest_AbemaTV() {
    echo -n -e " Abema.TV:\t\t\t\t->\c";
    #
    local tempresult=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --write-out %{http_code} --max-time 10 "https://api.abema.io/v1/ip/check?device=android" 2>&1);
    if [[ "$tempresult" == "000" ]]; then
        echo -n -e "\r Abema.TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
    local result=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --max-time 10 "https://api.abema.io/v1/ip/check?device=android" 2>&1);
	local result=$(PharseJSON "${result}" "isoCountryCode")
	if [ -n "$result" ]; then
		if [[ "$result" == "JP" ]]
			then
				echo -n -e "\r Abema.TV:\t\t\t\t${Font_Green}Yes(Region: JP)${Font_Suffix}\n"
			else
				echo -n -e "\r Abema.TV:\t\t\t\t${Font_Yellow}Only overseas${Font_Suffix}\n"
		fi
	else
        echo -n -e "\r Abema.TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
    fi
}

function GameTest_PCRJP() {
    echo -n -e " Princess Connect Re:Dive Japan:\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --write-out %{http_code} --output /dev/null --max-time 10 https://api-priconne-redive.cygames.jp/);
    if [ "$result" = "000" ]; then
        echo -n -e "\r Princess Connect Re:Dive Japan:\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        elif [ "$result" = "404" ]; then
        echo -n -e "\r Princess Connect Re:Dive Japan:\t${Font_Green}Yes${Font_Suffix}\n";
        elif [ "$result" = "403" ]; then
        echo -n -e "\r Princess Connect Re:Dive Japan:\t${Font_Red}No${Font_Suffix}\n";
    else
        echo -n -e "\r Princess Connect Re:Dive Japan:\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n";
    fi
}

function GameTest_UMAJP() {
    echo -n -e " Pretty Derby Japan:\t\t\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --write-out %{http_code} --output /dev/null --max-time 3 https://api-umamusume.cygames.jp/);
    if [ "$result" = "000" ]; then
        echo -n -e "\r Pretty Derby Japan:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
    elif [ "$result" = "404" ]; then
        echo -n -e "\r Pretty Derby Japan:\t\t\t${Font_Green}Yes${Font_Suffix}\n"
	elif [ "$result" = "403" ]; then
        echo -n -e "\r Pretty Derby Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    else
        echo -n -e "\r Pretty Derby Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    fi
}

function GameTest_Kancolle() {
    echo -n -e " Kancolle Japan:\t\t\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --write-out %{http_code} --output /dev/null --max-time 10 http://203.104.209.7/kcscontents/);
    if [ "$result" = "000" ]; then
        echo -n -e "\r Kancolle Japan:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        elif [ "$result" = "200" ]; then
        echo -n -e "\r Kancolle Japan:\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        elif [ "$result" = "403" ]; then
        echo -n -e "\r Kancolle Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    else
        echo -n -e "\r Kancolle Japan:\t\t\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n"
    fi
}

function MediaUnlockTest_BBCiPLAYER() {
    echo -n -e " BBC iPLAYER:\t\t\t\t->\c";
    local tmpresult=$(curl --user-agent "${UA_Browser}" -${1} -fsL --max-time 10 https://open.live.bbc.co.uk/mediaselector/6/select/version/2.0/mediaset/pc/vpid/bbc_one_london/format/json/jsfunc/JS_callbacks0)
    if [ "${tmpresult}" = "000" ]; then
        echo -n -e "\r BBC iPLAYER:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return
		
	fi
	
	if [ -n "$tmpresult" ]; then
		result=$(echo $tmpresult | grep 'geolocation')	
		if [ -n "$result" ]; then
			echo -n -e "\r BBC iPLAYER:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		else
			echo -n -e "\r BBC iPLAYER:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		fi
	else
		echo -n -e "\r BBC iPLAYER:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
	fi
}

function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix:\t\t\t\t->\c";
    local result=$(curl -${1} --user-agent "${UA_Browser}" -sSL "https://www.netflix.com/" 2>&1);
    if [ "$result" == "Not Available" ];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Unsupport${Font_Suffix}\n";
        return;
    fi
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        return;
    fi
    
    local result=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80018499" 2>&1);
    if [[ "$result" == *"page-404"* ]] || [[ "$result" == *"NSEZ-403"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        return;
    fi
    
    local result1=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143836" 2>&1);
    local result2=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80027042" 2>&1);
    local result3=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70140425" 2>&1);
    local result4=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70283261" 2>&1);
    local result5=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143860" 2>&1);
    local result6=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70202589" 2>&1);
    
    if [[ "$result1" == *"page-404"* ]] && [[ "$result2" == *"page-404"* ]] && [[ "$result3" == *"page-404"* ]] && [[ "$result4" == *"page-404"* ]] && [[ "$result5" == *"page-404"* ]] && [[ "$result6" == *"page-404"* ]];then
        echo -n -e "\r Netflix:\t\t\t\t${Font_Yellow}Only Homemade${Font_Suffix}\n";
        return;
    fi
    
    local region=$(tr [:lower:] [:upper:] <<< $(curl -${1} --user-agent "${UA_Browser}" -fs --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1));
    
    if [[ ! -n "$region" ]];then
        region="US";
    fi
    echo -n -e "\r Netflix:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n";
    return;
}

function MediaUnlockTest_DisneyPlus() {
    echo -n -e " DisneyPlus:\t\t\t\t->\c";
    local result=$(curl -${1} --user-agent "${UA_Browser}" -sSL "https://global.edge.bamgrid.com/token" 2>&1);
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
	local previewcheck=$(curl -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://disneyplus.com" | grep preview 2>&1);
	if [ -n "${previewcheck}" ];then
		echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi	
		
    
	local result=$(curl -${1} -s --user-agent "${UA_Browser}" -H "Content-Type: application/x-www-form-urlencoded" -H "${Disney_Header}" -d ''${Disney_Auth}'' -X POST  "https://global.edge.bamgrid.com/token" 2>&1)
	local access_token=$(PharseJSON "${result}" "access_token")

    if [[ "$access_token" == "null" ]]; then
		echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	region=$(curl -${1} -s https://www.disneyplus.com | grep 'region: ' | awk '{print $2}')
	if [ -n "$region" ]; then
		echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n"
		return;
	else
		local website=$(curl -${1} --user-agent "${UA_Browser}" -fs --write-out '%{redirect_url}\n' --output /dev/null "https://www.disneyplus.com")
		if [[ "${website}" == "https://disneyplus.disney.co.jp/" ]]; then
			echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: JP)${Font_Suffix}\n"
			return;
		else
			#local region=$(echo ${website} | cut -f4 -d '/' | tr 'a-z' 'A-Z')
			echo -n -e "\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: Unknow)${Font_Suffix}\n"
			return;
		fi
	fi
}

# Hulu JP
function MediaUnlockTest_HuluJP() {
    echo -n -e " Hulu Japan:\t\t\t\t->\c";
    local result=$(curl -${1} -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://id.hulu.jp" | grep login);
    
	if [ -n "$result" ]; then
		echo -n -e "\r Hulu Japan:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r Hulu Japan:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r Hulu Japan:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;

}

# MyTvSuper
function MediaUnlockTest_MyTVSuper() {
    echo -n -e " MyTVSuper:\t\t\t\t->\c";
    local result=$(curl -s -${1} --max-time 10 https://www.mytvsuper.com/iptest.php | grep HK);
    
	if [ -n "$result" ]; then
		echo -n -e "\r MyTVSuper:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r MyTVSuper:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r MyTVSuper:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;

}

# Now E
function MediaUnlockTest_NowE() {
    echo -n -e " Now E:\t\t\t\t\t->\c";
    local result=$(curl -${1} -s --max-time 10 -X POST -H "Content-Type: application/json" -d '{"contentId":"202105121370235","contentType":"Vod","pin":"","deviceId":"W-60b8d30a-9294-d251-617b-c12f9d0c","deviceType":"WEB"}' "https://webtvapi.nowe.com/16/1/getVodURL" 2>&1);
	local result=$(PharseJSON "${result}" "responseCode")
    
	if [[ "$result" == "SUCCESS" ]]; then
		echo -n -e "\r Now E:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    else
		echo -n -e "\r Now E:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r Now E:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;

}

# Viu.TV
function MediaUnlockTest_ViuTV() {
    echo -n -e " ViuTV:\t\t\t\t\t->\c";
    local result=$(curl -${1} -s --max-time 10 -X POST -H "Content-Type: application/json" -d '{"callerReferenceNo":"20210603233037","productId":"202009041154906","contentId":"202009041154906","contentType":"Vod","mode":"prod","PIN":"password","cookie":"3c2c4eafe3b0d644b8","deviceId":"U5f1bf2bd8ff2ee000","deviceType":"ANDROID_WEB","format":"HLS"}' "https://api.viu.now.com/p8/3/getVodURL" 2>&1);
	local result=$(PharseJSON "${result}" "responseCode")
    
	if [[ "$result" == "SUCCESS" ]]; then
		echo -n -e "\r ViuTV:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    else
		echo -n -e "\r ViuTV:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r ViuTV:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;

}

# U-NEXT
function MediaUnlockTest_unext() {
    echo -n -e " U-NEXT:\t\t\t\t->\c";
    local result=$(curl -${1} -s --max-time 10 "https://video-api.unext.jp/api/1/player?entity%5B%5D=playlist_url&episode_code=ED00148814&title_code=SID0028118&keyonly_flg=0&play_mode=caption&bitrate_low=1500" 2>&1);
	local result=$(PharseJSON "${result}" "data.entities_data.playlist_url.result_status")
	
    if [ -n "$result" ]; then 
		if [[ "$result" == "475" ]]; then
			echo -n -e "\r U-NEXT:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			return;
		elif [[ "$result" == "200" ]]; then
			echo -n -e "\r U-NEXT:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			return;	
		elif [[ "$result" == "467" ]]; then
			echo -n -e "\r U-NEXT:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			return;
		else
			echo -n -e "\r U-NEXT:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			return;
		fi	
	else
		echo -n -e "\r U-NEXT:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
	fi

}

# Paravi
function MediaUnlockTest_Paravi() {
    echo -n -e " Paravi:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 -H "Content-Type: application/json" -d '{"meta_id":71885,"vuid":"3b64a775a4e38d90cc43ea4c7214702b","device_code":1,"app_id":1}' https://api.paravi.jp/api/v1/playback/auth 2>&1);
	
	if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r Paravi:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
	
	checkiffaild=$(PharseJSON "${tmpresult}" "error.code");
    if [[ "$checkiffaild" == "2055" ]]; then
		echo -n -e "\r Paravi:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	
	local result=$(echo ${tmpresult} | grep 'playback_validity_end_at' 2>&1)
	
	if [ -n "${result}" ]; then
		echo -n -e "\r Paravi:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	else
		echo -n -e "\r Paravi:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi

}

function MediaUnlockTest_HamiVideo(){
    echo -n -e " Hami Video:\t\t\t\t->\c";
    local tmpresult=$(curl --user-agent "${UA_Browser}" -${1} -s --max-time 10 "https://hamivideo.hinet.net/api/play.do?id=OTT_VOD_0000249064&freeProduct=1");
	if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r Hami Video:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
	
	checkfailed=$(PharseJSON "${tmpresult}" "code")
    if [[ "$checkfailed" == "06001-106" ]]; then
		echo -n -e "\r Hami Video:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;	
	elif [[ "$checkfailed" == "06001-107" ]]; then
		echo -n -e "\r Hami Video:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	else
		echo -n -e "\r Hami Video:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_4GTV(){
    echo -n -e " 4GTV.TV:\t\t\t\t->\c";
    local tmpresult=$(curl --user-agent "${UA_Browser}" -${1} -s --max-time 10 -X POST -d 'value=D33jXJ0JVFkBqV%2BZSi1mhPltbejAbPYbDnyI9hmfqjKaQwRQdj7ZKZRAdb16%2FRUrE8vGXLFfNKBLKJv%2BfDSiD%2BZJlUa5Msps2P4IWuTrUP1%2BCnS255YfRadf%2BKLUhIPj' "https://api2.4gtv.tv//Vod/GetVodUrl3");
	if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r 4GTV.TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
	
	checkfailed=$(PharseJSON "${tmpresult}" "Success")
    if [[ "$checkfailed" == "false" ]]; then
		echo -n -e "\r 4GTV.TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;	
	elif [[ "$checkfailed" == "true" ]]; then
		echo -n -e "\r 4GTV.TV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	else
		echo -n -e "\r 4GTV.TV:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_SlingTV() {
    echo -n -e " Sling TV:\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Dalvik}" -${1} -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.sling.com/");
    if [ "$result" = "000" ]; then
        echo -n -e "\r Sling TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
    elif [ "$result" = "200" ]; then
        echo -n -e "\r Sling TV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    elif [ "$result" = "403" ]; then
        echo -n -e "\r Sling TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    else
        echo -n -e "\r Sling TV:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_PlutoTV() {
    echo -n -e " Pluto TV:\t\t\t\t->\c";
    local result=$(curl -${1} -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://pluto.tv/" | grep 'thanks-for-watching');
    
	if [ -n "$result" ]; then
		echo -n -e "\r Pluto TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r Pluto TV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r Pluto TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;
}

function MediaUnlockTest_Channel4() {
    echo -n -e " Channel 4:\t\t\t\t->\c";
    local result=$(curl -${1} -s --max-time 10 "https://ais.channel4.com/simulcast/C4?client=c4" | grep 'status' |  cut -f2 -d'"');
    
	if [[ "$result" == "ERROR" ]]; then
		echo -n -e "\r Channel 4:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    elif [[ "$result" == "OK" ]]; then
		echo -n -e "\r Channel 4:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r Channel 4:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;
}

function MediaUnlockTest_ITVHUB() {
    echo -n -e " ITV Hub:\t\t\t\t->\c";
    local result=$(curl -${1} -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://simulcast.itv.com/playlist/itvonline/ITV");
    if [ "$result" = "000" ]; then
		echo -n -e "\r ITV Hub:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
    elif [ "$result" = "404" ]; then
        echo -n -e "\r ITV Hub:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    elif [ "$result" = "403" ]; then
        echo -n -e "\r ITV Hub:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    else
        echo -n -e "\r ITV Hub:\t\t\t\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n"
		return;
    fi

}

function MediaUnlockTest_iQiyi(){
    echo -n -e " iQiyi Global:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -I "https://www.iq.com/" 2>&1);
    if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r iQiyi Global:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
    
    local result=$(echo "${tmpresult}" | grep 'mod=' | awk '{print $2}' | cut -f2 -d'=' | cut -f1 -d';');
    if [ -n "$result" ]; then
		if [[ "$result" == "ntw" ]]; then
			echo -n -e "\r iQiyi Global:\t\t\t\t${Font_Green}Yes(Region: TW)${Font_Suffix}\n"
			return;
		else
			result=$(echo ${result} | tr 'a-z' 'A-Z') 
			echo -n -e "\r iQiyi Global:\t\t\t\t${Font_Green}Yes(Region: ${result})${Font_Suffix}\n"
			return;
		fi	
    else
		echo -n -e "\r iQiyi Global:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
	fi	
}

function MediaUnlockTest_HuluUS(){
    echo -n -e " Hulu United States:\t\t\t->\c";
    local tmpresult=$(curl --user-agent "${UA_Browser}" -${1} -s --max-time 10 -X POST https://play.hulu.com/v6/playlist -d "${HuluUS_Content}" -H "Content-type: application/json" -b "${HuluUS_Cookie}");
	if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r Hulu United States:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
	
	checkfailed=$(PharseJSON "$tmpresult" "code")
	if [[ "$checkfailed" == "BYA-403-013" ]] || [[ "$checkfailed" == "BYA-403-011" ]];then
		echo -n -e "\r Hulu United States:\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;	
	fi
	
	echo $tmpresult | python -m json.tool 2> /dev/null | grep 'play.hulu.com' > /dev/null 2>&1
	if [[ "${tmpresult}" != *"play.hulu.com"* ]];then
		echo -n -e "\r Hulu United States:\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;	
	else
		echo -n -e "\r Hulu United States:\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;	
	fi
}

function MediaUnlockTest_encoreTVB() {
    echo -n -e " encoreTVB:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 -H "Accept: application/json;pk=BCpkADawqM2Gpjj8SlY2mj4FgJJMfUpxTNtHWXOItY1PvamzxGstJbsgc-zFOHkCVcKeeOhPUd9MNHEGJoVy1By1Hrlh9rOXArC5M5MTcChJGU6maC8qhQ4Y8W-QYtvi8Nq34bUb9IOvoKBLeNF4D9Avskfe9rtMoEjj6ImXu_i4oIhYS0dx7x1AgHvtAaZFFhq3LBGtR-ZcsSqxNzVg-4PRUI9zcytQkk_YJXndNSfhVdmYmnxkgx1XXisGv1FG5GOmEK4jZ_Ih0riX5icFnHrgniADr4bA2G7TYh4OeGBrYLyFN_BDOvq3nFGrXVWrTLhaYyjxOr4rZqJPKK2ybmMsq466Ke1ZtE-wNQ" -H "Origin: https://www.encoretvb.com" "https://edge.api.brightcove.com/playback/v1/accounts/5324042807001/videos/6005570109001" 2>&1);
    if [[ "$tmpresult" == "curl"* ]];then
        echo -n -e "\r encoreTVB:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi

    if ! PharseJSON "$tmpresult" "error_subcode" > /dev/nul 2>&1; then
		echo -n -e "\r encoreTVB:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
	local result=$(PharseJSON "$tmpresult" "error_subcode");
	if [[ "$result" == "CLIENT_GEO" ]]; then
		echo -n -e "\r encoreTVB:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
	
	if [[ "${tmpresult}" != *"account_id"* ]];then
		echo -n -e "\r encoreTVB:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r encoreTVB:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
	return;
}

function MediaUnlockTest_Molotov(){
    echo -n -e " Molotov:\t\t\t\t->\c";
    local tmpresult=$(PharseJSON "$(curl -${1} -s --max-time 10 "https://fapi.molotov.tv/v1/open-europe/is-france")" "is_france");
	if [[ "${tmpresult}" == "curl"* ]]; then
        echo -n -e "\r Molotov:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
	if [[ "${tmpresult}" == "false" ]]; then
		echo -n -e "\r Molotov:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;	
	elif [[ "${tmpresult}" == "true" ]]; then
		echo -n -e "\r Molotov:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;	
	else
		echo -n -e "\r Molotov:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;	
	fi
}

function MediaUnlockTest_LineTV_TW() {
    echo -n -e " LineTV.TW:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 "https://www.linetv.tw/api/part/11829/eps/1/part?chocomemberId=" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r LineTV.TW:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
    local result=$(PharseJSON "${tmpresult}" "countryCode");
    if [ -n "$result" ];then
		if [ "$result" = "228" ]; then
			echo -n -e "\r LineTV.TW:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			return;
		else
			echo -n -e "\r LineTV.TW:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			return;
		fi	
    else
        echo -n -e "\r LineTV.TW:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
    fi

}

function MediaUnlockTest_Viu_com() {
    echo -n -e " Viu.com:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.viu.com/" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Viu.com:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
	local result=$(echo ${tmpresult} | cut -f5 -d"/")
	if [ -n "${result}" ]; then
		if [[ "${result}" == "no-service" ]]; then
			echo -n -e "\r Viu.com:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			return;
		else
			result=$(echo ${result} | tr 'a-z' 'A-Z')
			echo -n -e "\r Viu.com:\t\t\t\t${Font_Green}Yes(Region: ${result})${Font_Suffix}\n"
			return;
		fi
    else
		echo -n -e "\r Viu.com:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_Niconico() {
    echo -n -e " Niconico:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 "https://www.nicovideo.jp/watch/so23017073" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Niconico:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
    if [[ "${tmpresult}" != *"同じ地域"* ]]; then
			echo -n -e "\r Niconico:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			return;
		else
			echo -n -e "\r Niconico:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			return;
    fi
}

function MediaUnlockTest_ParamountPlus() {
    echo -n -e " Paramount+:\t\t\t\t->\c";
    local result=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.paramountplus.com/" 2>&1 | grep 'intl');
	if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Paramount+:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	if [ -n "${result}" ]; then
		echo -n -e "\r Paramount+:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r Paramount+:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_KKTV() {
    echo -n -e " KKTV:\t\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 "https://api.kktv.me/v3/ipcheck" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r KKTV:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	local result=$(PharseJSON "$tmpresult" "data.country")	
    if [[ "$result" == "TW" ]];then
		echo -n -e "\r KKTV:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;	
    else
        echo -n -e "\r KKTV:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_PeacockTV() {
    echo -n -e " Peacock TV:\t\t\t\t->\c";
    local result=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.peacocktv.com/" 2>&1 | grep 'unavailable');
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Peacock TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	if [ -n "$result" ]; then
		echo -n -e "\r Peacock TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r Peacock TV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_FOD() {
	echo -n -e " Fuji TV:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s --max-time 10 "https://geocontrol1.stream.ne.jp/fod-geo/check.xml?time=1145141919810" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Fuji TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
    if [[ "${tmpresult}" == *"true"* ]]; then
		echo -n -e "\r Fuji TV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    else
		echo -n -e "\r Fuji TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi
}

function MediaUnlockTest_TikTok(){
    echo -n -e " Tiktok:\t\t\t\t->\c";
    local tmpresult=$(curl --user-agent "${UA_Browser}" -${1} -s --max-time 10 "https://www.tiktok.com/" 2>&1)
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Tiktok:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	local result=$(echo $tmpresult | grep '"$region":"' | sed 's/.*"$region//' | cut -f3 -d'"')
    if [ -n "$result" ];then
        echo -n -e "\r Tiktok:\t\t\t\t${Font_Green}Yes(Region: ${result})${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Tiktok:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_YouTube() {
    echo -n -e " YouTube:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -H "Accept-Language: en" "https://www.youtube.com/premium")
    local region=$(curl --user-agent "${UA_Browser}" -${1} -sL "https://www.youtube.com/red" | sed 's/,/\n/g' | grep "countryCode" | cut -d '"' -f4)
	if [ -n "$region" ]; then
        sleep 0
	else
		region=US
	fi	
	
    if [[ "$tmpresult" == "curl"* ]];then
        echo -n -e "\r YouTube:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
    local result=$(echo $tmpresult | grep 'Premium is not available in your country')
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube:\t\t\t\t${Font_Red}No Premium${Font_Suffix}(Region: ${region})${Font_Suffix} \n"
        return;
		
    fi
    local result=$(echo $tmpresult | grep 'YouTube and YouTube Music ad-free')
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r YouTube:\t\t\t\t${Font_Red}Failed${Font_Suffix}\n"
		
    fi	
	
    
}

function MediaUnlockTest_BritBox() {
    echo -n -e " BritBox:\t\t\t\t->\c";
    local result=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.britbox.com/" | grep 'locationnotsupported' 2>&1);
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r BritBox:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	if [ -n "${result}" ]; then
		echo -n -e "\r BritBox:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
     else
		echo -n -e "\r BritBox:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
	fi
	
	echo -n -e "\r BritBox:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	return;
}

function MediaUnlockTest_PrimeVideo(){
    echo -n -e " Amazon Prime Video:\t\t\t->\c";
    local tmpresult=$(curl -${1} --max-time 10 --user-agent "${UA_Browser}" -s "https://www.primevideo.com" 2>&1)
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Amazon Prime Video:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	local result=$(echo $tmpresult | grep '"currentTerritory":' | sed 's/.*"currentTerritory//' | cut -f3 -d'"' | head -n 1)
    if [ -n "$result" ];then
        echo -n -e "\r Amazon Prime Video:\t\t\t${Font_Green}Yes(Region: $result)${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Amazon Prime Video:\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_Blacked(){
    echo -n -e " Blacked:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --max-time 10 --user-agent "${UA_Browser}" -s "https://www.primevideo.com" 2>&1)
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Blacked:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	if [[ "${country}" != "CN" ]];then
        echo -n -e "\r Blacked:\t\t\t\t${Font_Green}Yes(Region: ${country})${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Blacked:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_Blacked(){
    echo -n -e " Blacked:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --max-time 10 --user-agent "${UA_Browser}" -s "https://www.primevideo.com" 2>&1)
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Blacked:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi

    if [[ "${country}" != "CN" ]];then
        echo -n -e "\r Blacked:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Blacked:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_Biguz(){
    echo -n -e " Biguz:\t\t\t\t\t->\c";
    local result=$(curl -${1} --max-time 10 -s --user-agent "${UA_Browser}" -o /dev/null -w '%{http_code}\n' "https://biguz.net" 2>&1)
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Biguz:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
	if [[ "${result}" != "403" ]];then
        echo -n -e "\r Biguz:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Biguz:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_Radiko(){
    echo -n -e " Radiko:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --user-agent "${UA_Browser}" -s "https://radiko.jp/area?_=1625406539531")

	if [ "$tmpresult" = "000" ]; then
		echo -n -e "\r Radiko:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
	fi	

	local checkfailed=$(echo $tmpresult | grep 'class="OUT"')
    if [ -n "$checkfailed" ];then
		echo -n -e "\r Radiko:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi

	local checksuccess=$(echo $tmpresult | grep 'JAPAN')
	if [ -n "$checksuccess" ];then
		area=$(echo $tmpresult | awk '{print $2}' | sed 's/.*>//')
        echo -n -e "\r Radiko:\t\t\t\t${Font_Green}Yes(Area: ${area})${Font_Suffix}\n"
		return;
    else
		echo -n -e "\r Radiko:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi

}

function MediaUnlockTest_DMM(){
    echo -n -e " DMM:\t\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --user-agent "${UA_Browser}" -s -X POST "https://api-p.videomarket.jp/v3/api/play/keyissue" -d 'fullStoryId=300G77001&playChromeCastFlag=false&loginFlag=0&playToken=04ee3e70e17e4a540505666cdd0a8301e656da53241447f83eb911a23355bd07&userId=undefined' -H "X-Authorization: S17mxcdRK3agC6UVIyDTdk7YFkQ29CzDwQrctjus")

	if [ "$tmpresult" = "000" ]; then
		echo -n -e "\r DMM:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
	fi	

	local checkfailed=$(echo $tmpresult | grep 'Access is denied')
    if [ -n "$checkfailed" ];then
		echo -n -e "\r DMM:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	fi

	local checksuccess=$(echo $tmpresult | grep 'PlayToken has failed')
	if [ -n "$checksuccess" ];then
		echo -n -e "\r DMM:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		return;
    else
		echo -n -e "\r DMM:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_Tving(){
    echo -n -e " Tving:\t\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --max-time 10 -s --user-agent "${UA_Browser}" "https://api.tving.com/v2a/media/stream/info?apiKey=1e7952d0917d6aab1f0293a063697610&info=Y&networkCode=CSND0900&osCode=CSOD0900&teleCode=CSCD0900&mediaCode=E003565993&screenCode=CSSD0100&noCache=1625447565&callingFrom=HTML5&adReq=adproxy&ooc=&uuid=4140415903-8a6df7d5&deviceInfo=PC" 2>&1)
    if [[ "${result}" == "curl"* ]];then
        echo -n -e "\r Tving:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
    
    local result=$(PharseJSON "${tmpresult}" "body.result.code")
	if [[ "${result}" == "100" ]];then
        echo -n -e "\r Tving:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        return;
	else
		echo -n -e "\r Tving:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
    fi
}

function MediaUnlockTest_KakaoTV(){
    echo -n -e " KakaoTV:\t\t\t\t->\c";
    local tmpresult=$(curl -${1} --max-time 10 -s --user-agent "${UA_Browser}" "https://tv.kakao.com/katz/v3/ft/cliplink/420380136/readyNplay?player=monet_html5&referer=https%3A%2F%2Ftv.kakao.com%2Fchannel%2F3815196%2Fcliplink%2F420380136&pageReferer=https%3A%2F%2Ftv.kakao.com%2Fchannel%2F3815196%2Fcliplink%2F420380136&uuid=&profile=HIGH&service=kakao_tv&section=channel&fields=seekUrl,abrVideoLocationList&playerVersion=3.10.25&appVersion=91.0.4472.114&startPosition=0&tid=&dteType=PC&continuousPlay=false&contentType=&drmType=widevine&1625448786881" 2>&1)
    if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r KakaoTV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi

    local result=$(jq -n -r "${tmpresult}" "code")
	if [[ "${result}" == "GeoBlocked" ]];then
		echo -n -e "\r KakaoTV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		return;
	else
        echo -n -e "\r KakaoTV:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        return;
    fi
}

function GameTest_ErogameScape(){
    echo -n -e " ErogameScape:\t\t\t\t->\c";
    local result=$(curl -${1} --max-time 3 --user-agent "${UA_Browser}" "https://erogamescape.dyndns.org/" 2>&1)
    if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r ErogameScape:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
        return;
    else
        echo -n -e "\r ErogameScape:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        return;
    fi
}

function IPInfo() {
    local result=$(curl -fsSL http://ip-api.com/json/ 2>&1);
	
	echo -e -n " IP:\t\t\t\t\t->\c";
    local ip=$(PharseJSON "${result}" "query");
	echo -e -n "\r IP:\t\t\t\t\t${Font_Green}${ip}${Font_Suffix}\n";
	
	echo -e -n " Country:\t\t\t\t->\c";
	local country=$(PharseJSON "${result}" "country");
	echo -e -n "\r Country:\t\t\t\t${Font_Green}${country}${Font_Suffix}\n";
	
	echo -e -n " Region:\t\t\t\t->\c";
	local region=$(PharseJSON "${result}" "regionName");
	echo -e -n "\r Region:\t\t\t\t${Font_Green}${region}${Font_Suffix}\n";
	
	echo -e -n " City:\t\t\t\t\t->\c";
	local city=$(PharseJSON "${result}" "city");
	echo -e -n "\r City:\t\t\t\t\t${Font_Green}${city}${Font_Suffix}\n";
	
	echo -e -n " ISP:\t\t\t\t\t->\c";
	local isp=$(PharseJSON "${result}" "isp");
	echo -e -n "\r ISP:\t\t\t\t\t${Font_Green}${isp}${Font_Suffix}\n";
	
	echo -e -n " Org:\t\t\t\t\t->\c";
	local org=$(PharseJSON "${result}" "org");
	echo -e -n "\r Org:\t\t\t\t\t${Font_Green}${org}${Font_Suffix}\n";
}

function MediaUnlockTest() {
	IPInfo ${1};
	
    hk ${1};

    tw ${1};
	
    jp ${1};

    kr ${1};
	
    us ${1};

    eu ${1};
	
    global ${1};
}

function hk() {
	echo -e "\n -- Hong Kong --"
	MediaUnlockTest_MyTVSuper ${1};
	MediaUnlockTest_NowE ${1};
	MediaUnlockTest_ViuTV ${1};
	MediaUnlockTest_BilibiliHKMCTW ${1};
}

function tw() {
    echo -e "\n -- Taiwan --"
	MediaUnlockTest_4GTV ${1};
	MediaUnlockTest_KKTV ${1};
	MediaUnlockTest_HamiVideo ${1};
	MediaUnlockTest_LineTV_TW ${1};
	MediaUnlockTest_BahamutAnime ${1};
	MediaUnlockTest_BilibiliTW ${1};
}

function jp() {
	echo -e "\n -- Japan --"
	MediaUnlockTest_AbemaTV ${1};
	MediaUnlockTest_Niconico ${1};
	MediaUnlockTest_Paravi ${1};
	MediaUnlockTest_unext ${1};
	MediaUnlockTest_HuluJP ${1};
	MediaUnlockTest_FOD ${1};
    MediaUnlockTest_Radiko ${1};
    MediaUnlockTest_DMM ${1};
	GameTest_PCRJP ${1};
	GameTest_UMAJP ${1};
	GameTest_Kancolle ${1};
    GameTest_ErogameScape ${1};
}

function kr() {
    echo -e "\n -- Korea --"
    MediaUnlockTest_Tving ${1};
    MediaUnlockTest_KakaoTV ${1};
}

function us() {
	echo -e "\n -- United States --"
	MediaUnlockTest_HuluUS ${1};
	MediaUnlockTest_HBONow ${1};
	MediaUnlockTest_HBOMax ${1};
	MediaUnlockTest_ParamountPlus ${1};
	MediaUnlockTest_PeacockTV ${1};
	MediaUnlockTest_SlingTV ${1};
	MediaUnlockTest_PlutoTV ${1};
	MediaUnlockTest_encoreTVB ${1};
	MediaUnlockTest_ABC ${1};
}

function eu() {
    echo -e "\n -- Europe --"
	MediaUnlockTest_BritBox ${1};
	MediaUnlockTest_ITVHUB ${1};
	MediaUnlockTest_Channel4 ${1};
	MediaUnlockTest_BBCiPLAYER ${1};
	MediaUnlockTest_Molotov ${1};
}

function global() {
    echo -e "\n -- Porn --"
    MediaUnlockTest_Biguz ${1};
    MediaUnlockTest_Blacked ${1};

	echo -e "\n -- Global --"
	MediaUnlockTest_DAZN ${1};
	MediaUnlockTest_Netflix ${1};
	MediaUnlockTest_DisneyPlus ${1};
	MediaUnlockTest_YouTube ${1};
	MediaUnlockTest_PrimeVideo ${1};
	MediaUnlockTest_TikTok ${1};
	MediaUnlockTest_iQiyi ${1};
	MediaUnlockTest_Viu_com ${1};
	GameTest_Steam ${1};
}

function startcheck() {
    mode=${1}
    mode=$(echo ${mode} | tr 'A-Z' 'a-z')
    if [[ "${mode}" != "" ]]; then
        case $mode in
            'hk')
                IPInfo ${2};
                hk ${2};
                global ${2};
            ;;
            'tw')
                IPInfo ${2};
                tw ${2};
                global ${2};
            ;;
            'jp')
                IPInfo ${2};
                jp ${2};
                global ${2};
            ;;
            'kr')
                IPInfo ${2};
                kr ${2};
                global ${2};
            ;;
            'us')
                IPInfo ${2};
                us ${2};
                global ${2};
            ;;
            'eu')
                IPInfo ${2};
                eu ${2};
                global ${2};
            ;;
            'global')
                IPInfo ${2};
                global ${2};
            ;;
            *)
                MediaUnlockTest ${2};
        esac
    else
        MediaUnlockTest ${2};
    fi
}

# curl 包测试
if ! curl -V > /dev/null 2>&1;then
    InstallCurl;
fi

# jq 包测试
if ! jq -V > /dev/null 2>&1;then
    InstallJQ;
fi

echo "";
echo "- IPV4 -";
check4=$(ping 1.1.1.1 -c 1 2>&1);
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    startcheck "${1}" "4";
else
    v4=""
    echo -e "${Font_SkyBlue}当前主机不支持IPv4,跳过...${Font_Suffix}";
fi

echo ""
echo "- IPV6 -";
check6=$(ping6 240c::6666 -c 1 2>&1);
if [[ "$check6" != *"unreachable"* ]] && [[ "$check6" != *"Unreachable"* ]];then
    v6="1"
else
    v6=""
    echo -e "${Font_SkyBlue}当前主机不支持IPv6,跳过...${Font_Suffix}";
fi

echo -e "\n${Font_Green}测试完成.${Font_Suffix}\n"
