redis = require('redis') 
URL = require('socket.url') 
HTTPS = require ("ssl.https") 
https = require ("ssl.https") 
http  = require ("socket.http") 
serpent = require("serpent") 
json = dofile('./JSON.lua') 
JSON = dofile('./dkjson.lua') 
lgi = require('lgi') 
notify = lgi.require('Notify') 
utf8 = require ('lua-utf8') 
notify.init ("Telegram updates") 
DevAbs = redis.connect('127.0.0.1', 6379) 
User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
ServerHASSAN = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a') 
Ip = io.popen("dig +short myip.opendns.com @resolver1.opendns.com"):read('*a'):gsub('[\n\r]+', '')
Name = io.popen("uname -a | awk '{ name = $2 } END { print name }'"):read('*a'):gsub('[\n\r]+', '')
Port = io.popen("echo ${SSH_CLIENT} | awk '{ port = $3 } END { print port }'"):read('*a'):gsub('[\n\r]+', '')
UpTime = io.popen([[uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}']]):read('*a'):gsub('[\n\r]+', '')
local AutoSet = function() 
if not DevAbs:get(ServerHASSAN.."IdHASSAN") then 
io.write('\27[1;35m\nالان ارسل ايدي المطور الاساسي ↫ ⤈\n\27[0;33;49m') 
local DevId = io.read():gsub(' ','') 
if tostring(DevId):match('%d+') then 
io.write('\27[1;36mتم حفظ ايدي المطور الاساسي\n27[0;39;49m') 
DevAbs:set(ServerHASSAN.."IdHASSAN",DevId) 
else 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nلم يتم حفظ ايدي المطور الاساسي ارسله مره اخرى\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
end 
os.execute('lua HASSAN.lua') 
end 
if not DevAbs:get(ServerHASSAN.."TokenHASSAN") then 
io.write('\27[1;35m\nالان قم بارسال توكن البوت ↫ ⤈\n\27[0;33;49m') 
local TokenBot = io.read() 
if TokenBot ~= '' then 
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe') 
if res ~= 200 then 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nالتوكن غير صحيح تاكد منه ثم ارسله\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
else 
io.write('\27[1;36mتم حفظ توكن البوت بنجاح\n27[0;39;49m') 
DevAbs:set(ServerHASSAN.."TokenHASSAN",TokenBot) 
end  
else 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nلم يتم حفظ توكن البوت ارسله مره اخرى\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
end  
os.execute('lua HASSAN.lua') 
end 
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
local CreateConfigAuto = function()
Config = {
DevId = DevAbs:get(ServerHASSAN.."IdHASSAN"),
TokenBot = DevAbs:get(ServerHASSAN.."TokenHASSAN"),
HASSAN = DevAbs:get(ServerHASSAN.."TokenHASSAN"):match("(%d+)"),
SudoIds = {DevAbs:get(ServerHASSAN.."IdHASSAN")},
}
Create(Config, "./config.lua")   
file = io.open("HASSAN.sh", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/HASSAN
token="]]..DevAbs:get(ServerHASSAN.."TokenHASSAN")..[["
while(true) do
rm -fr ../.telegram-cli
if [ ! -f ./tg ]; then
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
echo "~ The tg File Was Not Found In The Bot Files"
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
exit 1
fi
if [ ! $token ]; then
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
echo "~ The Token Was Not Found In The config.lua File"
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
exit 1
fi
./tg -s ./HASSAN.lua -p PROFILE --bot=$token
done
]])  
file:close()  
file = io.open("Run", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/HASSAN
while(true) do
rm -fr ../.telegram-cli
screen -S HASSAN -X kill
screen -S HASSAN ./HASSAN.sh
done
]]) 
file:close() 
io.popen("mkdir Files")
os.execute('chmod +x Run;./Run')
end 
CreateConfigAuto()
end
local Load_HASSAN = function() 
local f = io.open("./config.lua", "r") 
if not f then 
AutoSet() 
else 
f:close() 
DevAbs:del(ServerHASSAN.."IdHASSAN");DevAbs:del(ServerHASSAN.."TokenHASSAN")
end 
local config = loadfile("./config.lua")() 
return config 
end  
Load_HASSAN() 
print("\27[36m"..[[                                           
.................
]]..'\27[m'.."\n\27[35mServer Information ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\27[m\n\27[36m~ \27[mUser \27[36m: \27[10;32m"..User.."\27[m\n\27[36m~ \27[mIp \27[36m: \27[10;32m"..Ip.."\27[m\n\27[36m~ \27[mName \27[36m: \27[10;32m"..Name.."\27[m\n\27[36m~ \27[mPort \27[36m: \27[10;32m"..Port.."\27[m\n\27[36m~ \27[mUpTime \27[36m: \27[10;32m"..UpTime.."\27[m\n\27[35m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\27[m")
Config = dofile("./config.lua")
DevId = Config.DevId
SudoIds = {Config.SudoIds,806201930}
HASSAN = Config.HASSAN
TokenBot = Config.TokenBot
NameBot = (DevAbs:get(HASSAN..'Abs:NameBot') or 'اهل البيت بين الاتباع والابتداع')
FilesPrint = "\27[35m".."\nAll Source Files Started ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..'\27[m'
FilesNumber = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
FilesNumber = FilesNumber + 1
FilesPrint = FilesPrint.."\27[39m"..FilesNumber.."\27[36m".."~ : \27[10;32m"..v.."\27[m \n"
end
end
FilesPrint = FilesPrint.."\27[35m".."┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n".."\27[m"
if FilesNumber ~= 0 then
print(FilesPrint)
end
--     Start Functions    --
function vardump(value)
print(serpent.block(value, {comment=false}))
end
function dl_cb(arg, data)
end
----------  Sudo  ----------
function Sudo(msg) 
local var = false 
for k,v in pairs(SudoIds) do 
if msg.sender_user_id_ == v then 
var = true 
end end 
if msg.sender_user_id_ == tonumber(DevId) then 
var = true 
end 
return var 
end
function SudoId(user_id) 
local var = false 
for k,v in pairs(SudoIds) do 
if user_id == v then 
var = true 
end end 
if user_id == tonumber(DevId) then 
var = true 
end 
return var 
end
-------  SecondSudo  -------
function SecondSudo(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:SecondSudo:',msg.sender_user_id_) 
if Status or Sudo(msg) then  
return true  
else  
return false  
end  
end
----------  Bot  -----------
function Bot(msg) 
local var = false  
if msg.sender_user_id_ == tonumber(HASSAN) then  
var = true  
end  
return var  
end 
---------  SudoBot  --------
function SudoBot(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:SudoBot:',msg.sender_user_id_) 
if Status or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
---------Manager All--------
function ManagerAll(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:ManagerAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--------- Admin All --------
function AdminAll(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:AdminAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
------ VIP MEMBER ALL ------
function VipAll(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:VipAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
----   AbsConstructor   ----
function AbsConstructor(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
----  BasicConstructor  ----
function BasicConstructor(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AbsConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
----    Constructor     ----
function Constructor(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:Constructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AbsConstructor(msg) or BasicConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
---------  Manager  --------
function Manager(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:Managers:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AbsConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
----------  Admin  ---------
function Admin(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:Admins:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or AbsConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
---------Vip Member---------
function VipMem(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:VipMem:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or VipAll(msg) or AbsConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Admin(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--------- Cleaner ----------
function Cleaner(msg) 
local Status = DevAbs:sismember(HASSAN..'Abs:Cleaner:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or AbsConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
---------  Banned  ---------
local function Ban(user_id, chat_id)
if DevAbs:sismember(HASSAN..'Abs:Ban:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end
---------  BanAll  ---------
function BanAll(user_id)
if DevAbs:sismember(HASSAN..'Abs:BanAll:', user_id) then
var = true
else
var = false
end
return var
end
----------  Muted  ---------
local function Muted(user_id, chat_id)
if DevAbs:sismember(HASSAN..'Abs:Muted:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end
---------  MuteAll  --------
function MuteAll(user_id)
if DevAbs:sismember(HASSAN..'Abs:MuteAll:', user_id) then
var = true
else
var = false
end
return var
end
function DeleteMessage(chatid ,mid)
pcall(tdcli_function ({
ID = "DeleteMessages",
chat_id_ = chatid,
message_ids_ = mid
},function(arg,data) 
end,nil))
end
function send(chat_id, reply_to_message_id, text)
local TextParseMode = {ID = "TextParseModeMarkdown"}
pcall(tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil))
end
function HASSANFiles(msg)
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
plugin = dofile("Files/"..v)
if plugin.HASSAN and msg then
FilesText = plugin.HASSAN(msg)
end
end
end
send(msg.chat_id_, msg.id_,FilesText)  
end
function download_to_file(url, file_path) 
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end 
function AddFile(msg,chat,ID_FILE,File_Name)
if File_Name:match('.json') then
if File_Name:lower():match('(%d+)') ~= HASSAN:lower() then 
send(chat,msg.id_,"⌁︙عذرا هذا الملف ليس تابع لهذا البوت")   
return false 
end
send(chat,msg.id_,"⌁︙جاري رفع الملف ... .")
local File = json:decode(https.request('https://api.telegram.org/bot' .. TokenBot .. '/getfile?file_id='..ID_FILE) ) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..File.result.file_path, ''..File_Name) 
else
send(chat,msg.id_,"⌁︙عذرا الملف ليس بصيغة ↫ Json يرجى رفع الملف الصحيح")
end
local info_file = io.open('./'..HASSAN..'.json', "r"):read('*a')
local JsonInfo = JSON.decode(info_file)
vardump(JsonInfo)
DevAbs:set(HASSAN.."Abs:NameBot",JsonInfo.BotName) 
for IdGps,v in pairs(JsonInfo.GroupsList) do
DevAbs:sadd(HASSAN.."Abs:Groups",IdGps) 
DevAbs:set(HASSAN.."Abs:Lock:Bots"..IdGps,"del") DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..IdGps ,"Spam:User","keed") 
LockList ={'Abs:Lock:Links','Abs:Lock:Contact','Abs:Lock:Forwards','Abs:Lock:Videos','Abs:Lock:Gifs','Abs:Lock:EditMsgs','Abs:Lock:Stickers','Abs:Lock:Farsi','Abs:Lock:Spam','Abs:Lock:WebLinks','Abs:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevAbs:set(HASSAN..Lock..IdGps,true)
end
if v.AbsConstructors then
for k,IdAbsConstructors in pairs(v.AbsConstructors) do
DevAbs:sadd(HASSAN..'Abs:AbsConstructor:'..IdGps,IdAbsConstructors)  
print('تم رفع منشئين المجموعات')
end
end
if v.BasicConstructors then
for k,IdBasicConstructors in pairs(v.BasicConstructors) do
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..IdGps,IdBasicConstructors)  
print('تم رفع ( '..k..' ) منشئين اساسيين')
end
end
if v.Constructors then
for k,IdConstructors in pairs(v.Constructors) do
DevAbs:sadd(HASSAN..'Abs:Constructor:'..IdGps,IdConstructors)  
print('تم رفع ( '..k..' ) منشئين')
end
end
if v.Managers then
for k,IdManagers in pairs(v.Managers) do
DevAbs:sadd(HASSAN..'Abs:Managers:'..IdGps,IdManagers)  
print('تم رفع ( '..k..' ) مدراء')
end
end
if v.Admins then
for k,idmod in pairs(v.Admins) do
vardump(IdAdmins)
DevAbs:sadd(HASSAN..'Abs:Admins:'..IdGps,IdAdmins)  
print('تم رفع ( '..k..' ) ادمنيه')
end
end
if v.Vips then
for k,IdVips in pairs(v.Vips) do
DevAbs:sadd(HASSAN..'Abs:VipMem:'..IdGps,IdVips)  
print('تم رفع ( '..k..' ) مميزين')
end
end
if v.LinkGroups then
if v.LinkGroups ~= "" then
DevAbs:set(HASSAN.."Abs:Groups:Links"..IdGps,v.LinkGroups)   
print('( تم وضع روابط المجموعات )')
end
end
if v.Welcomes then
if v.Welcomes ~= "" then
DevAbs:set(HASSAN.."Abs:Groups:Welcomes"..IdGps,v.Welcomes)   
print('( تم وضع ترحيب المجموعات )')
end
end
end
send(chat,msg.id_,"⌁︙تم رفع النسخه بنجاح \n⌁︙تم تفعيل جميع المجموعات \n⌁︙تم استرجاع مشرفين المجموعات \n⌁︙تم استرجاع اوامر القفل والفتح في جميع مجموعات البوت ")
end
function resolve_username(username,cb)
tdcli_function ({
ID = "SearchPublicChat",
username_ = username
}, cb, nil)
end
function changeChatMemberStatus(chat_id, user_id, status)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = chat_id, user_id_ = user_id, status_ = { ID = "ChatMemberStatus" .. status }, }, dl_cb, nil)
end
function getInputFile(file)
if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
end
return infile
end
function getChatId(id)
local chat = {}
local id = tostring(id)
if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
end
return chat
end
function ChatLeave(chat_id, user_id)
changeChatMemberStatus(chat_id, user_id, "Left")
end
function do_notify(user, msg)
local n = notify.Notification.new(user, msg)
n:show ()
end
function ChatKick(chat_id, user_id)
changeChatMemberStatus(chat_id, user_id, "Kicked")
end
function getParseMode(parse_mode)
if parse_mode then
local mode = parse_mode:lower()
if mode == 'markdown' or mode == 'md' then
P = {ID = "TextParseModeMarkdown"}
elseif mode == 'html' then
P = {ID = "TextParseModeHTML"}
end
end
return P
end
function getMessage(chat_id, message_id,cb)
tdcli_function ({
ID = "GetMessage",
chat_id_ = chat_id,
message_id_ = message_id
}, cb, nil)
end
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessageContact", contact_ = { ID = "Contact", phone_number_ = phone_number, first_name_ = first_name, last_name_ = last_name, user_id_ = user_id },},}, dl_cb, nil)
end
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessagePhoto", photo_ = getInputFile(photo), added_sticker_file_ids_ = {}, width_ = 0, height_ = 0, caption_ = caption }, }, dl_cb, nil)
end
function Dev_Abs(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
local TextParseMode = getParseMode(parse_mode) tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text, disable_web_page_preview_ = disable_web_page_preview, clear_draft_ = 0, entities_ = {}, parse_mode_ = TextParseMode, }, }, dl_cb, nil)
end
function GetApi(web) 
local info, res = https.request(web) 
local req = json:decode(info) if res ~= 200 then 
return false 
end 
if not req.ok then 
return false 
end 
return req 
end 
function SendText(chat_id, text, reply_to_message_id, markdown) 
send_api = "https://api.telegram.org/bot"..TokenBot 
local url = send_api.."/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text) 
if reply_to_message_id ~= 0 then 
url = url .. "&reply_to_message_id=" .. reply_to_message_id  
end 
if markdown == "md" or markdown == "markdown" then 
url = url.."&parse_mode=Markdown&disable_web_page_preview=true" 
elseif markdown == "html" then 
url = url.."&parse_mode=HTML" 
end 
return GetApi(url) 
end
function SendInline(chat_id,text,keyboard,inline,reply_id) 
local response = {} 
response.keyboard = keyboard 
response.inline_keyboard = inline 
response.resize_keyboard = true 
response.one_time_keyboard = false 
response.selective = false  
local send_api = "https://api.telegram.org/bot"..TokenBot.."/sendMessage?chat_id="..chat_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response)) 
if reply_id then 
send_api = send_api.."&reply_to_message_id="..reply_id 
end 
return GetApi(send_api) 
end
function EditMsg(chat_id, message_id, text, markdown) local send_api = "https://api.telegram.org/bot"..TokenBot.."/editMessageText?chat_id="..chat_id.."&message_id="..message_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true" return GetApi(send_api)  end
function pin(channel_id, message_id, disable_notification) 
tdcli_function ({ 
ID = "PinChannelMessage", 
channel_id_ = getChatId(channel_id).ID, 
message_id_ = message_id, 
disable_notification_ = disable_notification 
}, function(arg ,data)
vardump(data)
end ,nil) 
end
function CatchName(Name,Num) 
ChekName = utf8.sub(Name,0,Num) Name = ChekName return Name..'' 
end
local AbsRank = function(msg) if SudoId(msg.sender_user_id_) then HASSANTEAM  = "المطور" elseif SecondSudo(msg) then HASSANTEAM = "المطور" elseif SudoBot(msg) then HASSANTEAM = "المطور" elseif ManagerAll(msg) then HASSANTEAM = "المدير" elseif AdminAll(msg) then HASSANTEAM = "الادمن" elseif AbsConstructor(msg) then HASSANTEAM = "المنشئ" elseif BasicConstructor(msg) then HASSANTEAM = "المنشئ" elseif Constructor(msg) then HASSANTEAM = "المنشئ" elseif Manager(msg) then HASSANTEAM = "المدير" elseif Admin(msg) then HASSANTEAM = "الادمن" else HASSANTEAM = "العضو" end return HASSANTEAM end
function IdRank(user_id,chat_id) if tonumber(user_id) == tonumber(806201930) then HASSANTEAM = 'مبرمج السورس' elseif tonumber(user_id) == tonumber(HASSAN) then HASSANTEAM = 'البوت' elseif SudoId(user_id) then HASSANTEAM = 'المطور الاساسي' elseif DevAbs:sismember(HASSAN..'Abs:SecondSudo:', user_id) then HASSANTEAM = 'المطور الثانوي' elseif DevAbs:sismember(HASSAN..'Abs:SudoBot:', user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:SudoBot:Rd"..chat_id) or 'المطور' elseif DevAbs:sismember(HASSAN..'Abs:ManagerAll:', user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:Managers:Rd"..chat_id) or 'المدير العام' elseif DevAbs:sismember(HASSAN..'Abs:AdminAll:', user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:Admins:Rd"..chat_id) or 'الادمن العام' elseif DevAbs:sismember(HASSAN..'Abs:VipAll:', user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:VipMem:Rd"..chat_id) or 'المميز العام' elseif DevAbs:sismember(HASSAN..'Abs:AbsConstructor:'..chat_id, user_id) then HASSANTEAM = 'منشئ المجموعه' elseif DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..chat_id, user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:BasicConstructor:Rd"..chat_id) or 'المنشئ الاساسي' elseif DevAbs:sismember(HASSAN..'Abs:Constructor:'..chat_id, user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:Constructor:Rd"..chat_id) or 'المنشئ' elseif DevAbs:sismember(HASSAN..'Abs:Managers:'..chat_id, user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:Managers:Rd"..chat_id) or 'المدير' elseif DevAbs:sismember(HASSAN..'Abs:Admins:'..chat_id, user_id) then HASSANTEAM = DevAbs:get(HASSAN.."Abs:Admins:Rd"..chat_id) or 'الادمن' elseif DevAbs:sismember(HASSAN..'Abs:VipMem:'..chat_id, user_id) then  HASSANTEAM = DevAbs:get(HASSAN.."Abs:VipMem:Rd"..chat_id) or 'المميز' elseif DevAbs:sismember(HASSAN..'Abs:Cleaner:'..chat_id, user_id) then  HASSANTEAM = DevAbs:get(HASSAN.."Abs:Cleaner:Rd"..chat_id) or 'المنظف' else HASSANTEAM = DevAbs:get(HASSAN.."Abs:mem:Rd"..chat_id) or 'العضو' end return HASSANTEAM end
function RankChecking(user_id,chat_id)
if SudoId(user_id) then
var = true  
elseif tonumber(user_id) == tonumber(HASSAN) then  
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:SecondSudo:', user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:SudoBot:', user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:ManagerAll:', user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:AdminAll:', user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:VipAll:', user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:AbsConstructor:'..chat_id, user_id) then
var = true
elseif DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..chat_id, user_id) then
var = true
elseif DevAbs:sismember(HASSAN..'Abs:Constructor:'..chat_id, user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:Managers:'..chat_id, user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:Admins:'..chat_id, user_id) then
var = true  
elseif DevAbs:sismember(HASSAN..'Abs:VipMem:'..chat_id, user_id) then  
var = true 
else  
var = false
end  
return var
end
function AbsDelAll(user_id,chat_id)
if SudoId(user_id) then
var = 'sudoid'  
elseif DevAbs:sismember(HASSAN..'Abs:SecondSudo:', user_id) then
var = 'secondsudo' 
elseif DevAbs:sismember(HASSAN..'Abs:SudoBot:', user_id) then
var = 'sudobot'  
elseif DevAbs:sismember(HASSAN..'Abs:AbsConstructor:'..chat_id, user_id) then
var = 'absconstructor'
elseif DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..chat_id, user_id) then
var = 'basicconstructor'
elseif DevAbs:sismember(HASSAN..'Abs:Constructor:'..chat_id, user_id) then
var = 'constructor'
elseif DevAbs:sismember(HASSAN..'Abs:Managers:'..chat_id, user_id) then
var = 'manager'  
else  
var = 'No'
end  
return var
end 
local function Filters(msg, value)
local abs = (HASSAN..'Abs:Filters:'..msg.chat_id_)
if abs then
local names = DevAbs:hkeys(abs)
local value = value:gsub(' ','')
for i=1, #names do
if string.match(value:lower(), names[i]:lower()) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
function ReplyStatus(msg,user_id,status,text)
tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,dp) 
if dp.first_name_ ~= false then
local UserName = (dp.username_ or "GO_XXO")
for gmatch in string.gmatch(dp.first_name_, "[^%s]+") do
dp.first_name_ = gmatch
end
if status == "WrongWay" then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙عذرا عزيزي ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "Reply" then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙العضو ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "ReplyBy" then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙بواسطة ↫ ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙الحساب محذوف قم بالتاكد واعد المحاوله", 1, 'md')
end
end,nil)   
end
function GetCustomTitle(user_id,chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..chat_id..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then 
Status = "المالك"
elseif GetInfo.result.status == "administrator" then 
Status = "مشرف"
else
Status = false
end
if GetInfo.result.custom_title then 
Abs = GetInfo.result.custom_title
else 
Abs = Status
end
end
return Abs
end
function Validity(msg,user_id) 
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then
send(msg.chat_id_,msg.id_,'⌁︙مالك المجموعه')   
return false  end 
if GetInfo.result.status == "member" then
send(msg.chat_id_,msg.id_,'⌁︙مجرد عضو هنا')   
return false  end
if GetInfo.result.status == 'left' then
send(msg.chat_id_,msg.id_,'⌁︙الشخص غير موجود هنا')   
return false  end
if GetInfo.result.status == "administrator" then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
send(msg.chat_id_,msg.id_,'⌁︙صلاحيات '..GetCustomTitle(user_id,msg.chat_id_)..' هي ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙حذف الرسائل ↫ '..DEL..'\n⌁︙دعوة المستخدمين ↫ '..INV..'\n⌁︙حظر المستخدمين ↫ '..BAN..'\n⌁︙تثبيت الرسائل ↫ '..PIN..'\n⌁︙تغيير المعلومات ↫ '..EDT..'\n⌁︙اضافة مشرفين ↫ '..VIP..'\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉')
end
end
end
function GetBio(chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..chat_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.bio then 
Abs = GetInfo.result.bio
else 
Abs = "لا يوجد"
end
end
return Abs
end
local sendRequest = function(request_id, chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, callback, extra)
tdcli_function({ ID = request_id, chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = input_message_content }, callback or dl_cb, extra)
end
local sendDocument = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, document, caption, cb, cmd)
local input_message_content = { ID = "InputMessageDocument", document_ = getInputFile(document), caption_ = caption } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVoice(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, voice, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageVoice", voice_ = getInputFile(voice), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendAudio(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, audio, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageAudio", audio_ = getInputFile(audio), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVideo(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, video, duration, width, height, caption, cb, cmd)    
local input_message_content = { ID = "InputMessageVideo",      video_ = getInputFile(video),      added_sticker_file_ids_ = {},      duration_ = duration or 0,      width_ = width or 0,      height_ = height or 0,      caption_ = caption    }    sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)  
end
local sendSticker = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, sticker)
local input_message_content = { ID = "InputMessageSticker", sticker_ = getInputFile(sticker), width_ = 0, height_ = 0 } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end 
function formsgs(msgs) 
local MsgText = ''  
if tonumber(msgs) < 100 then 
MsgText = 'جدا ضعيف' 
elseif tonumber(msgs) < 250 then 
MsgText = 'ضعيف' 
elseif tonumber(msgs) < 500 then 
MsgText = 'غير متفاعل' 
elseif tonumber(msgs) < 750 then 
MsgText = 'متوسط' 
elseif tonumber(msgs) < 1000 then 
MsgText = 'متفاعل' 
elseif tonumber(msgs) < 2000 then 
MsgText = 'قمة التفاعل' 
elseif tonumber(msgs) < 3000 then 
MsgText = ' التفاعل'  
elseif tonumber(msgs) < 4000 then 
MsgText = 'اسطورة التفاعل' 
elseif tonumber(msgs) < 5000 then 
MsgText = 'متفاعل نار' 
elseif tonumber(msgs) < 6000 then 
MsgText = 'يجدح جدح' 
elseif tonumber(msgs) < 7000 then 
MsgText = 'خيالي' 
elseif tonumber(msgs) < 8000 then 
MsgText = ' التفاعل' 
elseif tonumber(msgs) < 9000 then 
MsgText = ' بالتفاعل' 
elseif tonumber(msgs) < 10000000000 then 
MsgText = "متفاعل " 
end 
return MsgText
end
function absmoned(chat_id, user_id, msg_id, text, offset, length) local tt = DevAbs:get(HASSAN..'endmsg') or '' tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = msg_id, disable_notification_ = 0, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text..'\n\n'..tt, disable_web_page_preview_ = 1, clear_draft_ = 0, entities_ = {[0]={ ID="MessageEntityMentionName", offset_=offset, length_=length, user_id_=user_id }, }, }, }, dl_cb, nil) end
function ChCheck(msg)
local var = true 
if DevAbs:get(HASSAN.."DevAbs2") then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getchatmember?chat_id='..DevAbs:get(HASSAN..'DevAbs2')..'&user_id='..msg.sender_user_id_)
local data = json:decode(url)
if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
var = false 
if DevAbs:get(HASSAN..'Abs:textch:user') then
local textchuser = DevAbs:get(HASSAN..'Abs:textch:user')
send(msg.chat_id_,msg.id_,'['..textchuser..']')
else
send(msg.chat_id_,msg.id_,"⌁︙عليك الاشتراك في قناة البوت \n⌁︙قناة البوت ↫ ["..DevAbs:get(HASSAN..'DevAbs3').."]")
end
elseif data.ok then
return var
end
else
return var
end
end
chats = {}
function tdcli_update_callback(data)
if (data.ID == "UpdateNewCallbackQuery") then
local Chat_Id2 = data.chat_id_
local MsgId2 = data.message_id_
local DataText = data.payload_.data_
local Msg_Id2 = data.message_id_/2097152/0.5
if DataText == '/delyes' and DevAbs:get(HASSAN..'yes'..data.sender_user_id_) == 'delyes' then
DevAbs:del(HASSAN..'yes'..data.sender_user_id_, 'delyes')
DevAbs:del(HASSAN..'no'..data.sender_user_id_, 'delno')
if RankChecking(data.sender_user_id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, "⌁︙لا استطيع طرد ↫ "..IdRank(data.sender_user_id_, data.chat_id_)) 
return false
end
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=data.chat_id_,user_id_=data.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,da) 
if (da and da.code_ and da.code_ == 400 and da.message_ == "CHAT_ADMIN_REQUIRED") then 
EditMsg(Chat_Id2, Msg_Id2, "⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if (da and da.code_ and da.code_ == 3) then 
EditMsg(Chat_Id2, Msg_Id2, "⌁︙البوت ليس ادمن يرجى ترقيتي !") 
return false  
end
if da and da.code_ and da.code_ == 400 and da.message_ == "USER_ADMIN_INVALID" then 
EditMsg(Chat_Id2, Msg_Id2, "⌁︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
if da and da.ID and da.ID == "Ok" then
ChatKick(data.chat_id_, data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم طردك من المجموعه") 
return false
end
end,nil)  
end
if DataText == '/delno' and DevAbs:get(HASSAN..'no'..data.sender_user_id_) == 'delno' then
DevAbs:del(HASSAN..'yes'..data.sender_user_id_, 'delyes')
DevAbs:del(HASSAN..'no'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم الغاء امر اطردني") 
end
if DataText == '/yesdel' and DevAbs:get(HASSAN..'yesdel'..data.sender_user_id_) == 'delyes' then
DevAbs:del(HASSAN..'yesdel'..data.sender_user_id_, 'delyes')
DevAbs:del(HASSAN..'nodel'..data.sender_user_id_, 'delno')
if DevAbs:sismember(HASSAN..'Abs:Constructor:'..data.chat_id_, data.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAbs:sismember(HASSAN..'Abs:Managers:'..data.chat_id_, data.sender_user_id_) then
Managers = 'المدراء • ' else Managers = '' end
if DevAbs:sismember(HASSAN..'Abs:Admins:'..data.chat_id_, data.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAbs:sismember(HASSAN..'Abs:VipMem:'..data.chat_id_, data.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAbs:sismember(HASSAN..'Abs:Cleaner:'..data.chat_id_, data.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = '' end
if DevAbs:sismember(HASSAN..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
donky = 'المطايه • ' else donky = '' end
if DevAbs:sismember(HASSAN..'Abs:Constructor:'..data.chat_id_, data.sender_user_id_) or DevAbs:sismember(HASSAN..'Abs:Managers:'..data.chat_id_, data.sender_user_id_) or DevAbs:sismember(HASSAN..'Abs:Admins:'..data.chat_id_, data.sender_user_id_) or DevAbs:sismember(HASSAN..'Abs:VipMem:'..data.chat_id_, data.sender_user_id_) or DevAbs:sismember(HASSAN..'Abs:Cleaner:'..data.chat_id_, data.sender_user_id_) or DevAbs:sismember(HASSAN..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
DevAbs:srem(HASSAN..'Abs:Constructor:'..data.chat_id_,data.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..data.chat_id_,data.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..data.chat_id_,data.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..data.chat_id_,data.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..data.chat_id_,data.sender_user_id_)
DevAbs:srem(HASSAN..'User:Donky:'..data.chat_id_,data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم تنزيلك من ↫ ⤈\n~ ( "..constructor..''..Managers..''..admins..''..vipmem..''..cleaner..''..donky.." ) ~ \n") 
else 
if IdRank(data.sender_user_id_, data.chat_id_) == 'العضو' then
EditMsg(Chat_Id2, Msg_Id2, "⌁︙ليس لديك رتبه في البوت") 
else 
EditMsg(Chat_Id2, Msg_Id2, "⌁︙لا استطيع تنزيل ↫ "..IdRank(data.sender_user_id_, data.chat_id_)) 
end
end
end
if DevAbs:get(HASSAN.."Abs:NewDev"..data.sender_user_id_) then
if DataText == '/setno' then
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم الغاء امر تغير المطور الاساسي") 
DevAbs:del(HASSAN.."Abs:NewDev"..data.sender_user_id_)
return false
end
if DataText == '/setyes' then
local NewDev = DevAbs:get(HASSAN.."Abs:NewDev"..data.sender_user_id_)
tdcli_function ({ID = "GetUser",user_id_ = NewDev},function(arg,dp) 
EditMsg(Chat_Id2, Msg_Id2, "⌁︙المطور الجديد ↫ ["..CatchName(dp.first_name_,15).."](tg://user?id="..dp.id_..")\n⌁︙تم تغير المطور الاساسي بنجاح") 
end,nil)
tdcli_function ({ID = "GetUser",user_id_ = data.sender_user_id_},function(arg,dp) 
SendText(NewDev,"⌁︙بواسطة ↫ ["..CatchName(dp.first_name_,15).."](tg://user?id="..dp.id_..")\n⌁︙لقد اصبحت انت مطور هذا البوت",0,'md')
end,nil)
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
Config = {
DevId = NewDev,
TokenBot = TokenBot,
HASSAN = TokenBot:match("(%d+)"),
SudoIds = {NewDev},
}
Create(Config, "./config.lua")  
DevAbs:del(HASSAN.."Abs:NewDev"..data.sender_user_id_)
dofile('HASSAN.lua') 
end
end
if DataText == '/nodel' and DevAbs:get(HASSAN..'nodel'..data.sender_user_id_) == 'delno' then
DevAbs:del(HASSAN..'yesdel'..data.sender_user_id_, 'delyes')
DevAbs:del(HASSAN..'nodel'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم الغاء امر نزلني") 
end
if DataText == '/YesRolet' and DevAbs:get(HASSAN.."Abs:WittingStartRolet"..data.chat_id_..data.sender_user_id_) then
local List = DevAbs:smembers(HASSAN..'Abs:ListRolet'..data.chat_id_) 
local UserName = List[math.random(#List)]
tdcli_function ({ID="SearchPublicChat",username_ = UserName},function(arg,dp) 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..data.chat_id_..dp.id_, 5) 
end,nil) 
DevAbs:del(HASSAN..'Abs:ListRolet'..data.chat_id_) 
DevAbs:del(HASSAN.."Abs:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⌁︙*صاحب الحظ* ↫ ["..UserName.."]\n⌁︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*")
end
if DataText == '/NoRolet' then
DevAbs:del(HASSAN..'Abs:ListRolet'..data.chat_id_) 
DevAbs:del(HASSAN.."Abs:NumRolet"..data.chat_id_..data.sender_user_id_) 
DevAbs:del(HASSAN.."Abs:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⌁︙تم الغاء اللعبه لاعادة اللعب ارسل الالعاب") 
end
if DataText == '/ListRolet' then
local List = DevAbs:smembers(HASSAN..'Abs:ListRolet'..data.chat_id_) 
local Text = '⌁︙قائمة الاعبين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n' 
local Textt = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تم اكتمال العدد الكلي هل انت مستعد ؟'
for k, v in pairs(List) do 
Text = Text..k.."~ : [" ..v.."]\n"  
end 
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text..Textt).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if (data.ID == "UpdateNewMessage") then
local msg = data.message_
local d = data.disable_notification_
local chat = chats[msg.chat_id_]
text = msg.content_.text_ 
if text and DevAbs:get(HASSAN.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
local NewCmmd = DevAbs:get(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
if NewCmmd then
DevAbs:del(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
DevAbs:del(HASSAN.."Set:Cmd:Group:New"..msg.chat_id_)
DevAbs:srem(HASSAN.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف الامر من المجموعه", 1, 'html')  
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لايوجد امر بهذا الاسم", 1, 'html')
end
DevAbs:del(HASSAN.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if text and text:match('^'..(DevAbs:get(HASSAN..'Abs:NameBot') or "اهل البيت بين الاتباع والابتداع")..' ') then
data.message_.content_.text_ = data.message_.content_.text_:gsub('^'..(DevAbs:get(HASSAN..'Abs:NameBot') or "اهل البيت بين الاتباع والابتداع")..' ','')
end
if data.message_.content_.text_ then
local NewCmmd = DevAbs:get(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..data.message_.content_.text_)
if NewCmmd then
data.message_.content_.text_ = (NewCmmd or data.message_.content_.text_)
end
end
if text and DevAbs:get(HASSAN.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
DevAbs:set(HASSAN.."Set:Cmd:Group:New"..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل الامر الجديد", 1, 'html')
DevAbs:del(HASSAN.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
DevAbs:set(HASSAN.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_,"true1") 
return false
end
if text and DevAbs:get(HASSAN.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_) == "true1" then
local NewCmd = DevAbs:get(HASSAN.."Set:Cmd:Group:New"..msg.chat_id_)
DevAbs:set(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text,NewCmd)
DevAbs:sadd(HASSAN.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الامر", 1, 'html')
DevAbs:del(HASSAN.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if Constructor(msg) then
if text == "الاوامر المضافه" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN.."List:Cmd:Group:New"..msg.chat_id_.."") 
t = "⌁︙قائمة الاوامر المضافه ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
Cmds = DevAbs:get(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
if Cmds then 
t = t..""..k.."~ ("..v..") • {"..Cmds.."}\n"
else
t = t..""..k.."~ ("..v..") \n"
end
end
if #List == 0 then
t = "⌁︙لاتوجد اوامر مضافه في المجموعه"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if text == "حذف الاوامر المضافه" or text == "حذف الاوامر" or text == "مسح الاوامر المضافه" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN.."List:Cmd:Group:New"..msg.chat_id_)
for k,v in pairs(List) do
DevAbs:del(HASSAN.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
DevAbs:del(HASSAN.."List:Cmd:Group:New"..msg.chat_id_)
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف الاوامر المضافه في المجموعه", 1, 'html')
end
if text == "اضف امر" or text == "اضافة امر" or text == "اضافه امر" and ChCheck(msg) then
DevAbs:set(HASSAN.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل الامر القديم", 1, 'html')
return false
end
if text == "حذف امر" or text == "مسح امر" and ChCheck(msg) then 
DevAbs:set(HASSAN.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل الامر الذي قمت باضافته يدويا", 1, 'html')
return false
end
end
if text == "الصلاحيات" or text == "صلاحيات" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN.."Coomds"..msg.chat_id_)
if #List == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتوجد صلاحيات مضافه", 1, 'html')
return false
end
t = "⌁︙قائمة الصلاحيات المضافه ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
var = DevAbs:get(HASSAN.."Comd:New:rt:Abs:"..v..msg.chat_id_)
if var then
t = t..""..k.."~ "..v.." • ("..var..")\n"
else
t = t..""..k.."~ "..v.."\n"
end
end
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if Admin(msg) then
if text == "حذف الصلاحيات" and ChCheck(msg) or text == "مسح الصلاحيات" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN.."Coomds"..msg.chat_id_)
for k,v in pairs(List) do
DevAbs:del(HASSAN.."Comd:New:rt:Abs:"..v..msg.chat_id_)
DevAbs:del(HASSAN.."Coomds"..msg.chat_id_)
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف الصلاحيات المضافه", 1, 'html')
end
end
if text and text:match("^اضف صلاحيه (.*)$") and ChCheck(msg) then 
ComdNew = text:match("^اضف صلاحيه (.*)$")
DevAbs:set(HASSAN.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_,ComdNew)  
DevAbs:sadd(HASSAN.."Coomds"..msg.chat_id_,ComdNew)  
DevAbs:setex(HASSAN.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_,200,true)  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل نوع الصلاحيه \n{ عضو • مميز  • ادمن  • مدير }\n⌁︙ارسل الغاء لالغاء الامر ", 1, 'html')
end
if text and text:match("^حذف صلاحيه (.*)$") and ChCheck(msg) or text and text:match("^مسح صلاحيه (.*)$") and ChCheck(msg) then 
ComdNew = text:match("^حذف صلاحيه (.*)$") or text:match("^مسح صلاحيه (.*)$")
DevAbs:del(HASSAN.."Comd:New:rt:Abs:"..ComdNew..msg.chat_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف الصلاحيه", 1, 'html')
end
if DevAbs:get(HASSAN.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء الامر", 1, 'html')
DevAbs:del(HASSAN.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
if text == "مدير" then
if not Constructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تستطيع اضافة صلاحية ( عضو • مميز  • ادمن )\n⌁︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "ادمن" then
if not Manager(msg) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تستطيع اضافة صلاحية ( عضو • مميز )\n⌁︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مميز" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تستطيع اضافة صلاحية ( عضو )\n⌁︙ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مدير" or text == "ادمن" or text == "مميز" or text == "عضو" then
local textn = DevAbs:get(HASSAN.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_)  
DevAbs:set(HASSAN.."Comd:New:rt:Abs:"..textn..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اضافة الصلاحيه", 1, 'html')
DevAbs:del(HASSAN.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
end

if text and text:match("رفع (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_ABBAS = text:match("رفع (.*)")
if DevAbs:sismember(HASSAN.."Coomds"..msg.chat_id_,DEV_ABBAS) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrabs = DevAbs:get(HASSAN.."Comd:New:rt:Abs:"..DEV_ABBAS..msg.chat_id_)
if mrabs == "مميز" and VipMem(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS) 
DevAbs:sadd(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
elseif mrabs == "ادمن" and Admin(msg) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS)
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
elseif mrabs == "مدير" and Manager(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS)  
DevAbs:sadd(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
elseif mrabs == "عضو" then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("تنزيل (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_ABBAS = text:match("تنزيل (.*)")
if DevAbs:sismember(HASSAN.."Coomds"..msg.chat_id_,DEV_ABBAS) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrabs = DevAbs:get(HASSAN.."Comd:New:rt:Abs:"..DEV_ABBAS..msg.chat_id_)
if mrabs == "مميز" and VipMem(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrabs == "ادمن" and Admin(msg) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrabs == "مدير" and Manager(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrabs == "عضو" then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("^رفع (.*) @(.*)") then 
local text1 = {string.match(text, "^(رفع) (.*) @(.*)$")}
if DevAbs:sismember(HASSAN.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrabs = DevAbs:get(HASSAN.."Comd:New:rt:Abs:"..text1[2]..msg.chat_id_)
if mrabs == "مميز" and VipMem(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:sadd(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrabs == "ادمن" and Admin(msg) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrabs == "مدير" and Manager(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:sadd(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:set(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrabs == "عضو" then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end 
end
if text and text:match("^تنزيل (.*) @(.*)") then 
local text1 = {string.match(text, "^(تنزيل) (.*) @(.*)$")}
if DevAbs:sismember(HASSAN.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrabs = DevAbs:get(HASSAN.."Comd:New:rt:Abs:"..text1[2]..msg.chat_id_)
if mrabs == "مميز" and VipMem(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrabs == "ادمن" and Admin(msg) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrabs == "مدير" and Manager(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:del(HASSAN.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrabs == "عضو" then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو ↫ ❨ ['..result.title_..'](t.me/'..(text1[3] or 'GO_XXO')..')'..' ❩\n⌁︙تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end  
end
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match("-100(%d+)") then
DevAbs:incr(HASSAN..'Abs:UsersMsgs'..HASSAN..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_)
DevAbs:incr(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
DevAbs:incr(HASSAN..'Abs:MsgNumberDay'..msg.chat_id_..':'..os.date('%d'))  
ChatType = 'sp' 
elseif id:match("^(%d+)") then
if not DevAbs:sismember(HASSAN.."Abs:Users",msg.chat_id_) then
DevAbs:sadd(HASSAN.."Abs:Users",msg.chat_id_)
end
ChatType = 'pv' 
else
ChatType = 'gp' 
end
end 
if ChatType == 'pv' then 
if text == '/start' or text == 'رجوع ،🔙‘' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '⌁︙مرحبا عزيزي المطور \n⌁︙انت المطور الاساسي هنا \n⌁︙اليك ازرار سورس اهل البيت بين الاتباع والابتداع \n⌁︙تستطيع التحكم بكل الاوامر فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'وضع اسم البوت','↫ تحديث ⌁','وضع كليشه المطور'},
{'↫ المطورين ⌁','↫ الاحصائيات ⌁'},
{'↫ المجموعات ⌁','روابط الكروبات','↫ المشتركين ⌁'},
{'↫ تعطيل التواصل ⌁','↫ تفعيل التواصل ⌁'},
{'تنظيف الكروبات','↫ قائمه العام ⌁','تنظيف المشتركين'},
{'↫ تغير المطور الاساسي ⌁'},
{'تعطيل ترحيب البوت','تفعيل ترحيب البوت'},
{'↫ تغير معلومات الترحيب ⌁'},
{'↫ تعطيل المغادره ⌁','↫ تفعيل المغادره ⌁'},
{'↫ تعطيل الاذاعه ⌁','↫ تفعيل الاذاعه ⌁'},
{'↫ اذاعه بالتثبيت ⌁'},
{'↫ اذاعه عام ⌁','↫ اذاعه خاص ⌁'},
{'↫ اذاعه عام بالتوجيه ⌁','↫ اذاعه خاص بالتوجيه ⌁'},
{'~ تعيين كلايش الاوامر ~'},
{'تعطيل البوت الخدمي','تفعيل البوت الخدمي'},
{'جلب نسخه السورس','تحديث السورس','جلب نسخه الكروبات'},
{'↫ حذف رد عام ⌁','↫ الردود العام ⌁','↫ اضف رد عام ⌁'},
{'↫ حذف رد الخاص ⌁','↫ تعيين رد الخاص ⌁'},
{'حذف قناة الاشتراك','قناة الاشتراك','تعيين قناة الاشتراك'},
{'حذف كليشه الاشتراك','كليشه الاشتراك','تغير كليشه الاشتراك'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '~ تعيين كلايش الاوامر ~' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '⌁︙اهلا بك مجددا عزيزي المطور \n⌁︙اليك الازرار الخاصه بتعديل وتغيير كلايش سورس اهل البيت بين الاتباع والابتداع فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'حذف كليشة الايدي','تعيين كليشة الايدي'},
{'تعيين امر الاوامر'},
{'تعيين امر م3','تعيين امر م2','تعيين امر م1'},
{'تعيين امر م6','تعيين امر م5','تعيين امر م4'},
{'استعادة كلايش الاوامر'},
{'رجوع ،🔙‘'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '/start' and ChCheck(msg) then  
if not DevAbs:get(HASSAN..'Abs:Start:Time'..msg.sender_user_id_) then
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,dp) 
local inline = {{{text="⌁ المطور .",url="t.me/"..(dp.username_ or "GO_XXO")}}}
local start = DevAbs:get(HASSAN.."Abs:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "⌁︙مرحبا انا بوت اسمي "..NameBot.."\n⌁︙اختصاصي حماية المجموعات\n⌁︙من التفليش والسبام والخخ .. . ،\n⌁︙تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر ↫ تفعيل\n⌁︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
SendInline(msg.chat_id_,Start_Source,nil,inline)
end,nil)
end
DevAbs:setex(HASSAN..'Abs:Start:Time'..msg.sender_user_id_,300,true)
return false
end 
if not SecondSudo(msg) and not DevAbs:sismember(HASSAN..'Abs:Ban:Pv',msg.sender_user_id_) and not DevAbs:get(HASSAN..'Abs:Texting:Pv') then
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,chat) 
Dev_Abs(msg.sender_user_id_, msg.id_, 1, '⌁︙تم ارسال رسالتك الى [المطور](t.me/'..(chat.username_ or "GO_XXO")..')', 1, 'md') 
tdcli_function({ID="ForwardMessages",chat_id_=DevId,from_chat_id_= msg.sender_user_id_,message_ids_={[0]=msg.id_},disable_notification_=1,from_background_=1},function(arg,data) 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,dp) 
if data and data.messages_ and data.messages_[0] ~= false and data.ID ~= "Error" then
if data and data.messages_ and data.messages_[0].content_.sticker_ then
SendText(DevId,'⌁︙تم ارسال الملصق من ↫ ⤈\n['..string.sub(dp.first_name_,0, 40)..'](tg://user?id='..dp.id_..')',0,'md') 
return false
end;end;end,nil);end,nil);end,nil);end
if SecondSudo(msg) and msg.reply_to_message_id_ ~= 0  then    
tdcli_function({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)},function(extra, result, success) 
if result.forward_info_.sender_user_id_ then     
id_user = result.forward_info_.sender_user_id_    
end 
tdcli_function ({ID = "GetUser",user_id_ = id_user},function(arg,data) 
if text == 'حظر' or text == 'حضر' then
local Text = '⌁︙العضو ↫ ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n⌁︙تم حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevAbs:sadd(HASSAN..'Abs:Ban:Pv',data.id_)  
return false  
end 
if text == 'الغاء الحظر' or text == 'الغاء حظر' then
local Text = '⌁︙العضو ↫ ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n⌁︙تم الغاء حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevAbs:srem(HASSAN..'Abs:Ban:Pv',data.id_)  
return false  
end 
tdcli_function({ID='GetChat',chat_id_ = id_user},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",chat_id_ = id_user, action_ = {  ID = "SendMessageTypingAction", progress_ = 100} },function(arg,dp) 
if dp.code_ == 400 or dp.code_ == 5 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو قام بحظر البوت لا تستطيع ارسال الرسائل له', 1, 'md')
return false  
end 
if text then
Dev_Abs(id_user, 0, 1, text, 1, "md")  
Text = '⌁︙تم ارسال الرساله الى ↫ ⤈'
elseif msg.content_.ID == 'MessageSticker' then    
sendSticker(id_user, msg.id_, 0, 1,nil, msg.content_.sticker_.sticker_.persistent_id_)   
Text = '⌁︙تم ارسال الملصق الى ↫ ⤈'
elseif msg.content_.ID == 'MessagePhoto' then    
sendPhoto(id_user, msg.id_, 0, 1,nil, msg.content_.photo_.sizes_[0].photo_.persistent_id_,(msg.content_.caption_ or ''))    
Text = '⌁︙تم ارسال الصوره الى ↫ ⤈'
elseif msg.content_.ID == 'MessageAnimation' then    
sendDocument(id_user, msg.id_, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_)    
Text = '⌁︙تم ارسال المتحركه الى ↫ ⤈'
elseif msg.content_.ID == 'MessageVoice' then    
sendVoice(id_user, msg.id_, 0, 1,nil, msg.content_.voice_.voice_.persistent_id_)    
Text = '⌁︙تم ارسال البصمه الى ↫ ⤈'
end     
SendText(DevId, Text..'\n'..'['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')',0,'md') 
end,nil);
end,nil);
end,nil);
end,nil);
end 
end 
if text and DevAbs:get(HASSAN..'Abs:Start:Bots'..msg.sender_user_id_) then
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ كليشة الستارت', 1, 'md')
DevAbs:del(HASSAN..'Abs:Start:Bots'..msg.sender_user_id_) 
return false
end
DevAbs:set(HASSAN.."Abs:Start:Bot",text)  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ كليشة الستارت', 1, 'md')
DevAbs:del(HASSAN..'Abs:Start:Bots'..msg.sender_user_id_) 
return false
end
if SecondSudo(msg) then
if text == 'تعيين رد الخاص' or text == 'ضع كليشه ستارت' or text == '↫ تعيين رد الخاص ⌁' then 
DevAbs:set(HASSAN..'Abs:Start:Bots'..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي كليشة الستارت الان', 1, 'md')
return false
end
if text == 'حذف رد الخاص' or text == 'حذف كليشه ستارت' or text == '↫ حذف رد الخاص ⌁' then 
DevAbs:del(HASSAN..'Start:Bot') 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف كليشة الستارت بنجاح', 1, 'md')
end
if text == 'جلب رد الخاص' then  
local start = DevAbs:get(HASSAN.."Abs:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "⌁︙مرحبا انا بوت اسمي "..NameBot.."\n⌁︙اختصاصي حماية المجموعات\n⌁︙من التفليش والسبام والخخ .. . ،\n⌁︙تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر ↫ تفعيل\n⌁︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, Start_Source, 1, 'md')
return false
end
if text == 'تفعيل التواصل' or text == '↫ تفعيل التواصل ⌁' then   
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل التواصل بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Texting:Pv') 
end
if text == 'تعطيل التواصل' or text == '↫ تعطيل التواصل ⌁' then  
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل التواصل بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Texting:Pv',true) 
end
end
function getUser(user_id, cb)
tdcli_function ({
ID = "GetUser",
user_id_ = user_id
}, cb, nil)
end
local msg = data.message_
text = msg.content_.text_
if msg.content_.ID == "MessageChatAddMembers" then 
DevAbs:incr(HASSAN..'Abs:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)
DevAbs:set(HASSAN.."Who:Added:Me"..msg.chat_id_..':'..msg.content_.members_[0].id_,msg.sender_user_id_)
local mem_id = msg.content_.members_  
local Bots = DevAbs:get(HASSAN.."Abs:Lock:Bots"..msg.chat_id_) 
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "kick" and not VipMem(msg) then   
https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "del" and not VipMem(msg) then   
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "ked" and not VipMem(msg) then
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" .. msg.sender_user_id_ .. "&can_send_messages=false&can_send_media_messages=false&can_send_other_messages=false&can_add_web_page_previews=false")
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end  
end  
end
if msg.content_.ID == "MessageChatDeleteMember" and tonumber(msg.content_.user_.id_) == tonumber(HASSAN) then 
DevAbs:srem(HASSAN.."Abs:Groups", msg.chat_id_) 
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
if not Sudo(msg) then
SendText(DevId,"⌁︙تم طرد البوت من المجموعه ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙بواسطة ↫ "..Name.."\n⌁︙اسم المجموعه ↫ ["..NameChat.."]\n⌁︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الوقت ↫ "..os.date("%I:%M%p").."\n⌁︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end
if msg.content_.ID == "MessageChatDeletePhoto" or msg.content_.ID == "MessageChatChangePhoto" or msg.content_.ID == 'MessagePinMessage' or msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == 'MessageChatChangeTitle' or msg.content_.ID == "MessageChatDeleteMember" then   
if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})    
end   
end
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then   
DevAbs:incr(HASSAN..'Abs:EntryNumber'..msg.chat_id_..':'..os.date('%d'))  
elseif msg.content_.ID == "MessageChatDeleteMember" then   
DevAbs:incr(HASSAN..'Abs:ExitNumber'..msg.chat_id_..':'..os.date('%d'))  
end
if text ==('تفعيل') and not SudoBot(msg) and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:FreeBot'..HASSAN) then
if ChatType == 'pv' then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لاتستطيع تفعيلي هنا يرجى اضافتي في مجموعه اولا', 1, 'md')
return false
end
if ChatType ~= 'sp' then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,ChatMem) 
if ChatMem and ChatMem.status_.ID == "ChatMemberStatusEditor" or ChatMem and ChatMem.status_.ID == "ChatMemberStatusCreator" then
if ChatMem and ChatMem.user_id_ == msg.sender_user_id_ then
if ChatMem.status_.ID == "ChatMemberStatusCreator" then
status = 'منشئ'
elseif ChatMem.status_.ID == "ChatMemberStatusEditor" then
status = 'ادمن'
else 
status = 'عضو'
end
DevAbs:del(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_
for i=0 , #admins do
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)   
else
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevAbs:sadd(HASSAN.."Abs:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAbs:sadd(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAbs:srem(HASSAN.."Abs:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAbs:srem(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevAbs:sismember(HASSAN..'Abs:Groups',msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه بالتاكيد مفعله', 1, 'md')
else
if tonumber(data.member_count_) < tonumber(DevAbs:get(HASSAN..'Abs:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عدد اعضاء المجموعه اقل من ↫ *'..(DevAbs:get(HASSAN..'Abs:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
ReplyStatus(msg,result.id_,"ReplyBy","⌁︙تم تفعيل المجموعه "..dp.title_)  
DevAbs:sadd(HASSAN.."Abs:Groups",msg.chat_id_)
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAbs:set(HASSAN.."Abs:Groups:Links"..msg.chat_id_,LinkGroup) 
SendText(DevId,"⌁︙تم تفعيل مجموعه جديده ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙بواسطة ↫ "..Name.."\n⌁︙موقعه في المجموعه ↫ "..status.."\n⌁︙اسم المجموعه ↫ ["..NameChat.."]\n⌁︙عدد اعضاء المجموعه ↫ ❨ *"..NumMem.."* ❩\n⌁︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⌁︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الوقت ↫ "..os.date("%I:%M%p").."\n⌁︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end end
end,nil)
end,nil)
end,nil)
end,nil)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تفعيل هذه المجموعه بسبب تعطيل البوت الخدمي من قبل المطور الاساسي', 1, 'md') 
end 
end 
if msg.date_ and msg.date_ < tonumber(os.time() - 30) then
print("*( OLD MESSAGE )*")
return false
end
tdcli_function({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,data) 
if data.username_ ~= false then
DevAbs:set(HASSAN..'Save:UserName'..msg.sender_user_id_,data.username_)
end;end,nil) 
local ReFalse = tostring(msg.chat_id_)
if not DevAbs:sismember(HASSAN.."Abs:Groups",msg.chat_id_) and not ReFalse:match("^(%d+)") and not SudoBot(msg) then
print("Return False [ Not Enable ]")
return false
end
-------- MSG TYPES ---------
if msg.content_.ID == "MessageChatJoinByLink" and not VipMem(msg) then 
if DevAbs:get(HASSAN.."Abs:Lock:Join"..msg.chat_id_) then
ChatKick(msg.chat_id_,msg.sender_user_id_) 
return false  
end
end
if msg.content_.ID == "MessagePhoto" then
if not Manager(msg) then 
local filter = DevAbs:smembers(HASSAN.."Abs:FilterPhoto"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.photo_.id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙الصوره التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageAnimation" then
if not Manager(msg) then 
local filter = DevAbs:smembers(HASSAN.."Abs:FilterAnimation"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.animation_.animation_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙المتحركه التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageSticker" then
if not Manager(msg) then 
local filter = DevAbs:smembers(HASSAN.."Abs:FilterSteckr"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.sticker_.sticker_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙الملصق الذي ارسلته تم منعه من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false   
end
end
end
end
if ((not d) and chat) then
if msg.content_.ID == "MessageText" then
do_notify (chat.title_, msg.content_.text_)
else
do_notify (chat.title_, msg.content_.ID)
end
end
if text and text:match("^(.*)$") then
local DelGpRed = DevAbs:get(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if DelGpRed == 'DelGpRed' then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙الكلمه ↫ '..msg.content_.text_..' تم حذفها',  1, "html")
DevAbs:del(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevAbs:srem(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_..'',msg.content_.text_)
return false
end
end
if text and text:match("^(.*)$") then
local DelAllRed = DevAbs:get(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
if DelAllRed == 'DelAllRed' then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙الكلمه ↫ '..msg.content_.text_..' تم حذفها',  1, "html")
DevAbs:del(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
DevAbs:del(HASSAN.."Abs:Gif:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Voice:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Audio:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Photo:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Stecker:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Video:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:File:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Text:AllRed"..msg.content_.text_)
DevAbs:del(HASSAN.."Abs:Sudo:AllRed",msg.content_.text_)
return false
end
end
if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then 
local SaveGpRed = DevAbs:get(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SaveGpRed == 'SaveGpRed' then 
if text == 'الغاء' then
local DelManagerRep = DevAbs:get(HASSAN..'DelManagerRep'..msg.chat_id_..'')
DevAbs:srem(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_..'',DelManagerRep)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ الرد', 1, 'md')
DevAbs:del(HASSAN..'Abs:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_)
DevAbs:del(HASSAN..'DelManagerRep'..msg.chat_id_..'')
return false
end
DevAbs:del(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
local SaveGpRed = DevAbs:get(HASSAN..'Abs:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
if msg.content_.video_ then DevAbs:set(HASSAN..'Abs:Video:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then DevAbs:set(HASSAN..'Abs:File:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then DevAbs:set(HASSAN..'Abs:Stecker:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.sticker_.sticker_.persistent_id_) 
end 
if msg.content_.voice_ then DevAbs:set(HASSAN..'Abs:Voice:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.voice_.voice_.persistent_id_) 
end
if msg.content_.audio_ then DevAbs:set(HASSAN..'Abs:Audio:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.audio_.audio_.persistent_id_) 
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_group = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_group = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_group = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_group = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevAbs:set(HASSAN..'Abs:Photo:GpRed'..SaveGpRed..''..msg.chat_id_..'', photo_in_group) 
end
if msg.content_.animation_ then DevAbs:set(HASSAN..'Abs:Gif:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.animation_.animation_.persistent_id_) 
end 
if msg.content_.text_ then
DevAbs:set(HASSAN..'Abs:Text:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.text_)
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ الرد الجديد', 1, 'md') 
DevAbs:del(HASSAN..'Abs:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevAbs:del(HASSAN..'DelManagerRep'..msg.chat_id_..'')
return false 
end 
end
if msg.content_.text_ and not DevAbs:get(HASSAN..'Abs:Lock:GpRed'..msg.chat_id_) then 
if DevAbs:get(HASSAN..'Abs:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN..'Abs:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAbs:get(HASSAN..'Abs:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN..'Abs:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAbs:get(HASSAN..'Abs:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN..'Abs:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAbs:get(HASSAN..'Abs:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN..'Abs:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAbs:get(HASSAN..'Abs:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN..'Abs:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevAbs:get(HASSAN..'Abs:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN..'Abs:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevAbs:get(HASSAN..'Abs:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN..'Abs:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..''))
end
if DevAbs:get(HASSAN..'Abs:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then
function HASSANTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevAbs:get(HASSAN..'Abs:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevAbs:get(HASSAN..'Abs:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, HASSANTEAM)
end
end
text = msg.content_.text_
if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then
local SaveAllRed = DevAbs:get(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
if SaveAllRed == 'SaveAllRed' then
if text == 'الغاء' then
local DelSudoRep = DevAbs:get(HASSAN..'DelSudoRep')
DevAbs:del(HASSAN.."Abs:Sudo:AllRed",DelSudoRep)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ الرد', 1, 'md')
DevAbs:del(HASSAN.."Abs:Add:AllText"..msg.sender_user_id_)
DevAbs:del(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
DevAbs:del(HASSAN.."DelSudoRep")
return false
end
DevAbs:del(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
local SaveAllRed = DevAbs:get(HASSAN.."Abs:Add:AllText"..msg.sender_user_id_)
if msg.content_.video_ then
DevAbs:set(HASSAN.."Abs:Video:AllRed"..SaveAllRed, msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then
DevAbs:set(HASSAN.."Abs:File:AllRed"..SaveAllRed, msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then
DevAbs:set(HASSAN.."Abs:Stecker:AllRed"..SaveAllRed, msg.content_.sticker_.sticker_.persistent_id_)
end
if msg.content_.voice_ then
DevAbs:set(HASSAN.."Abs:Voice:AllRed"..SaveAllRed, msg.content_.voice_.voice_.persistent_id_)
end
if msg.content_.audio_ then
DevAbs:set(HASSAN.."Abs:Audio:AllRed"..SaveAllRed, msg.content_.audio_.audio_.persistent_id_)
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_all_groups = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_all_groups = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_all_groups = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_all_groups = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevAbs:set(HASSAN.."Abs:Photo:AllRed"..SaveAllRed, photo_in_all_groups)
end
if msg.content_.animation_ then
DevAbs:set(HASSAN.."Abs:Gif:AllRed"..SaveAllRed, msg.content_.animation_.animation_.persistent_id_)
end
if msg.content_.text_ then
DevAbs:set(HASSAN.."Abs:Text:AllRed"..SaveAllRed, msg.content_.text_)
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ الرد الجديد', 1, 'md') 
DevAbs:del(HASSAN.."Abs:Add:AllText"..msg.sender_user_id_)
DevAbs:del(HASSAN..'DelSudoRep')
return false end end
if msg.content_.text_ and not DevAbs:get(HASSAN..'Abs:Lock:AllRed'..msg.chat_id_) then
if DevAbs:get(HASSAN.."Abs:Video:AllRed"..msg.content_.text_) then
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN.."Abs:Video:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:File:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN.."Abs:File:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:Voice:AllRed"..msg.content_.text_)  then
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN.."Abs:Voice:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:Audio:AllRed"..msg.content_.text_)  then
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN.."Abs:Audio:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:Photo:AllRed"..msg.content_.text_)  then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN.."Abs:Photo:AllRed"..msg.content_.text_))
end
if  DevAbs:get(HASSAN.."Abs:Gif:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevAbs:get(HASSAN.."Abs:Gif:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:Stecker:AllRed"..msg.content_.text_) then
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevAbs:get(HASSAN.."Abs:Stecker:AllRed"..msg.content_.text_))
end
if DevAbs:get(HASSAN.."Abs:Text:AllRed"..msg.content_.text_) then
function HASSANTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevAbs:get(HASSAN..'Abs:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevAbs:get(HASSAN.."Abs:Text:AllRed"..msg.content_.text_)
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, HASSANTEAM)
end
end 
--       Spam Send        --
function NotSpam(msg,Type)
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,dp) 
local GetName = '['..CatchName(dp.first_name_,15)..'](tg://user?id='..dp.id_..')'
if Type == "kick" then 
ChatKick(msg.chat_id_,msg.sender_user_id_) 
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⌁︙العضو ↫ '..GetName..' \n⌁︙قام بالتكرار المحدد تم طرده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end 
if Type == "del" then 
DeleteMessage(msg.chat_id_,{[0] = msg.id_})   
return false  
end 
if Type == "keed" and not DevAbs:sismember(HASSAN..'Abs:Tkeed:'..msg.chat_id_, msg.sender_user_id_) then
https.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..msg.sender_user_id_.."") 
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⌁︙العضو ↫ '..GetName..' \n⌁︙قام بالتكرار المحدد تم تقيده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end  
if Type == "mute" and not DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, msg.sender_user_id_) then
DevAbs:sadd(HASSAN..'Abs:Muted:'..msg.chat_id_,msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⌁︙العضو ↫ '..GetName..' \n⌁︙قام بالتكرار المحدد تم كتمه '
SendText(msg.chat_id_,Text,0,'md')
return false  
end
end,nil)
end  
--  end functions HASSAN --
--       Spam Check       --
if not VipMem(msg) and msg.content_.ID ~= "MessageChatAddMembers" and DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") then 
if msg.sender_user_id_ ~= HASSAN then
floods = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") or "nil"
Num_Msg_Max = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
Time_Spam = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 5
local post_count = tonumber(DevAbs:get(HASSAN.."Abs:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_) or 0)
if post_count > tonumber(DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5) then 
local ch = msg.chat_id_
local type = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") 
NotSpam(msg,type)  
end
DevAbs:setex(HASSAN.."Abs:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_, tonumber(DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 3), post_count+1) 
local edit_id = data.text_ or "nil"  
Num_Msg_Max = 5
if DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam") then
Num_Msg_Max = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam") 
end
if DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") then
Time_Spam = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") 
end 
end
end 
----- START MSG CHECKS -----
if msg.sender_user_id_ and Ban(msg.sender_user_id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and BanAll(msg.sender_user_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and Muted(msg.sender_user_id_, msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and MuteAll(msg.sender_user_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.content_.ID == "MessagePinMessage" then
if Constructor(msg) or tonumber(msg.sender_user_id_) == tonumber(HASSAN) then
DevAbs:set(HASSAN..'Abs:PinnedMsg'..msg.chat_id_,msg.content_.message_id_)
else
local pin_id = DevAbs:get(HASSAN..'Abs:PinnedMsg'..msg.chat_id_)
if pin_id and DevAbs:get(HASSAN..'Abs:Lock:Pin'..msg.chat_id_) then
pinmsg(msg.chat_id_,pin_id,0)
end
end
end
if DevAbs:get(HASSAN..'Abs:viewget'..msg.sender_user_id_) then
if not msg.forward_info_ then
DevAbs:del(HASSAN..'Abs:viewget'..msg.sender_user_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عدد مشاهدات المنشور هي ↫ ('..msg.views_..')', 1, 'md')
DevAbs:del(HASSAN..'Abs:viewget'..msg.sender_user_id_)
end
end
--         Photo          --
if msg.content_.ID == "MessagePhoto" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Photo'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--        Markdown        --
elseif not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
if DevAbs:get(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_) then
if not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--        Document        --
elseif msg.content_.ID == "MessageDocument" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Document'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--         Inline         --
elseif msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" and msg.via_bot_user_id_ ~= 0 then
if not VipMem(msg) then
if DevAbs:get(HASSAN..'Abs:Lock:Inline'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--        Sticker         --
elseif msg.content_.ID == "MessageSticker" then
if not VipMem(msg) then
if DevAbs:get(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
elseif msg.content_.ID == "MessageChatJoinByLink" then
if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
function get_welcome(extra,result,success)
if DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_) then
text = DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_)
else
text = '• نورت حبي \n• [firstname lastname] \n• [@username]'
end
local text = text:gsub('firstname',(result.first_name_ or ''))
local text = text:gsub('lastname',(result.last_name_ or ''))
local text = text:gsub('username',(result.username_ or 'GO_XXO'))
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end 
if DevAbs:get(HASSAN.."Abs:Lock:Welcome"..msg.chat_id_) then
getUser(msg.sender_user_id_,get_welcome)
end
--      New User Add      --
elseif msg.content_.ID == "MessageChatAddMembers" then
if not DevAbs:get(HASSAN..'Abs:Lock:BotWelcome') then 
tdcli_function ({ID = "GetUserProfilePhotos",user_id_ = HASSAN,offset_ = 0,limit_ = 1},function(extra,abbas,success) 
for i=0,#msg.content_.members_ do    
BotWelcome = msg.content_.members_[i].id_    
if BotWelcome and BotWelcome == tonumber(HASSAN) then 
if DevAbs:sismember(HASSAN..'Abs:Groups',msg.chat_id_) then
BotText = "مفعله في السابق\n⌁︙ارسل ↫ الاوامر واستمتع بالمميزيات"
else 
BotText = "معطله يجب رفعي مشرف\n⌁︙بعد ذلك يرجى ارسال امر ↫ تفعيل\n⌁︙سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
local AbsText = (DevAbs:get(HASSAN.."Abs:Text:BotWelcome") or "⌁︙مرحبا انا بوت اسمي "..NameBot.."\n⌁︙حالة المجموعه ↫ "..BotText.."\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉")
local AbsPhoto = (DevAbs:get(HASSAN.."Abs:Photo:BotWelcome") or abbas.photos_[0].sizes_[1].photo_.persistent_id_)
if DevAbs:get(HASSAN.."Abs:Photo:BotWelcome") or abbas.photos_[0] then
sendPhoto(msg.chat_id_,msg.id_,0,1,nil,AbsPhoto,AbsText)
else 
send(msg.chat_id_,msg.id_,AbsText)
end 
end   
end
end,nil)
end
if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and Ban(msg.content_.members_[0].id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and BanAll(msg.content_.members_[0].id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if DevAbs:get(HASSAN.."Abs:Lock:Welcome"..msg.chat_id_) then
if DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_) then
text = DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_)
else
text = '• نورت حبي \n• [firstname lastname] \n• [@username]'
end
local text = text:gsub('firstname',(msg.content_.members_[0].first_name_ or ''))
local text = text:gsub('lastname',(msg.content_.members_[0].last_name_ or ''))
local text = text:gsub('username',(msg.content_.members_[0].username_ or 'GO_XXO'))
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
--        Contact         --
elseif msg.content_.ID == "MessageContact" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Contact'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--         Audio          --
elseif msg.content_.ID == "MessageAudio" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Music'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--         Voice          --
elseif msg.content_.ID == "MessageVoice" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Voice'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--        Location        --
elseif msg.content_.ID == "MessageLocation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Location'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--         Video          --
elseif msg.content_.ID == "MessageVideo" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Videos'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--          Gif           --
elseif msg.content_.ID == "MessageAnimation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--         Text           --
elseif msg.content_.ID == "MessageText" then
if not VipMem(msg) then
Filters(msg,text)
if msg.forward_info_ then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevAbs:get(HASSAN..'Abs:Lock:Text'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.text_:match("@") then
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("#") then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") or text:match(".[Xx][Yy][Zz]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[\216-\219][\128-\191]") then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_ then
local _nl, ctrl_chars = string.gsub(text, '%c', '')
local _nl, real_digits = string.gsub(text, '%d', '')
if not DevAbs:get(HASSAN..'Abs:Spam:Text'..msg.chat_id_) then
sens = 400
else
sens = tonumber(DevAbs:get(HASSAN..'Abs:Spam:Text'..msg.chat_id_))
end
if DevAbs:get(HASSAN..'Abs:Lock:Spam'..msg.chat_id_) and string.len(msg.content_.text_) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[A-Z]") or msg.content_.text_:match("[a-z]") then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevAbs:get(HASSAN.."Abs:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) then
if text == "الغاء" then
send(msg.chat_id_,msg.id_,"⌁︙تم الغاء حفظ الرابط")       
DevAbs:del(HASSAN.."Abs:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false
end
if msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)") then
local Link = msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)")
DevAbs:set(HASSAN.."Abs:Groups:Links"..msg.chat_id_,Link)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ الرابط بنجاح', 1, 'md')
DevAbs:del(HASSAN.."Abs:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false 
end
end
local msg = data.message_
text = msg.content_.text_
if text and Constructor(msg) then 
if DevAbs:get('HASSANTEAM:'..HASSAN.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevAbs:del('HASSANTEAM:'..HASSAN..'id:user'..msg.chat_id_)  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء الامر', 1, 'md')
DevAbs:del('HASSANTEAM:'..HASSAN.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAbs:del('HASSANTEAM:'..HASSAN.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevAbs:get('HASSANTEAM:'..HASSAN..'id:user'..msg.chat_id_)  
DevAbs:incrby(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..iduserr,numadded)
Dev_Abs(msg.chat_id_, msg.id_,  1, "⌁︙تم اضافة "..numadded..' رساله', 1, 'md')
DevAbs:del('HASSANTEAM:'..HASSAN..'id:user'..msg.chat_id_) 
end
end
if text and Constructor(msg) then 
if DevAbs:get('HASSANTEAM:'..HASSAN.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevAbs:del('HASSANTEAM:'..HASSAN..'ids:user'..msg.chat_id_)  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء الامر', 1, 'md')
DevAbs:del('HASSANTEAM:'..HASSAN.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAbs:del('HASSANTEAM:'..HASSAN.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevAbs:get('HASSANTEAM:'..HASSAN..'ids:user'..msg.chat_id_)  
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..iduserr,numadded)  
Dev_Abs(msg.chat_id_, msg.id_,  1, "⌁︙تم اضافة "..numadded..' نقطه', 1, 'md')
DevAbs:del('HASSANTEAM:'..HASSAN..'ids:user'..msg.chat_id_)  
end
end
if text and (text:match("لعن الله المهدي") or text:match("نرجس الزانية") or text:match("لعن الله الشيعة") or text:match("لعن الله الروافض") or text:match("لعن الله السيستاني") or text:match("السيكستاني") or text:match("الشيشاني") or text:match("كسمك") or text:match("لعن الله المراجع") or text:match("كسمكم") or text:match("نرجس القحبه") or text:match("منيوج") or text:match("كحبه") or text:match("كحاب") or text:match("الكحبه") or text:match("نرجس القحبة") or text:match("طيزك") or text:match("كس امك") or text:match("لعنة الله على نرجس") or text:match("كس اختك")) then
if not DevAbs:get(HASSAN.."Abs:Lock:Fshar"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙ممنوع سب ولعن الرموز هُنا قال النبي صلى الله عليه وسلم ليس المؤمن بالطّعّان ولا اللّعّان ولا الفاحش ولا البذيء وقال أيضا لا تلاعنوا بلعنة الله ولا بغضبه ولا بالنار وقال أيضا إِنَّ اللَّعَّانِينَ لا يَكُونُونَ شُهَدَاءَ وَلا شُفَعَاءَ يَوْمَ الْقِيَامة اتبعو أخلاق نبيكم محمد صل الله عليه وآله وسلم")  
end end
if text and (text:match("صهاك") or text:match("عمر جبان") or text:match("لعن الله نرجس الزانية") or text:match("صهوكي") or text:match("ابناء الزنا") or text:match("أبناء الزنا") or text:match("لعنكم الله") or text:match("لعن") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("لعن الله المسردب") or text:match("حليب عيوشه") or text:match("حليب") or text:match("ممه") or text:match("عمر منيوج") or text:match("عمر ديوث") or text:match("رضاع الرجال") or text:match("رضاعة") or text:match("مرضعة") or text:match("مرضعه") or text:match("نزل بعائشه") or text:match("نزل بعائشة") or text:match("لعن الله هند") or text:match("اكلت الاكباد هند") or text:match("معاويه يشرب خمر") or text:match("معاوية يشرب عرك") or text:match("يزيد يشرب عرك") or text:match("لعن الله ابوبكر") or text:match("عمر منكوح")) then
if DevAbs:get(HASSAN.."Abs:Lock:Farsi"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})ممنوع سب ولعن الرموز هُنا قال النبي صلى الله عليه وسلم ليس المؤمن بالطّعّان ولا اللّعّان ولا الفاحش ولا البذيء وقال أيضا لا تلاعنوا بلعنة الله ولا بغضبه ولا بالنار وقال أيضا إِنَّ اللَّعَّانِينَ لا يَكُونُونَ شُهَدَاءَ وَلا شُفَعَاءَ يَوْمَ الْقِيَامة اتبعو أخلاق نبيكم محمد صل الله عليه وآله وسلم")  
end end
if text and (text:match("رضاع الزلم") or text:match("لعنالله ابوبكر") or text:match("لعنت الله ابن صهاك") or text:match(" ابن صهاك منكوح") or text:match("صهاكك") or text:match("رجل نزل بعائشة") or text:match("ممية") or text:match("مميه") or text:match("عمر منكوح") or text:match("لعن الله ال اميه") or text:match("عمر منافق") or text:match("معاويه يحتسي الخمر ") or text:match("يزيد يحتسي الخمر") or text:match("نزل بعائشه") or text:match("مک") or text:match("زدن") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("باید") or text:match("امك منكوحه") or text:match("نرجوسة") or text:match("لعن الله نرجوسه") or text:match("لعن الله عيوشة") or text:match("لعن الله عيوشه") or text:match("المهدي المسردب") or text:match("المهدي الجبان")) then
if DevAbs:get(HASSAN.."Abs:Lock:FarsiBan"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ChatKick(msg.chat_id_, msg.sender_user_id_)
end end 
if text and (text:match("لعن الله ال امية") or text:match("رضاع الكبير") or text:match("يزيد يشرب الخمر") or text:match("عمر منافق") or text:match("لعن الله ابن تيمية") or text:match("اكلت الاكباد") or text:match("ابناء رضاع الكبير") or text:match("امكم مرضعة الكبار") or text:match("صهاك") or text:match("عائشة قحبه") or text:match("عائشة كحبه") or text:match("عائشه كحبه") or text:match("عائشة كحبة") or text:match("لعن الله ابو هريرة") or text:match("لعن الله خالد ابن الوليد") or text:match("لعن الله خالد") or text:match("لعن الله ابن تيمية")) then
if not DevAbs:get(HASSAN.."Abs:Lock:Kfr"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙ممنوع سب ولعن الرموز هُنا قال النبي صلى الله عليه وسلم ليس المؤمن بالطّعّان ولا اللّعّان، ولا الفاحش ولا البذيء وقال أيضا لا تلاعنوا بلعنة الله ولا بغضبه، ولا بالنار وقال أيضا إِنَّ اللَّعَّانِينَ لا يَكُونُونَ شُهَدَاءَ وَلا شُفَعَاءَ يَوْمَ الْقِيَامة اتبعو أخلاق نبيكم محمد صل الله عليه وآله وسلم") 
end end
if text and (text:match("بكس عائشة") or text:match("عير بعائشة") or text:match("لعن الله عمر") or text:match("لعن الله عثمان") or text:match("لعن الله ابو بكر") or text:match("لعن الله معاوية") or text:match("لعن الله يزيد") or text:match("لعن الله عائشة") or text:match("لعن الله عائشه") or text:match("لعنت الله على عائشه") or text:match("عيوشه") or text:match("عيوشة") or text:match("لعنت الله على عاىشة")) then
if not DevAbs:get(HASSAN.."Abs:Lock:Taf"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⌁︙ممنوع سب ولعن الرموز هُنا قال النبي صلى الله عليه وسلم ليس المؤمن بالطّعّان ولا اللّعّان ولا الفاحش ولا البذيء وقال أيضا لا تلاعنوا بلعنة الله ولا بغضبه ولا بالنار وقال أيضاإِنَّ اللَّعَّانِينَ لا يَكُونُونَ شُهَدَاءَ وَلا شُفَعَاءَ يَوْمَ الْقِيَامة اتبعو أخلاق نبيكم محمد صل الله عليه وآله وسلم") 
end end
if SecondSudo(msg) then
if text == 'جلب نسخه الكروبات' and ChCheck(msg) or text == 'جلب نسخه احتياطيه' and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'Abs:Groups') 
local BotName = (DevAbs:get(HASSAN.."Abs:NameBot") or 'اهل البيت بين الاتباع والابتداع')
local GetJson = '{"BotId": '..HASSAN..',"BotName": "'..BotName..'","GroupsList":{'  
for k,v in pairs(List) do 
LinkGroups = DevAbs:get(HASSAN.."Abs:Groups:Links"..v)
Welcomes = DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..v) or ''
AbsConstructors = DevAbs:smembers(HASSAN..'Abs:AbsConstructor:'..v)
Constructors = DevAbs:smembers(HASSAN..'Abs:BasicConstructor:'..v)
BasicConstructors = DevAbs:smembers(HASSAN..'Abs:Constructor:'..v)
Managers = DevAbs:smembers(HASSAN..'Abs:Managers:'..v)
Admis = DevAbs:smembers(HASSAN..'Abs:Admins:'..v)
Vips = DevAbs:smembers(HASSAN..'Abs:VipMem:'..v)
if k == 1 then
GetJson = GetJson..'"'..v..'":{'
else
GetJson = GetJson..',"'..v..'":{'
end
if #Vips ~= 0 then 
GetJson = GetJson..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Admis ~= 0 then
GetJson = GetJson..'"Admis":['
for k,v in pairs(Admis) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Managers ~= 0 then
GetJson = GetJson..'"Managers":['
for k,v in pairs(Managers) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Constructors ~= 0 then
GetJson = GetJson..'"Constructors":['
for k,v in pairs(Constructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #BasicConstructors ~= 0 then
GetJson = GetJson..'"BasicConstructors":['
for k,v in pairs(BasicConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #AbsConstructors ~= 0 then
GetJson = GetJson..'"AbsConstructors":['
for k,v in pairs(AbsConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if LinkGroups then
GetJson = GetJson..'"LinkGroups":"'..LinkGroups..'",'
end
GetJson = GetJson..'"Welcomes":"'..Welcomes..'"}'
end
GetJson = GetJson..'}}'
local File = io.open('./'..HASSAN..'.json', "w")
File:write(GetJson)
File:close()
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, './'..HASSAN..'.json', '⌁︙يحتوي الملف على ↫ '..#List..' مجموعه',dl_cb, nil)
io.popen('rm -rf ./'..HASSAN..'.json')
end
if text == 'رفع النسخه' and tonumber(msg.reply_to_message_id_) > 0 or text == 'رفع النسخه الاحتياطيه' and tonumber(msg.reply_to_message_id_) > 0 then   
function by_reply(extra, result, success)   
if result.content_.document_ then 
local ID_FILE = result.content_.document_.document_.persistent_id_ 
local File_Name = result.content_.document_.file_name_
AddFile(msg,msg.chat_id_,ID_FILE,File_Name)
end   
end
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if DevAbs:get(HASSAN.."SET:GAME"..msg.chat_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 6 then
Dev_Abs( msg.chat_id_, msg.id_, 1,"⌁︙يوجد فقط ( 6 ) اختيارات\n⌁︙ارسل اختيارك مره اخرى", 1, "md")    
return false  end 
local GETNUM = DevAbs:get(HASSAN.."GAMES"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevAbs:del(HASSAN.."SET:GAME"..msg.chat_id_)   
Dev_Abs( msg.chat_id_, msg.id_, 1,'⌁︙*المحيبس باليد رقم* ↫ '..NUM..'\n⌁︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, "md") 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevAbs:del(HASSAN.."SET:GAME"..msg.chat_id_)   
Dev_Abs( msg.chat_id_, msg.id_, 1,'⌁︙*المحيبس باليد رقم* ↫ '..GETNUM..'\n⌁︙*للاسف لقد خسرت حاول مره اخرى للعثور على المحيبس*', 1, "md")
end
end
end
if DevAbs:get(HASSAN..'DevAbs4'..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_, "⌁︙تم الغاء الامر")
DevAbs:del(HASSAN..'DevAbs4'..msg.sender_user_id_)
return false  end 
DevAbs:del(HASSAN..'DevAbs4'..msg.sender_user_id_)
local username = string.match(text, "@[%a%d_]+") 
tdcli_function({ID = "SearchPublicChat",username_ = username},function(arg,data) 
if data and data.message_ and data.message_ == "USERNAME_NOT_OCCUPIED" then 
send(msg.chat_id_, msg.id_, '⌁︙المعرف لا يوجد فيه قناة')
return false  end
if data and data.type_ and data.type_.ID and data.type_.ID == 'PrivateChatInfo' then
send(msg.chat_id_, msg.id_, '⌁︙عذرا لا يمكنك وضع معرف حسابات في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == true then
send(msg.chat_id_, msg.id_, '⌁︙عذرا لا يمكنك وضع معرف مجموعه في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == false then
if data and data.type_ and data.type_.channel_ and data.type_.channel_.ID and data.type_.channel_.status_.ID == 'ChatMemberStatusEditor' then
send(msg.chat_id_, msg.id_,'⌁︙البوت ادمن في القناة \n⌁︙تم تفعيل الاشتراك الاجباري \n⌁︙ايدي القناة ↫ '..data.id_..'\n⌁︙معرف القناة ↫ [@'..data.type_.channel_.username_..']')
DevAbs:set(HASSAN..'DevAbs2',data.id_)
DevAbs:set(HASSAN..'DevAbs3','@'..data.type_.channel_.username_)
else
send(msg.chat_id_, msg.id_,'⌁︙عذرا البوت ليس ادمن في القناة')
end
return false  
end
end,nil)
end
if DevAbs:get(HASSAN.."Abs:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
DevAbs:del(HASSAN.."Abs:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء الامر', 1, 'md')
return false 
end 
DevAbs:del(HASSAN.."Abs:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
local DevText = msg.content_.text_:match("(.*)")
DevAbs:set(HASSAN.."DevText", DevText)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ كليشة المطور", 1, "md")
end
if DevAbs:get(HASSAN..'Abs:NameBot'..msg.sender_user_id_) == 'msg' then
if text and text:match("^الغاء$") then 
DevAbs:del(HASSAN..'Abs:NameBot'..msg.sender_user_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء الامر', 1, 'md')
return false 
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ اسم البوت ', 1, 'html')
DevAbs:del(HASSAN..'Abs:NameBot'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:NameBot', text)
return false 
end
if text == "الرابط" then
if not DevAbs:get(HASSAN.."Abs:Lock:GpLinks"..msg.chat_id_) then 
if DevAbs:get(HASSAN.."Abs:Groups:Links"..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙𝒈𝒓𝒐𝒖𝒑 𝒍𝒊𝒏𝒌 ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..DevAbs:get(HASSAN.."Abs:Groups:Links"..msg.chat_id_), 1, "html")
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لايوجد رابط ارسل ↫ ضع رابط او ارسل ↫ انشاء رابط للانشاء', 1, 'md')
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙جلب رابط المجموعه معطل', 1, 'md')
end
end
if ChatType == 'sp' or ChatType == 'gp'  then
if text == 'بوت' or text == 'بوتت' then 
NameBot = (DevAbs:get(HASSAN..'Abs:NameBot') or 'اهل البيت بين الاتباع والابتداع')
local HASSANTEAM = {"لتكول بوت اسمي "..NameBot.." 😒🔪","اسمي "..NameBot.." 😚♥️","عندي اسم 😒💔","نادوني "..NameBot.."  بوت 😒🔪","انت البوت لك 😒💔"} 
DevAbs2 = math.random(#HASSANTEAM) 
Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM[DevAbs2] , 1, 'html') 
return false
end
if text == 'اسم البوت' or text == 'البوت شنو اسمه' or text == 'شسمه البوت' or text == 'البوت شسمه' then
NameBot = (DevAbs:get(HASSAN..'Abs:NameBot') or 'اهل البيت بين الاتباع والابتداع') 
local HASSANTEAM = {"اسمي القميل "..NameBot.." 😚♥️","تفضل البوت شغال"..NameBot.." 😻♥️"} 
DevAbs2 = math.random(#HASSANTEAM) 
Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM[DevAbs2] , 1, 'html') 
return false
end
if text and text == (DevAbs:get(HASSAN..'Abs:NameBot') or 'اهل البيت بين الاتباع والابتداع') then 
NameBot = (DevAbs:get(HASSAN..'Abs:NameBot') or 'اهل البيت بين الاتباع والابتداع')
local namebot = {'😸♥️ تفضل معك انا موجود '..NameBot..' تفضل','نعم 😕😒💔','تفضل '..NameBot..' 😻♥️','حي الله 🤧😒💔'} 
name = math.random(#namebot) 
Dev_Abs(msg.chat_id_, msg.id_, 1, namebot[name] , 1, 'html') 
return false 
end
if text =='نقاطي' and ChCheck(msg) then 
if tonumber((DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لم تربح اي نقطه\n⌁︙ارسل ↫ الالعاب للعب', 1, 'md')
else 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙عدد النقاط التي ربحتها ↫ '..(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_)), 1, 'md')
end
end
if text ==  'حذف رسائلي' and ChCheck(msg) or text ==  'مسح رسائلي' and ChCheck(msg) then DevAbs:del(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف جميع رسائلك', 1, 'md') end
if text ==  'حذف نقاطي' and ChCheck(msg) or text ==  'مسح نقاطي' and ChCheck(msg) then DevAbs:del(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف جميع نقاطك', 1, 'md') end
if text == 'سمايلات' and ChCheck(msg) or text == 'السمايلات' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'🍏','🍎','🍐','🍊','🍋','🍌','🍉','🍇','🍓','🍈','🍒','🍑','🍍','🥥','🥝','🍅','🍆','🥑','🥦','🥒','🌶','🌽','🥕','🥔','🍠','🥐','🍞','🥖','🥨','🧀','🥚','🍳','🥞','🥓','🥩','🍗','🍖','🌭','🍔','🍟','🍕','🥪','🥙','🍼','☕️','🍵','🥤','🍶','🍺','🍻','🏀','⚽️','🏈','⚾️','🎾','🏐','🏉','🎱','🏓','🏸','🥅','🎰','🎮','🎳','🎯','🏆','🎻','🎸','🎺','🥁','🎹','🎼','🎧','🎤','🎬','🎨','🎭','🎪','🛎','📤','🎗','🏵','🎖','🏆','🥌','🛷','🚕','🚗','🚙','🚌','🚎','🏎','🚓','🚑','🚚','🚛','🚜','🇮🇶','⚔️','🛡','🔮','🌡','💣','⏱','🛢','📓','📗','📂','📅','📪','📫','📬','📭','⏰','📺','🎚','☎️','📡'}
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'🍞','🍞')
name = string.gsub(name,'🥖','🥖')
name = string.gsub(name,'🥨','🥨')
name = string.gsub(name,'🧀','🧀')
name = string.gsub(name,'🥚','🥚')
name = string.gsub(name,'🍳','🍳')
name = string.gsub(name,'🥞','🥞')
name = string.gsub(name,'🥓','🥓')
name = string.gsub(name,'🥩','🥩')
name = string.gsub(name,'🍗','🍗')
name = string.gsub(name,'🍖','🍖')
name = string.gsub(name,'🌭','🌭')
name = string.gsub(name,'🍔','🍔')
name = string.gsub(name,'🍟','🍟')
name = string.gsub(name,'🍕','🍕')
name = string.gsub(name,'🥪','🥪')
name = string.gsub(name,'🥙','🥙')
name = string.gsub(name,'🍼','🍼')
name = string.gsub(name,'☕️','☕️')
name = string.gsub(name,'🍵','🍵')
name = string.gsub(name,'🥤','🥤')
name = string.gsub(name,'🍶','🍶')
name = string.gsub(name,'🍺','🍺')
name = string.gsub(name,'🍏','🍏')
name = string.gsub(name,'🍎','🍎')
name = string.gsub(name,'🍐','🍐')
name = string.gsub(name,'🍊','🍊')
name = string.gsub(name,'🍋','🍋')
name = string.gsub(name,'🍌','🍌')
name = string.gsub(name,'🍉','🍉')
name = string.gsub(name,'🍇','🍇')
name = string.gsub(name,'🍓','🍓')
name = string.gsub(name,'🍈','🍈')
name = string.gsub(name,'🍒','🍒')
name = string.gsub(name,'🍑','🍑')
name = string.gsub(name,'🍍','🍍')
name = string.gsub(name,'🥥','🥥')
name = string.gsub(name,'🥝','🥝')
name = string.gsub(name,'🍅','🍅')
name = string.gsub(name,'🍆','🍆')
name = string.gsub(name,'🥑','🥑')
name = string.gsub(name,'🥦','🥦')
name = string.gsub(name,'🥒','🥒')
name = string.gsub(name,'🌶','🌶')
name = string.gsub(name,'🌽','🌽')
name = string.gsub(name,'🥕','🥕')
name = string.gsub(name,'🥔','🥔')
name = string.gsub(name,'🍠','🍠')
name = string.gsub(name,'🥐','🥐')
name = string.gsub(name,'🍻','🍻')
name = string.gsub(name,'🏀','🏀')
name = string.gsub(name,'⚽️','⚽️')
name = string.gsub(name,'🏈','🏈')
name = string.gsub(name,'⚾️','⚾️')
name = string.gsub(name,'🎾','🎾')
name = string.gsub(name,'🏐','🏐')
name = string.gsub(name,'🏉','🏉')
name = string.gsub(name,'🎱','🎱')
name = string.gsub(name,'🏓','🏓')
name = string.gsub(name,'🏸','🏸')
name = string.gsub(name,'🥅','🥅')
name = string.gsub(name,'🎰','🎰')
name = string.gsub(name,'🎮','🎮')
name = string.gsub(name,'🎳','🎳')
name = string.gsub(name,'🎯','🎯')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🎻','🎻')
name = string.gsub(name,'🎸','🎸')
name = string.gsub(name,'🎺','🎺')
name = string.gsub(name,'🥁','🥁')
name = string.gsub(name,'🎹','🎹')
name = string.gsub(name,'🎼','🎼')
name = string.gsub(name,'🎧','🎧')
name = string.gsub(name,'🎤','🎤')
name = string.gsub(name,'🎬','🎬')
name = string.gsub(name,'🎨','🎨')
name = string.gsub(name,'🎭','🎭')
name = string.gsub(name,'🎪','🎪')
name = string.gsub(name,'🛎','🛎')
name = string.gsub(name,'📤','📤')
name = string.gsub(name,'🎗','🎗')
name = string.gsub(name,'🏵','🏵')
name = string.gsub(name,'🎖','🎖')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🥌','🥌')
name = string.gsub(name,'🛷','🛷')
name = string.gsub(name,'🚕','🚕')
name = string.gsub(name,'🚗','🚗')
name = string.gsub(name,'🚙','🚙')
name = string.gsub(name,'🚌','🚌')
name = string.gsub(name,'🚎','🚎')
name = string.gsub(name,'🏎','🏎')
name = string.gsub(name,'🚓','🚓')
name = string.gsub(name,'🚑','🚑')
name = string.gsub(name,'🚚','🚚')
name = string.gsub(name,'🚛','🚛')
name = string.gsub(name,'🚜','🚜')
name = string.gsub(name,'🇮🇶','🇮🇶')
name = string.gsub(name,'⚔️','⚔️')
name = string.gsub(name,'🛡','🛡')
name = string.gsub(name,'🔮','🔮')
name = string.gsub(name,'🌡','🌡')
name = string.gsub(name,'💣','💣')
name = string.gsub(name,'⏱','⏱')
name = string.gsub(name,'🛢','🛢')
name = string.gsub(name,'📒','📒')
name = string.gsub(name,'📗','📗')
name = string.gsub(name,'📅','📆')
name = string.gsub(name,'📪','📪')
name = string.gsub(name,'📫','📫')
name = string.gsub(name,'📬','📬')
name = string.gsub(name,'📭','📭')
name = string.gsub(name,'⏰','⏰')
name = string.gsub(name,'📺','📺')
name = string.gsub(name,'🎚','🎚')
name = string.gsub(name,'☎️','☎️')
HASSANTEAM = '⌁︙اول واحد يدز هذا السمايل يربح ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ سمايلات للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end
if text == 'ترتيب' and ChCheck(msg) or text == 'الترتيب' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'سحور','سياره','استقبال','قنفه','ايفون','بزونه','مطبخ','كرستيانو','دجاجه','مدرسه','الوان','غرفه','ثلاجه','كهوه','سفينه','العراق','محطه','طياره','رادار','منزل','مستشفى','كهرباء','تفاحه','اخطبوط','سلمون','فرنسا','برتقاله','تفاح','مطرقه','بتيته','لهانه','شباك','باص','سمكه','ذباب','تلفاز','حاسوب','انترنيت','ساحه','جسر'};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'سحور','س ر و ح')
name = string.gsub(name,'سياره','ه ر س ي ا')
name = string.gsub(name,'استقبال','ل ب ا ت ق س ا')
name = string.gsub(name,'قنفه','ه ق ن ف')
name = string.gsub(name,'ايفون','و ن ف ا')
name = string.gsub(name,'بزونه','ز و ه ن')
name = string.gsub(name,'مطبخ','خ ب ط م')
name = string.gsub(name,'كرستيانو','س ت ا ن و ك ر ي')
name = string.gsub(name,'دجاجه','ج ج ا د ه')
name = string.gsub(name,'مدرسه','ه م د ر س')
name = string.gsub(name,'الوان','ن ا و ا ل')
name = string.gsub(name,'غرفه','غ ه ر ف')
name = string.gsub(name,'ثلاجه','ج ه ت ل ا')
name = string.gsub(name,'كهوه','ه ك ه و')
name = string.gsub(name,'سفينه','ه ن ف ي س')
name = string.gsub(name,'العراق','ق ع ا ل ر ا')
name = string.gsub(name,'محطه','ه ط م ح')
name = string.gsub(name,'طياره','ر ا ط ي ه')
name = string.gsub(name,'رادار','ر ا ر ا د')
name = string.gsub(name,'منزل','ن ز م ل')
name = string.gsub(name,'مستشفى','ى ش س ف ت م')
name = string.gsub(name,'كهرباء','ر ب ك ه ا ء')
name = string.gsub(name,'تفاحه','ح ه ا ت ف')
name = string.gsub(name,'اخطبوط','ط ب و ا خ ط')
name = string.gsub(name,'سلمون','ن م و ل س')
name = string.gsub(name,'فرنسا','ن ف ر س ا')
name = string.gsub(name,'برتقاله','ر ت ق ب ا ه ل')
name = string.gsub(name,'تفاح','ح ف ا ت')
name = string.gsub(name,'مطرقه','ه ط م ر ق')
name = string.gsub(name,'بتيته','ب ت ت ي ه')
name = string.gsub(name,'لهانه','ه ن ل ه ل')
name = string.gsub(name,'شباك','ب ش ا ك')
name = string.gsub(name,'باص','ص ا ب')
name = string.gsub(name,'سمكه','ك س م ه')
name = string.gsub(name,'ذباب','ب ا ب ذ')
name = string.gsub(name,'تلفاز','ت ف ل ز ا')
name = string.gsub(name,'حاسوب','س ا ح و ب')
name = string.gsub(name,'انترنيت','ا ت ن ر ن ي ت')
name = string.gsub(name,'ساحه','ح ا ه س')
name = string.gsub(name,'جسر','ر ج س')
HASSANTEAM = '⌁︙اول واحد يرتبها يربح ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ ترتيب للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end
if text == 'محيبس' and ChCheck(msg) or text == 'بات' and ChCheck(msg) or text == 'المحيبس' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
Num = math.random(1,6)
DevAbs:set(HASSAN.."GAMES"..msg.chat_id_,Num) 
TEST = [[
➀     ➁     ➂     ➃     ➄     ➅
↓     ↓     ↓     ↓     ↓     ↓
👊 ‹› 👊🏻 ‹› 👊🏼 ‹› 👊🏽 ‹› 👊🏾 ‹› 👊🏿

⌁︙اختر رقم لاستخراج المحيبس
⌁︙الفائز يحصل على (5) نقاط
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, TEST, 1, "md") 
DevAbs:setex(HASSAN.."SET:GAME"..msg.chat_id_, 100, true)  
return false  
end end
if text == 'حزوره' and ChCheck(msg) or text == 'الحزوره' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'الجرس','عقرب الساعه','السمك','المطر','5','الكتاب','البسمار','7','الكعبه','بيت الشعر','لهانه','انا','امي','الابره','الساعه','22','غلط','كم الساعه','البيتنجان','البيض','المرايه','الضوء','الهواء','الضل','العمر','القلم','المشط','الحفره','البحر','الثلج','الاسفنج','الصوت','بلم'};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'الجرس','شيئ اذا لمسته صرخ ما هوه ؟')
name = string.gsub(name,'عقرب الساعه','اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟')
name = string.gsub(name,'السمك','ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟')
name = string.gsub(name,'المطر','شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟')
name = string.gsub(name,'5','ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ')
name = string.gsub(name,'الكتاب','ما الشيئ الذي له اوراق وليس له جذور ؟')
name = string.gsub(name,'البسمار','ما هو الشيئ الذي لا يمشي الا بالضرب ؟')
name = string.gsub(name,'7','عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ')
name = string.gsub(name,'الكعبه','ما هو الشيئ الموجود وسط مكة ؟')
name = string.gsub(name,'بيت الشعر','ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ')
name = string.gsub(name,'لهانه','وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ')
name = string.gsub(name,'انا','ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟')
name = string.gsub(name,'امي','اخت خالك وليست خالتك من تكون ؟ ')
name = string.gsub(name,'الابره','ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ')
name = string.gsub(name,'الساعه','ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟')
name = string.gsub(name,'22','كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ')
name = string.gsub(name,'غلط','ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ')
name = string.gsub(name,'كم الساعه','ما هو السؤال الذي تختلف اجابته دائما ؟')
name = string.gsub(name,'البيتنجان','جسم اسود وقلب ابيض وراس اخظر فما هو ؟')
name = string.gsub(name,'البيض','ماهو الشيئ الذي اسمه على لونه ؟')
name = string.gsub(name,'المرايه','ارى كل شيئ من دون عيون من اكون ؟ ')
name = string.gsub(name,'الضوء','ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟')
name = string.gsub(name,'الهواء','ما هو الشيئ الذي يسير امامك ولا تراه ؟')
name = string.gsub(name,'الضل','ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ')
name = string.gsub(name,'العمر','ما هو الشيء الذي كلما طال قصر ؟ ')
name = string.gsub(name,'القلم','ما هو الشيئ الذي يكتب ولا يقرأ ؟')
name = string.gsub(name,'المشط','له أسنان ولا يعض ما هو ؟ ')
name = string.gsub(name,'الحفره','ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟')
name = string.gsub(name,'البحر','ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟')
name = string.gsub(name,'الثلج','انا ابن الماء فان تركوني في الماء مت فمن انا ؟')
name = string.gsub(name,'الاسفنج','كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟')
name = string.gsub(name,'الصوت','اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟')
name = string.gsub(name,'بلم','حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ')
HASSANTEAM = '⌁︙اول واحد يحلها يربح ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ حزوره للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المعاني' and ChCheck(msg) or text == 'معاني' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'قرد','دجاجه','بطريق','ضفدع','بومه','نحله','ديك','جمل','بقره','دولفين','تمساح','قرش','نمر','اخطبوط','سمكه','خفاش','اسد','فأر','ذئب','فراشه','عقرب','زرافه','قنفذ','تفاحه','باذنجان'}
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum2'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'قرد','🐒')
name = string.gsub(name,'دجاجه','🐔')
name = string.gsub(name,'بطريق','🐧')
name = string.gsub(name,'ضفدع','🐸')
name = string.gsub(name,'بومه','🦉')
name = string.gsub(name,'نحله','🐝')
name = string.gsub(name,'ديك','🐓')
name = string.gsub(name,'جمل','🐫')
name = string.gsub(name,'بقره','🐄')
name = string.gsub(name,'دولفين','🐬')
name = string.gsub(name,'تمساح','🐊')
name = string.gsub(name,'قرش','🦈')
name = string.gsub(name,'نمر','🐅')
name = string.gsub(name,'اخطبوط','🐙')
name = string.gsub(name,'سمكه','🐟')
name = string.gsub(name,'خفاش','🦇')
name = string.gsub(name,'اسد','🦁')
name = string.gsub(name,'فأر','🐭')
name = string.gsub(name,'ذئب','🐺')
name = string.gsub(name,'فراشه','🦋')
name = string.gsub(name,'عقرب','🦂')
name = string.gsub(name,'زرافه','🦒')
name = string.gsub(name,'قنفذ','🦔')
name = string.gsub(name,'تفاحه','🍎')
name = string.gsub(name,'باذنجان','🍆')
HASSANTEAM = '⌁︙ما معنى هذا السمايل :؟ ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum2'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ المعاني للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end 
if text == 'العكس' and ChCheck(msg) or text == 'عكس' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'باي','فهمت','موزين','اسمعك','احبك','موحلو','نضيف','حاره','ناصي','جوه','سريع','ونسه','طويل','سمين','ضعيف','شريف','شجاع','رحت','عدل','نشيط','شبعان','موعطشان','خوش ولد','اني','هادئ'}
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum3'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'باي','هلو')
name = string.gsub(name,'فهمت','مافهمت')
name = string.gsub(name,'موزين','زين')
name = string.gsub(name,'اسمعك','ماسمعك')
name = string.gsub(name,'احبك','ماحبك')
name = string.gsub(name,'محلو','حلو')
name = string.gsub(name,'نضيف','وصخ')
name = string.gsub(name,'حاره','بارده')
name = string.gsub(name,'ناصي','عالي')
name = string.gsub(name,'جوه','فوك')
name = string.gsub(name,'سريع','بطيء')
name = string.gsub(name,'ونسه','ضوجه')
name = string.gsub(name,'طويل','قزم')
name = string.gsub(name,'سمين','ضعيف')
name = string.gsub(name,'ضعيف','قوي')
name = string.gsub(name,'شريف','كواد')
name = string.gsub(name,'شجاع','جبان')
name = string.gsub(name,'رحت','اجيت')
name = string.gsub(name,'حي','ميت')
name = string.gsub(name,'نشيط','كسول')
name = string.gsub(name,'شبعان','جوعان')
name = string.gsub(name,'موعطشان','عطشان')
name = string.gsub(name,'خوش ولد','موخوش ولد')
name = string.gsub(name,'اني','مطي')
name = string.gsub(name,'هادئ','عصبي')
HASSANTEAM = '⌁︙ما هو عكس كلمة ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum3'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ العكس للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المختلف' and ChCheck(msg) or text == 'مختلف' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'😸','☠','🐼','🐇','🌑','🌚','⭐️','📥','⛈','🌥','⛄️','👨‍🔬','👨‍💻','👨‍🔧','👩‍🍳','🧚‍♀','🧚‍♂️','🧝‍♂','🙍‍♂','🧖‍♂','👬','👨‍👨‍👧','🕓','🕤','⌛️','📅','👩‍⚖️','👨‍🎨'};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum4'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'😸','😹😹😹😸😹😹😹😹')
name = string.gsub(name,'☠️','💀💀💀☠️💀💀💀💀')
name = string.gsub(name,'🐼','👻👻👻👻👻👻👻🐼')
name = string.gsub(name,'🐇','🕊🕊🕊🕊🕊🐇🕊🕊')
name = string.gsub(name,'🌑','🌚🌚🌚🌚🌚🌑🌚🌚')
name = string.gsub(name,'🌚','🌑🌑🌑🌑🌑🌚🌑🌑')
name = string.gsub(name,'⭐️','🌟🌟🌟🌟🌟🌟⭐️🌟')
name = string.gsub(name,'📥','💫💫💫📥💫💫💫💫')
name = string.gsub(name,'⛈','🌨🌨🌨⛈🌨🌨🌨🌨')
name = string.gsub(name,'🌥','⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️')
name = string.gsub(name,'⛄️','☃️☃️☃️☃️⛄️☃️☃️☃️☃️')
name = string.gsub(name,'👨‍🔬','👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬')
name = string.gsub(name,'👨‍💻','👩‍💻👩‍💻👨‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻')
name = string.gsub(name,'👨‍🔧','👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧')
name = string.gsub(name,'👩‍🍳','👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳')
name = string.gsub(name,'🧚‍♀️','🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♀️🧚‍♂️🧚‍♂️')
name = string.gsub(name,'🧚‍♂️','🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♂️🧚‍♀️🧚‍♀️')
name = string.gsub(name,'🧝‍♂️','🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♂️🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♀️')
name = string.gsub(name,'🙍‍♂️','🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️')
name = string.gsub(name,'🧖‍♂️','🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️')
name = string.gsub(name,'👬','👭👭👭👭👬👭👭👭')
name = string.gsub(name,'👨‍👨‍👧','👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦')
name = string.gsub(name,'🕓','🕒🕒🕒🕒🕓🕒🕒🕒')
name = string.gsub(name,'🕤','🕥🕥🕥🕥🕥🕤🕥🕥')
name = string.gsub(name,'⌛️','⏳⏳⏳⏳⏳⌛️⏳⏳')
name = string.gsub(name,'📅','📆📆📆📆📆📅📆📆')
name = string.gsub(name,'👩‍⚖️','👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👩‍⚖️👨‍⚖️👨‍⚖️')
name = string.gsub(name,'👨‍🎨','👩‍🎨👩‍🎨👨‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨')
HASSANTEAM = '⌁︙اول واحد يطلع المختلف يربح\n{'..name..'} '
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum4'..msg.chat_id_) and not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ المختلف للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end  
if text == 'امثله' and ChCheck(msg) or text == 'الامثله' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {
'جوز','ضراطه','الحبل','الحافي','شقره','بيدك','سلايه','النخله','الخيل','حداد','المبلل','يركص','قرد','العنب','العمه','الخبز','بالحصاد','شهر','شكه','يكحله',
};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum5'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'جوز','ينطي ___ للماعنده سنون')
name = string.gsub(name,'ضراطه','الي يسوق المطي يتحمل ___ ')
name = string.gsub(name,'بيدك','اكل ___ محد يفيدك')
name = string.gsub(name,'الحافي','تجدي من ___ نعال')
name = string.gsub(name,'شقره','مع الخيل يا ___ ')
name = string.gsub(name,'النخله','الطول طول ___ والعقل عقل الصخلة')
name = string.gsub(name,'سلايه','بالوجه امراية وبالظهر ___ ')
name = string.gsub(name,'الخيل','من قلة ___ شدو على الچلاب سروج')
name = string.gsub(name,'حداد','موكل من صخم وجهه كال آني ___ ')
name = string.gsub(name,'المبلل',' ___ ما يخاف من المطر')
name = string.gsub(name,'الحبل','اللي تلدغة الحية يخاف من جرة ___ ')
name = string.gsub(name,'يركص','المايعرف ___ يكول الكاع عوجه')
name = string.gsub(name,'العنب','المايلوح ___ يكول حامض')
name = string.gsub(name,'العمه','___ إذا حبت الچنة ابليس يدخل الجنة')
name = string.gsub(name,'الخبز','انطي ___ للخباز حتى لو ياكل نصه')
name = string.gsub(name,'بالحصاد','اسمة ___ ومنجله مكسور')
name = string.gsub(name,'شهر','امشي ___ ولا تعبر نهر')
name = string.gsub(name,'شكه','يامن تعب يامن ___ يا من على الحاضر لكة')
name = string.gsub(name,'القرد',' ___ بعين امه غزال')
name = string.gsub(name,'يكحله','اجه ___ عماها')
HASSANTEAM = '⌁︙اكمل المثال التالي ↫ ['..name..']'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum5'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAbs:del(HASSAN..'Abs:GameNum5'..msg.chat_id_)
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ امثله للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end  
if text == 'رياضيات' and ChCheck(msg) or text == 'الرياضيات' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'9','46','2','9','5','4','25','10','17','15','39','5','16',};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum6'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'9','7 + 2 = ?')
name = string.gsub(name,'46','41 + 5 = ?')
name = string.gsub(name,'2','5 - 3 = ?')
name = string.gsub(name,'9','5 + 2 + 2 = ?')
name = string.gsub(name,'5','8 - 3 = ?')
name = string.gsub(name,'4','40 ÷ 10 = ?')
name = string.gsub(name,'25','30 - 5 = ?')
name = string.gsub(name,'10','100 ÷ 10 = ?')
name = string.gsub(name,'17','10 + 5 + 2 = ?')
name = string.gsub(name,'15','25 - 10 = ?')
name = string.gsub(name,'39','44 - 5 = ?')
name = string.gsub(name,'5','12 + 1 - 8 = ?')
name = string.gsub(name,'16','16 + 16 - 16 = ?')
HASSANTEAM = '⌁︙اكمل المعادله التاليه ↫ ⤈\n{'..name..'} '
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum6'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAbs:del(HASSAN..'Abs:GameNum6'..msg.chat_id_)
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ رياضيات للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end  
if text == 'الانكليزي' and ChCheck(msg) or text == 'الانجليزيه' and ChCheck(msg) or text == 'انكليزيه' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'معلومات','قنوات','مجموعات','كتاب','تفاحه','سدني','نقود','اعلم','ذئب','تمساح','ذكي','شاطئ','غبي',};
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum7'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'ذئب','Wolf')
name = string.gsub(name,'معلومات','Information')
name = string.gsub(name,'قنوات','Channels')
name = string.gsub(name,'مجموعات','Groups')
name = string.gsub(name,'كتاب','Book')
name = string.gsub(name,'تفاحه','Apple')
name = string.gsub(name,'نقود','money')
name = string.gsub(name,'اعلم','I know')
name = string.gsub(name,'تمساح','crocodile')
name = string.gsub(name,'شاطئ','Beach')
name = string.gsub(name,'غبي','Stupid')
name = string.gsub(name,'صداقه','Friendchip')
HASSANTEAM = '⌁︙ما معنى كلمة ↫ '..name
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum7'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAbs:del(HASSAN..'Abs:GameNum7'..msg.chat_id_)
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ انكليزيه للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end  
if text == 'اسئله' and ChCheck(msg) or text == 'اختيارات' and ChCheck(msg) or text == 'الاسئله' and ChCheck(msg) or text == 'اساله' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs2 = {'النيل','14','الفم','11','30','بوتين','ستيف جوبر','باريس','10','النمل','حرف الواو','الشعر','سحاب','الاسم','ذهب','حرف الام','العزائم','انسات','المنجنيق','اسيا','6','الاسد','مهر','الدولفين','اوروبا','الزئبق','لندن','الانسان','طوكيو','خديجه',}
name = DevAbs2[math.random(#DevAbs2)]
DevAbs:set(HASSAN..'Abs:GameNum8'..msg.chat_id_,name)
DevAbs:del(HASSAN..'Abs:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'النيل','⌁︙ماهو اطول نهر في العالم ؟\n1- النيل\n2- الفرات\n3- نهر الكونغو')
name = string.gsub(name,'14','⌁︙ماعدد عظام الوجه ؟\n1- 15\n2- 13\n3- 14')
name = string.gsub(name,'الفم','⌁︙كراسي بيضاء وجدران ورديه اذا اغلقته اصبح ظلام  فمن اكون ؟\n1- الفم\n2- الاذن\n3- الثلاجه')
name = string.gsub(name,'11','⌁︙كم جزء يحتوي مسلسل وادي الذئاب ؟\n1- 7\n2- 15\n3- 11')
name = string.gsub(name,'30','⌁︙كم جزء يحتوي القران الكريم ؟\n1- 60\n2- 70\n3- 30')
name = string.gsub(name,'بوتين','⌁︙من هوه اغنى رئيس في العالم ؟\n1- ترامب\n2- اوباما\n3- بوتين')
name = string.gsub(name,'ستيف جوبر','⌁︙من هوه مؤسس شركه ابل العالميه  ؟\n1- لاري بايج\n2- بيل جيتس\n3- ستيف جوبر')
name = string.gsub(name,'باريس','ماهي عاصمه فرنسا ؟\n1- باريس\n2- لوين\n3- موسكو')
name = string.gsub(name,'10','⌁︙ماعدد دول العربيه التي توجد في افريقيا ؟\n1- 10\n2- 17\n3- 9')
name = string.gsub(name,'النمل','⌁︙ماهو الحيوان الذي يحمل 50 فوق وزنه ؟\n1- الفيل\n2- النمل\n3- الثور')
name = string.gsub(name,'حرف الواو','⌁︙ماذا يوجد بيني وبينك ؟\n1- الضل\n2- الاخلاق\n3- حرف الواو')
name = string.gsub(name,'الشعر','⌁︙ماهو الشيء النبات ينبت للانسان بلا بذر ؟\n1- الاضافر\n2- الاسنان\n3- الشعر')
name = string.gsub(name,'سحاب','⌁︙ما هو الشّيء الذي يستطيع المشي بدون أرجل والبكاء بدون أعين ؟\n1- سحاب\n2- بئر\n3- نهر')
name = string.gsub(name,'الاسم','⌁︙ما الشيء الذي نمتلكه , لكنّ غيرنا يستعمله أكثر منّا ؟\n1- العمر\n2- ساعه\n3- الاسم')
name = string.gsub(name,'ذهب','⌁︙اصفر اللون سارق عقول اهل الكون وحارمهم لذيذ النوم ؟\n1- نحاس\n2- الماس\n3- ذهب')
name = string.gsub(name,'حرف الام','⌁︙في الليل ثلاثة لكنه في النهار واحده فما هو ؟\n1- حرف الباء\n2- حرف الام\n3- حرف الراء')
name = string.gsub(name,'العزائم','⌁︙على قدر اصل العزم تأتي ؟\n1- العزائم\n2- المكارم\n3- المبائب')
name = string.gsub(name,'انسات','⌁︙ماهي جمع كلمه انسه ؟\n1- سيدات\n2- انسات\n3- قوانص')
name = string.gsub(name,'المنجنيق','⌁︙اله اتسعلمت قديما في الحروب ؟\n1- الصاروخ\n2- المسدس\n3- المنجنيق')
name = string.gsub(name,'اسيا','⌁︙تقع لبنان في قاره ؟\n1- افريقيا\n2- اسيا\n3- امركيا الشماليه')
name = string.gsub(name,'6','⌁︙كم صفرا للمليون ؟\n1- 4\n2- 3\n3- 6')
name = string.gsub(name,'الاسد','⌁︙ماهو الحيوان الذي يلقب بملك الغابه ؟\n1- الفيل\n2- الاسد\n3- النمر')
name = string.gsub(name,'مهر','⌁︙ما اسم صغير الحصان ؟\n1- مهر\n2- جرو\n3- عجل')
name = string.gsub(name,'الدولفين','⌁︙ما الحيوان الذي ينام واحدى عينه مفتوحه ؟\n1- القرش\n2- الدولفين\n3- الثعلب\n')
name = string.gsub(name,'اوروبا','⌁︙ماهي القاره التي تلقب بالقاره العجوز ؟\n1- اوروبا\n2- امريكا الشماليه\n3- افريقيا')
name = string.gsub(name,'الزئبق','⌁︙ما اسم المعدن الموجود فيي الحاله السائله ؟\n1- النحاس\n2- الحديد\n3- الزئبق')
name = string.gsub(name,'لندن','⌁︙ماهي عاصمه انجلترا ؟\n1- لندن\n2- لفرسول\n3- تركيا')
name = string.gsub(name,'الانسان','⌁︙ماهو الشئ الذي برأسه سبع فتحات ؟\n1- الهاتف\n2- التلفاز\n3- الانسان')
name = string.gsub(name,'طوكيو','⌁︙ماهي عاصمه اليابان ؟\n1- بانكول\n2- نيو دلهي\n3- طوكيو')
name = string.gsub(name,'خديجه','⌁︙من هي زوجه الرسول الاكبر منه سنآ ؟\n1- حفضه\n2- زينب\n3- خديجه')
HASSANTEAM = name..'\n⌁︙ارسل الجواب الصحيح فقط'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
return false
end end
if text == DevAbs:get(HASSAN..'Abs:GameNum8'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Games:Ids'..msg.chat_id_) then 
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevAbs:del(HASSAN..'Abs:GameNum8'..msg.chat_id_)
HASSANTEAM = '⌁︙مبروك لقد ربحت في اللعبه \n⌁︙ارسل ↫ الاسئله للعب مره اخرى'
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md')
end
DevAbs:set(HASSAN..'Abs:Games:Ids'..msg.chat_id_,true)
end  
if DevAbs:get(HASSAN.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
Dev_Abs(msg.chat_id_, msg.id_, 1,"⌁︙عذرا لا يمكنك تخمين عدد اكبر من الـ20 خمن رقم ما بين الـ1 والـ20", 1, 'md')
return false  end 
local GETNUM = DevAbs:get(HASSAN.."GAMES:NUM"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevAbs:del(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevAbs:del(HASSAN.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙*التخمين الصحيح هو* ↫ '..NUM..'\n⌁︙*مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, 'md')
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevAbs:incrby(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_,1)
if tonumber(DevAbs:get(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) >= 3 then
DevAbs:del(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevAbs:del(HASSAN.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙*التخمين الصحيح هو* ↫ '..GETNUM..'\n⌁︙*للاسف لقد خسرت حاول مره اخرى لتخمين الرقم الصحيح*', 1, 'md')
else
if tonumber(DevAbs:get(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 1 then
SetNum = 'محاولتان فقط'
elseif tonumber(DevAbs:get(HASSAN..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 2 then
SetNum = 'محاوله واحده فقط'
end
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لقد خمنت الرقم الخطا وتبقى لديك '..SetNum..' ارسل رقم تخمنه مره اخرى للفوز', 1, 'md')
end
end
end
end
if text == 'خمن' and ChCheck(msg) or text == 'تخمين' and ChCheck(msg) then   
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
Num = math.random(1,20)
DevAbs:set(HASSAN.."GAMES:NUM"..msg.chat_id_,Num) 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙اهلا بك عزيزي في لعبة التخمين ↫ ⤈\n ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙سيتم تخمين عدد ما بين الـ1 والـ20 اذا تعتقد انك تستطيع الفوز جرب واللعب الان .\n⌁︙ملاحظه لديك ثلاث محاولات فقط فكر قبل ارسال تخمينك !', 1, 'md')
DevAbs:setex(HASSAN.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
end
if text == 'روليت' then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
DevAbs:del(HASSAN.."Abs:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevAbs:del(HASSAN..'Abs:ListRolet'..msg.chat_id_)  
DevAbs:setex(HASSAN.."Abs:StartRolet"..msg.chat_id_..msg.sender_user_id_,3600,true)  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙حسنا لنلعب , ارسل عدد اللاعبين للروليت .', 1, 'md')
return false  
end
end
if text and text:match("^(%d+)$") and DevAbs:get(HASSAN.."Abs:StartRolet"..msg.chat_id_..msg.sender_user_id_) then
if text == "1" then
Text = "⌁︙لا استطيع بدء اللعبه بلاعب واحد فقط"
else
DevAbs:set(HASSAN.."Abs:NumRolet"..msg.chat_id_..msg.sender_user_id_,text)  
Text = '⌁︙تم بدء تسجيل اللسته يرجى ارسال المعرفات \n⌁︙الفائز يحصل على 5 نقاط عدد المطلوبين ↫ '..text..' لاعب'
end
DevAbs:del(HASSAN.."Abs:StartRolet"..msg.chat_id_..msg.sender_user_id_)
send(msg.chat_id_,msg.id_,Text)
return false
end
if text and text:match('^(@[%a%d_]+)$') and DevAbs:get(HASSAN.."Abs:NumRolet"..msg.chat_id_..msg.sender_user_id_) then 
if DevAbs:sismember(HASSAN..'Abs:ListRolet'..msg.chat_id_,text) then
send(msg.chat_id_,msg.id_,'⌁︙المعرف ↫ ['..text..'] موجود اساسا')
return false
end
tdcli_function ({ID = "SearchPublicChat",username_ = text},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙المعرف غير صحيح يرجى ارسال معرف صحيح', 1, 'md')
return false 
end
DevAbs:sadd(HASSAN..'Abs:ListRolet'..msg.chat_id_,text)
local CountAdd = DevAbs:get(HASSAN.."Abs:NumRolet"..msg.chat_id_..msg.sender_user_id_)
local CountAll = DevAbs:scard(HASSAN..'Abs:ListRolet'..msg.chat_id_)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
DevAbs:del(HASSAN.."Abs:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevAbs:setex(HASSAN.."Abs:WittingStartRolet"..msg.chat_id_..msg.sender_user_id_,1400,true) 
local Text = "⌁︙تم ادخال المعرف ↫ ["..text.."]\n⌁︙وتم اكتمال العدد الكلي هل انت مستعد ؟"
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}},{{text="اللاعبين",callback_data="/ListRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
local Text = "⌁︙تم ادخال المعرف ↫ ["..text.."] وتبقى ↫ "..CountUser.." لاعبين ليكتمل العدد ارسل المعرف الاخر"
keyboard = {} 
keyboard.inline_keyboard = {{{text="الغاء",callback_data="/NoRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil) 
end
if text == 'كت تويت' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
local HASSANTEAM = {  "آخر مرة زرت مدينة الملاهي؟",  "آخر مرة أكلت أكلتك المفضّلة؟",  "الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل",  "آخر شيء ضاع منك؟","كلمة أخيرة لشاغل البال؟","طريقتك المعتادة في التخلّص من الطاقة السلبية؟","شهر من أشهر العام له ذكرى جميلة معك؟","كلمة غريبة من لهجتك ومعناها؟🤓","‏- شيء سمعته عالق في ذهنك هاليومين؟","متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟","‏- أبرز صفة حسنة في صديقك المقرب؟","هل تشعر أن هنالك مَن يُحبك؟","اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟","أجمل شيء حصل معك خلال هاليوم؟","صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔","كلمة لشخص غالي اشتقت إليه؟💕","آخر خبر سعيد، متى وصلك؟","أنا آسف على ....؟","أوصف نفسك بكلمة؟","صريح، مشتاق؟","‏- صريح، هل سبق وخذلت أحدهم ولو عن غير قصد؟","‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭","‏- فنان/ة تود لو يدعوكَ على مائدة عشاء؟😁❤","‏- تخيّل شيء قد يحدث في المستقبل؟","‏- للشباب | آخر مرة وصلك غزل من فتاة؟🌚","شخص أو صاحب عوضك ونساك مُر الحياة ما اسمه ؟","| اذا شفت حد واعجبك وعندك الجرأه انك تروح وتتعرف عليه ، مقدمة الحديث شو راح تكون ؟.", }  
Dev_Abs(msg.chat_id_, msg.id_, 1, ''..HASSANTEAM[math.random(#HASSANTEAM)]..'' , 1, 'md')  
return false
end
end
if text == 'الالعاب' and ChCheck(msg) or text == 'العاب' and ChCheck(msg) or text == 'اللعبه' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Games'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1,[[
⌁︙قائمة العاب المجموعه ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙لعبة التخمين ↫ خمن
⌁︙لعبة الامثله ↫ امثله
⌁︙لعبة العكس ↫ العكس
⌁︙لعبة الاسئله ↫ اسئله
⌁︙لعبة الروليت ↫ روليت
⌁︙لعبة الحزوره ↫ حزوره
⌁︙لعبة الترتيب ↫ ترتيب
⌁︙لعبة المعاني ↫ معاني
⌁︙لعبة التويت ↫ كت تويت
⌁︙لعبة المختلف ↫ المختلف
⌁︙لعبة السمايلات ↫ سمايلات
⌁︙لعبة المحيبس ↫ المحيبس
⌁︙لعبة الرياضيات ↫ رياضيات
⌁︙لعبة الانكليزيه ↫ انكليزيه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙نقاطي • بيع نقاطي
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]], 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عذرا الالعاب معطله في المجموعه', 1, 'md')
end
end
if text == 'بيع نقاطي' and ChCheck(msg) then
if tonumber((DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لم تربح اي نقطه\n⌁︙ارسل ↫ الالعاب للعب', 1, 'md')
else
DevAbs0 = (DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) * 50)
DevAbs:incrby(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_,DevAbs0)
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙تم بيع '..(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_))..' من نقاطك\n⌁︙كل نقطه تساوي 50 رساله', 'md')
DevAbs:del(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_)
end
end
if text == 'رفع المشرفين' and ChCheck(msg) or text == 'رفع الادمنيه' and ChCheck(msg) then  
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 200},function(arg,abbas) 
DevAbs:del(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_)
local num = 0
local admins = abbas.members_  
for i=0 , #admins do   
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)   
num = num + 1
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,dp) 
if dp.first_name_ == false then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)   
end
end,nil)   
else
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)   
end 
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then  
Manager_id = admins[i].user_id_  
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,Manager_id)  
DevAbs:sadd(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_,Manager_id)   
end  
end  
if num == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لا يوجد ادمنيه ليتم رفعهم\n⌁︙تم رفع منشئ المجموعه", 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم رفع '..num..' من الادمنيه \n⌁︙تم رفع منشئ المجموعه', 1, 'md')
end
end,nil) 
end
if text == 'غادر' and SudoBot(msg) then
if DevAbs:get(HASSAN.."Abs:Left:Bot"..HASSAN) and not SecondSudo(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, "⌁︙المغادره معطله من قبل المطور الاساسي", 1, 'md')
return false  
end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم مغادرة المجموعه \n⌁︙تم حذف جميع بياناتها ', 1, 'md')
ChatLeave(msg.chat_id_, HASSAN)
DevAbs:srem(HASSAN.."Abs:Groups",msg.chat_id_)
end
if text ==('موقعي') and ChCheck(msg) then
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
rtpa = 'المنشئ'
elseif da.status_.ID == "ChatMemberStatusEditor" then
rtpa = 'الادمن'
elseif da.status_.ID == "ChatMemberStatusMember" then
rtpa = 'عضو'
end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙موقعك ↫ '..rtpa, 1, 'md')
end,nil)
end
if text == "معلوماتي" and ChCheck(msg) then
function get_me(extra,result,success)
local msguser = tonumber(DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local cont = (tonumber(DevAbs:get(HASSAN..'Abs:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local user_nkt = tonumber(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
if result.username_ then username = '@'..result.username_ else username = 'لا يوجد' end
if result.last_name_ then lastname = result.last_name_ else lastname = '' end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙اسمك ↫ ❨ ['..result.first_name_..'] ❩\n⌁︙معرفك ↫ ❨ ['..username..'] ❩\n⌁︙ايديك ↫ ❨ `'..result.id_..'` ❩\n⌁︙نقاطك ↫ ❨ '..user_nkt..' ❩\n⌁︙رسائلك ↫ ❨ '..user_msgs..' ❩\n⌁︙جهاتك ↫ ❨ '..cont..' ❩\n⌁︙تفاعلك ↫ '..formsgs(msguser)..'\n⌁︙رتبتك ↫ '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'md')
end
getUser(msg.sender_user_id_,get_me)
end
end
if text == "تعيين قناة الاشتراك" or text == "تغيير قناة الاشتراك" or text == "تعيين الاشتراك الاجباري" or text == "وضع قناة الاشتراك" then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
DevAbs:setex(HASSAN..'DevAbs4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_, '⌁︙ارسل لي معرف قناة الاشتراك الان')
end
return false  
end
if text == "تفعيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
if DevAbs:get(HASSAN..'DevAbs2') then
local DevCh = DevAbs:get(HASSAN..'DevAbs3')
send(msg.chat_id_, msg.id_,"⌁︙الاشتراك الاجباري مفعل \n⌁︙على القناة ↫ ["..DevCh.."]")
else
DevAbs:setex(HASSAN..'DevAbs4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_,"⌁︙لاتوجد قناة لتفعيل الاشتراك\n⌁︙ارسل لي معرف قناة الاشتراك الان")
end
end
return false  
end
if text == "تعطيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
DevAbs:del(HASSAN..'DevAbs2') DevAbs:del(HASSAN..'DevAbs3')
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الاشتراك الاجباري'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
return false  
end
if text == "حذف قناة الاشتراك" or text == "حذف قناه الاشتراك" then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
DevAbs:del(HASSAN..'DevAbs2') DevAbs:del(HASSAN..'DevAbs3')
Dev_Abs(msg.chat_id_, msg.id_, 1,"⌁︙تم حذف قناة الاشتراك الاجباري", 1, 'md') 
end
end
if SecondSudo(msg) then
if text == 'جلب قناة الاشتراك' or text == 'قناة الاشتراك' or text == 'الاشتراك الاجباري' or text == 'قناة الاشتراك الاجباري' then
if DevAbs:get(HASSAN..'DevAbs3') then
local DevCh = DevAbs:get(HASSAN..'DevAbs3')
send(msg.chat_id_, msg.id_, "⌁︙قناة الاشتراك ↫ ["..DevCh.."]")
else
send(msg.chat_id_, msg.id_, "⌁︙لاتوجد قناة في الاشتراك الاجباري")
end
return false  
end end
if SudoBot(msg) then
if text == 'اذاعه للكل بالتوجيه' and tonumber(msg.reply_to_message_id_) > 0 then
function HASSANTEAM(extra,result,success)
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
local GpList = DevAbs:smembers(HASSAN.."Abs:Groups")
for k,v in pairs(GpList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
local PvList = DevAbs:smembers(HASSAN.."Abs:Users")
for k,v in pairs(PvList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم اذاعة رسالتك بالتوجيه \n⌁︙‏في ↫ ❨ '..#GpList..' ❩ مجموعه \n⌁︙والى ↫ ❨ '..#PvList..' ❩ مشترك \n ✓', 1, 'md')
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),HASSANTEAM)
end
end
if text == "مشاهده المنشور" and ChCheck(msg) or text == "مشاهدات المنشور" and ChCheck(msg) or text == "عدد المشاهدات" and ChCheck(msg) then
DevAbs:set(HASSAN..'Abs:viewget'..msg.sender_user_id_,true)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙حسنا قم باعادة توجيه للمنشور الذي تريدني حساب مشاهداته', 1, 'md')
end
if text == "السورس" or text == "سورس" then 
local text =  [[
★
قنـاه مـخــتـصه بـنشـر القران الكريـم 

               ( بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ )
          
  وَنُنَزِّلُ مِنَ القُرْآَنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِلْمُؤْمِنِينَ .      

صدق الله العظيم


#مـعرف لــقنـﺂآةة“ [@GO_XXO]
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if ChatType == 'sp' or ChatType == 'gp'  then
if text == "اطردني" and ChCheck(msg) or text == "ادفرني" and ChCheck(msg) then
if DevAbs:get(HASSAN.."Abs:Kick:Me"..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevAbs:set(HASSAN..'yes'..msg.sender_user_id_..'', 'delyes')
DevAbs:set(HASSAN..'no'..msg.sender_user_id_..'', 'delno')
local Text = '⌁︙هل انت متأكد من المغادره'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/delyes"},{text="لا",callback_data="/delno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == 'تعطيل اطردني' and Manager(msg) and ChCheck(msg) then
DevAbs:set(HASSAN.."Abs:Kick:Me"..msg.chat_id_, true)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل امر اطردني'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل اطردني' and Manager(msg) and ChCheck(msg) then
DevAbs:del(HASSAN.."Abs:Kick:Me"..msg.chat_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل امر اطردني'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "نزلني" and ChCheck(msg) then
if DevAbs:get(HASSAN.."Abs:Del:Me"..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevAbs:set(HASSAN..'yesdel'..msg.sender_user_id_..'', 'delyes')
DevAbs:set(HASSAN..'nodel'..msg.sender_user_id_..'', 'delno')
local Text = '⌁︙هل انت متأكد من تنزيلك'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/yesdel"},{text="لا",callback_data="/nodel"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == 'تعطيل نزلني' and BasicConstructor(msg) and ChCheck(msg) then
DevAbs:set(HASSAN.."Abs:Del:Me"..msg.chat_id_, true)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل امر نزلني'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل نزلني' and BasicConstructor(msg) and ChCheck(msg) then
DevAbs:del(HASSAN.."Abs:Del:Me"..msg.chat_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل امر نزلني'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if Admin(msg) then
if text == "تاك للكل" and ChCheck(msg) then
function TagAll(dp1,dp2)
local text = "⌁︙وينكم يالربع \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevAbs:get(HASSAN..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevAbs:get(HASSAN..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 200000},TagAll,nil)
end
if text and text:match("^كللهم (.*)$") and ChCheck(msg) then
local txt = {string.match(text, "^(كللهم) (.*)$")}
function TagAll(dp1,dp2)
local text = "⌁︙"..txt[2].." \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevAbs:get(HASSAN..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevAbs:get(HASSAN..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 200000},TagAll,nil)
end
end
if text == "رسائلي" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙عدد رسائلك هنا ↫ *❨ "..user_msgs.." ❩*", 1, 'md')
end
if text == "التفاعل" and ChCheck(msg) then
local EntryNumber = (DevAbs:get(HASSAN..'Abs:EntryNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local ExitNumber = (DevAbs:get(HASSAN..'Abs:ExitNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local MsgNumberDay = (DevAbs:get(HASSAN..'Abs:MsgNumberDay'..msg.chat_id_..':'..os.date('%d')) or 0)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙انضمام الاعضاء اليوم ↫ *"..EntryNumber.."*\n⌁︙مغادرة الاعضاء اليوم ↫ *"..ExitNumber.."*\n⌁︙عدد الرسائل اليوم ↫ *"..MsgNumberDay.."*\n⌁︙نسبة التفاعل اليوم ↫ *"..math.random(40,100).."%*", 1, 'md')
end
if text == "معرفي" and ChCheck(msg) then
function get_username(extra,result,success)
text = '⌁︙معرفك ↫ ❨ User ❩'
local text = text:gsub('User',('@'..result.username_ or ''))
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_username)
end
if text == "اسمي" and ChCheck(msg) then
function get_firstname(extra,result,success)
text = '⌁︙اسمك ↫ firstname lastname'
local text = text:gsub('firstname',(result.first_name_ or ''))
local text = text:gsub('lastname',(result.last_name_ or ''))
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_firstname)
end   
if text == "اهمس" or text == "همسه" or text == "اريد بوت الهمسه" or text == "دزلي بوت الهمسه" or  text == "دزولي بوت الهمسه" then  Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙@HMSEBOT', 1, 'md') end
if text == "رابط حذف" or text == "رابط الحذف" or text == "اريد رابط الحذف" or  text == "شمرلي رابط الحذف" or text == "اريد رابط حذف" then local inline = {{{text="اضغط هنا",url="https://t.me/DYFBOT"}}} SendInline(msg.chat_id_,'⌁︙اضغط للحصول على الرابط',nil,inline) return false end
if text == "بوت الحذف" or text == "اريد بوت الحذف" or text == "اريد بوت حذف" or text == "بوت حذف" or text == "بوت حذف حسابات" or text == "راح احذف" then local inline = {{{text="اضغط هنا",url="https://t.me/DYFBOT"}}} SendInline(msg.chat_id_,'⌁︙اضغط للحصول على البوت',nil,inline) return false end
if text == "جهاتي" and ChCheck(msg) or text == "اضافاتي" and ChCheck(msg) then add = (tonumber(DevAbs:get(HASSAN..'Abs:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0) Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙عدد جهاتك المضافه ↫ *❨ "..add.." ❩* ", 1, 'md') end
if text == "تعديلاتي" or text == "سحكاتي" and ChCheck(msg) then local edit_msg = DevAbs:get(HASSAN..'Abs:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0  Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙عدد تعديلاتك ↫ *❨ "..edit_msg.." ❩* ", 1, 'md') end
if text == "ايديي" and ChCheck(msg) then Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ايديك ↫ ❨ `'..msg.sender_user_id_..'` ❩', 1, 'md') end
if text == "رتبتي" and ChCheck(msg) then Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙رتبتك ↫ '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'html') end
if text == "ايدي المجموعه" and ChCheck(msg) then Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ايدي المجموعه ↫ `"..msg.chat_id_.."`", 1, 'md') end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' or text == 'حذف سحكاتي' or text == 'حذف تعديلاتي' then DevAbs:del(HASSAN..'Abs:EditMsg'..msg.chat_id_..msg.sender_user_id_) Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف جميع تعديلاتك بنجاح' , 1, 'md') end
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' or text == 'حذف جهاتي' or text == 'حذف اضافاتي' then DevAbs:del(HASSAN..'Abs:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف جميع جهاتك المضافه' , 1, 'md') end
if text == "المطور" then 
local DevCh1 = DevAbs:get(HASSAN.."DevAbs3")
local DevText = DevAbs:get(HASSAN.."DevText")
if DevCh1 then DevCh = '\n⌁︙*Dev Ch* ↬ ['..DevCh1..']' else DevCh = '' end
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,dp) 
if dp.username_ ~= false then DevUser = '@'..dp.username_ else DevUser = dp.first_name_ end
if DevText then
Dev_Abs(msg.chat_id_, msg.id_, 1, DevText, 1, "md")
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*Dev User* ↬ ['..DevUser..']\n⌁︙*Dev Id* ↬ '..DevId..''..DevCh, 1, "md")
end
end,nil)
end 
if text and text:match('^هينه @(.*)') and ChCheck(msg) or text and text:match('^هينها @(.*)') then 
if not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^هينه @(.*)') or text:match('^هينها @(.*)') 
function HASSANTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if tonumber(result.id_) == tonumber(806201930) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if DevAbs:sismember(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,result.id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local HASSANTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md') 
local HASSANTEAM = { "لكك جرجف @"..username.." احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش لكك فاشل @"..username.." لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","حبيبي @"..username.." راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪","دمشي لك @"..username.." ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع @"..username.." متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪",}
Dev_Abs(msg.chat_id_, result.id_, 1,''..HASSANTEAM[math.random(#HASSANTEAM)]..'', 1, 'html') 
else  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,HASSANTEAM)
end
end
if text == ("هينه") or text == ("بعد هينه") or text == ("هينه بعد") or text == ("لك هينه") or text == ("هينها") or text == ("هينهه") or text == ("رزله") or text == ("رزلهه") or text == ("رزلها") then
if not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) then
function hena(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if tonumber(result.sender_user_id_) == tonumber(806201930) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if DevAbs:sismember(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,result.sender_user_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local HASSANTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md') 
local HASSANTEAM = {"لكك جرجف احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش فاشل لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","دمشي لك ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪","حبيبي راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪"} 
Dev_Abs(msg.chat_id_, result.id_, 1,''..HASSANTEAM[math.random(#HASSANTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),hena)   
end
end
end
if text == ("بوسه") or text == ("بعد بوسه") or text == ("ضل بوس") or text == ("بوسه بعد") or text == ("بوسها") or text == ("بعد بوسها") or text == ("ضل بوس") or text == ("بوسها بعد") or text == ("بوسهه") then
if not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) then
function bosh(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح ابوس نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Abs(msg.chat_id_, result.id_, 1, 'مواححح احلاا بوسةة المطوريي😻🔥💗', 1, 'html')
return false
end 
local HASSANTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md') 
local HASSANTEAM = {"مواححح افيش عافيههه😍🔥💗","امممووااهحح شهلعسل🥺🍯💘","مواححح،ءوفف اذوب🤤💗"} 
Dev_Abs(msg.chat_id_, result.id_, 1,''..HASSANTEAM[math.random(#HASSANTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),bosh)   
end
end
end
if text == ("صيحه") or text == ("صيحها") or text == ("صيحهه") or text == ("صيح") then
if not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) then
function seha(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Abs(msg.chat_id_, result.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️', 1, 'html')
return false
end 
local HASSANTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md') 
local HASSANTEAM = {"تتعال ححب محتاجيك🙂🍭","تعال يولل استاذكك ايريدككك😒🔪","يمعوود تعاال يريدوكك🤕♥️","تعال لكك ديصيحوك😐🖤"} 
Dev_Abs(msg.chat_id_, result.id_, 1,''..HASSANTEAM[math.random(#HASSANTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),seha)   
end
end
end
if text and text:match('^صيحه @(.*)') and ChCheck(msg) or text and text:match('^صيح @(.*)') and ChCheck(msg) then 
if not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^صيحه @(.*)') or text:match('^صيح @(.*)') 
function HASSANTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️ @'..username, 1, 'html') 
return false  
end  
local HASSANTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Abs(msg.chat_id_, msg.id_, 1,HASSANTEAM, 1, 'md') 
local HASSANTEAM = { "تتعال ححب @"..username.." محتاجيك🙂🍭","تعال يولل @"..username.." استاذكك ايريدككك😒🔪","يمعوود @"..username.." تعاال يريدوكك🤕♥️","تعال لكك @"..username.." ديصيحوك😐🖤",}
Dev_Abs(msg.chat_id_, result.id_, 1,''..HASSANTEAM[math.random(#HASSANTEAM)]..'', 1, 'html') 
else  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,HASSANTEAM)
end
end
end
if text == ("تنزيل الكل") and msg.reply_to_message_id_ ~= 0 and Manager(msg) and ChCheck(msg) then 
function promote_by_reply(extra, result, success)
if SudoId(result.sender_user_id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.sender_user_id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevAbs:sismember(HASSAN..'Abs:SudoBot:',result.sender_user_id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevAbs:sismember(HASSAN..'Abs:ManagerAll:',result.sender_user_id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevAbs:sismember(HASSAN..'Abs:AdminAll:',result.sender_user_id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevAbs:sismember(HASSAN..'Abs:VipAll:',result.sender_user_id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_, result.sender_user_id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevAbs:sismember(HASSAN..'Abs:Constructor:'..msg.chat_id_, result.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAbs:sismember(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_) then
manager = 'المدراء • ' else manager = '' end
if DevAbs:sismember(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAbs:sismember(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAbs:sismember(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.sender_user_id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من ↫ ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙لم تتم ترقيته مسبقا")  
end
if AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevAbs:srem(HASSAN..'Abs:SecondSudo:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:SudoBot:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevAbs:srem(HASSAN..'Abs:SudoBot:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'absconstructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.sender_user_id_)
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل الكل @(.*)$") and Manager(msg) and ChCheck(msg) then
local rem = {string.match(text, "^(تنزيل الكل) @(.*)$")}
function remm(extra, result, success)
if result.id_ then
if SudoId(result.id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevAbs:sismember(HASSAN..'Abs:SudoBot:',result.id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevAbs:sismember(HASSAN..'Abs:ManagerAll:',result.id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevAbs:sismember(HASSAN..'Abs:AdminAll:',result.id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevAbs:sismember(HASSAN..'Abs:VipAll:',result.id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevAbs:sismember(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_, result.id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevAbs:sismember(HASSAN..'Abs:Constructor:'..msg.chat_id_, result.id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevAbs:sismember(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_) then
manager = 'المدراء • ' else manager = '' end
if DevAbs:sismember(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevAbs:sismember(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevAbs:sismember(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من ↫ ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.id_,"Reply","⌁︙لم تتم ترقيته مسبقا")  
end 
if AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevAbs:srem(HASSAN..'Abs:SecondSudo:', result.id_)
DevAbs:srem(HASSAN..'Abs:SudoBot:', result.id_)
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevAbs:srem(HASSAN..'Abs:SudoBot:', result.id_)
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevAbs:srem(HASSAN..'Abs:ManagerAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:AdminAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:VipAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'absconstructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_, result.id_)
elseif AbsDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, result.id_)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_, result.id_)
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المعرف غير صحيح*', 1, 'md')
end
end
resolve_username(rem[2],remm)
end
--     Set SecondSudo     --
if Sudo(msg) then
if text ==('اضف مطور ثانوي') or text ==('رفع مطور ثانوي') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المطورين الثانويين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور ثانوي (%d+)') or text:match('^رفع مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور ثانوي (%d+)') or text:match('رفع مطور ثانوي (%d+)')
DevAbs:sadd(HASSAN..'Abs:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المطورين الثانويين")  
end
--     Rem SecondSudo     --
if text ==('حذف مطور ثانوي') or text ==('تنزيل مطور ثانوي') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المطورين الثانويين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور ثانوي (%d+)') or text:match('^تنزيل مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور ثانوي (%d+)') or text:match('تنزيل مطور ثانوي (%d+)')
DevAbs:srem(HASSAN..'Abs:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المطورين الثانويين")  
end end
--       Set SudoBot      --
if SecondSudo(msg) then
if text ==('اضف مطور') or text ==('رفع مطور') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المطورين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور (%d+)') or text:match('^رفع مطور (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور (%d+)') or text:match('رفع مطور (%d+)')
DevAbs:sadd(HASSAN..'Abs:SudoBot:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المطورين")  
end
--       Rem SudoBot      --
if text ==('حذف مطور') or text ==('تنزيل مطور') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المطورين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور (%d+)') or text:match('^تنزيل مطور (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور (%d+)') or text:match('تنزيل مطور (%d+)')
DevAbs:srem(HASSAN..'Abs:SudoBot:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المطورين")  
end end
--      Set ManagerAll    --
if SudoBot(msg) then
if text ==('رفع مدير عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المدراء العامين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مدير عام (%d+)')
DevAbs:sadd(HASSAN..'Abs:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المدراء العامين")  
end
--      Rem ManagerAll    --
if text ==('تنزيل مدير عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المدراء العامين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مدير عام (%d+)')
DevAbs:srem(HASSAN..'Abs:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المدراء العامين")  
end end
--      Set adminall      --
if ManagerAll(msg) then
if text ==('رفع ادمن عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة الادمنيه العامين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع ادمن عام (%d+)')
DevAbs:sadd(HASSAN..'Abs:AdminAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة الادمنيه العامين")  
end
--      Rem adminall      --
if text ==('تنزيل ادمن عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة الادمنيه العامين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل ادمن عام (%d+)')
DevAbs:srem(HASSAN..'Abs:AdminAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة الادمنيه العامين")  
end end
--       Set Vipall       --
if AdminAll(msg) then
if text ==('رفع مميز عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المميزين العام")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مميز عام (%d+)')
DevAbs:sadd(HASSAN..'Abs:VipAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المميزين العام")  
end
--       Rem Vipall       --
if text ==('تنزيل مميز عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المميزين العام")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مميز عام (%d+)')
DevAbs:srem(HASSAN..'Abs:VipAll:',user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المميزين العام")  
end end
--  Set BasicConstructor  --
if ChatType == 'sp' or ChatType == 'gp'  then
if AbsConstructor(msg) then
if text ==('رفع منشئ اساسي') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ اساسي @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه منشئ اساسي")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ اساسي (%d+)') and ChCheck(msg) then
local user = text:match('رفع منشئ اساسي (%d+)')
DevAbs:sadd(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه منشئ اساسي")  
end
--  Rem BasicConstructor  --
if text ==('تنزيل منشئ اساسي') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ اساسي @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله منشئ اساسي")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ اساسي (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منشئ اساسي (%d+)')
DevAbs:srem(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله منشئ اساسي")  
end end
if text ==('رفع منشئ اساسي') and not AbsConstructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر لمنشئ المجموعه والمطورين فقط', 1, 'md')
end
--    Set  Constructor    --
if BasicConstructor(msg) then
if text ==('رفع منشئ') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المنشئين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ (%d+)') and ChCheck(msg) then
local user = text:match('رفع منشئ (%d+)')
DevAbs:sadd(HASSAN..'Abs:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المنشئين")  
end
--    Rem  Constructor    --
if text ==('تنزيل منشئ') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المنشئين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منشئ (%d+)')
DevAbs:srem(HASSAN..'Abs:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المنشئين")  
end 
end
--      Set Manager       --
if Constructor(msg) then
if text ==('رفع مدير') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المدراء")  
end  
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مدير @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المدراء")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end 
if text and text:match('^رفع مدير (%d+)') and ChCheck(msg) then
local user = text:match('رفع مدير (%d+)')
DevAbs:sadd(HASSAN..'Abs:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المدراء")  
end
--       Rem Manager      --
if text ==('تنزيل مدير') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المدراء")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المدراء")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مدير (%d+)')
DevAbs:srem(HASSAN..'Abs:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المدراء")  
end 
--       Set Cleaner      --
if text ==('رفع منظف') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:sadd(HASSAN..'Abs:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع منظف @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المنظفين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منظف (%d+)') and ChCheck(msg) then
local user = text:match('رفع منظف (%d+)')
DevAbs:sadd(HASSAN..'Abs:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المنظفين")  
end
--       Rem Cleaner      --
if text ==('تنزيل منظف') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منظف @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المنظفين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منظف (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منظف (%d+)')
DevAbs:srem(HASSAN..'Abs:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المنظفين")  
end end
--       Set admin        --
if Manager(msg) then
if text ==('رفع ادمن') and ChCheck(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع ادمن @(.*)') and ChCheck(msg) then
local username = text:match('^رفع ادمن @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة الادمنيه")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن (%d+)') and ChCheck(msg) then
local user = text:match('رفع ادمن (%d+)')
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة الادمنيه")  
end
--        Rem admin       --
if text ==('تنزيل ادمن') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل ادمن @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة الادمنيه")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل ادمن (%d+)')
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة الادمنيه")  
end end
--       Set Vipmem       --
if Admin(msg) then
if text ==('رفع مميز') and ChCheck(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAbs:sadd(HASSAN..'Abs:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مميز @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مميز @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفعه في قائمة المميزين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز (%d+)') and ChCheck(msg) then
local user = text:match('رفع مميز (%d+)')
if not BasicConstructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevAbs:sadd(HASSAN..'Abs:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم رفعه في قائمة المميزين")  
end
--       Rem Vipmem       --
if text ==('تنزيل مميز') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مميز @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تنزيله من قائمة المميزين")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مميز (%d+)')
DevAbs:srem(HASSAN..'Abs:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⌁︙تم تنزيله من قائمة المميزين")  
end end 
if BasicConstructor(msg) then
if text and text:match("^رفع مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..HASSAN)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه مشرف في المجموعه")  
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..HASSAN)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من مشرفين المجموعه")  
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end 
if text and (text:match("^رفع بكل الصلاحيات$") or text:match("^رفع بكل صلاحيات$")) and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..HASSAN)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=True")
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه مشرف في جميع الصلاحيات")  
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and (text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")) and ChCheck(msg) then
local Abs = text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")
function ReplySet(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..HASSAN)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
https.request("https://api.telegram.org/bot"..TokenBot.."/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=True&can_restrict_members=false&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم اضافة ↫ "..Abs.." كلقب له")  
https.request("https://api.telegram.org/bot"..TokenBot.."/setChatAdministratorCustomTitle?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&custom_title="..Abs)
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ReplySet)
end
end
end
if text == "صلاحيتي" or text == "صلاحياتي" and ChCheck(msg) then 
if tonumber(msg.reply_to_message_id_) == 0 then 
Validity(msg,msg.sender_user_id_)
end end
if text ==('صلاحيته') or text ==('صلاحياته') and ChCheck(msg) then
function ValidityReply(extra, result, success)
Validity(msg,result.sender_user_id_)
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ValidityReply)
end end
if text and (text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')) and ChCheck(msg) then
local username = text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')
function ValidityUser(extra,result,success)
if result.id_ then
Validity(msg,result.id_) 
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,ValidityUser)
end
if text and (text:match('^صلاحيته (%d+)') or text:match('^صلاحياته (%d+)')) and ChCheck(msg) then
local ValidityId = text:match('صلاحيته (%d+)') or text:match('صلاحياته (%d+)')
Validity(msg,ValidityId)  
end
if Admin(msg) then
if msg.reply_to_message_id_ ~= 0 then
if text and (text:match("^مسح$") or text:match("^حذف$")) and ChCheck(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.reply_to_message_id_})
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف الرساله مع رسالة الامر', 1, 'md')
end end end
if Constructor(msg) then
if text == "تفعيل الحظر" and ChCheck(msg) or text == "تفعيل الطرد" and ChCheck(msg) then
DevAbs:del(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الطرد والحظر'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الحظر" and ChCheck(msg) or text == "تعطيل الطرد" and ChCheck(msg) then
DevAbs:set(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_,"true")
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الطرد والحظر'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تفعيل الكتم" and ChCheck(msg) or text == "تفعيل التقييد" and ChCheck(msg) then
DevAbs:del(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الكتم والتقيد'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الكتم" and ChCheck(msg) or text == "تعطيل التقييد" and ChCheck(msg) then
DevAbs:set(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_,"true")
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الكتم والتقيد'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
end
if BasicConstructor(msg) then
if text == "تفعيل الرفع" and ChCheck(msg) or text == "تفعيل الترقيه" and ChCheck(msg) then
DevAbs:del(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تفعيل رفع ↫ الادمن • المميز', 1, 'md')
end
if text == "تعطيل الرفع" and ChCheck(msg) or text == "تعطيل الترقيه" and ChCheck(msg) then
DevAbs:set(HASSAN.."Abs:Lock:ProSet"..msg.chat_id_,"true")
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تعطيل رفع ↫ الادمن • المميز', 1, 'md')
end
end
--          Kick          --
if Admin(msg) then
if text ==('طرد') and ChCheck(msg) then
function KickReply(extra, result, success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع طرد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم طرده من المجموعه")  
end,nil)
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),KickReply)
end end
if text and text:match('^طرد @(.*)') and ChCheck(msg) then
local username = text:match('^طرد @(.*)')
function KickUser(extra,result,success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع طرد ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم طرده من المجموعه")  
end,nil)
end
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,KickUser)
end
if text and text:match('^طرد (%d+)') and ChCheck(msg) then
local user = text:match('طرد (%d+)')
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع طرد ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم طرده من المجموعه")  
end,nil)
end
end
end 
--          Ban           --
if Admin(msg) then
if text ==('حضر') or text ==('حظر') and ChCheck(msg) then
function BanReply(extra, result, success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع حظر ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevAbs:sadd(HASSAN..'Abs:Ban:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم حظره من المجموعه") 
end,nil) 
end 
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanReply)
end end
if text and (text:match('^حضر @(.*)') or text:match('^حظر @(.*)')) and ChCheck(msg) then
local username = text:match('^حضر @(.*)') or text:match('^حظر @(.*)')
function BanUser(extra,result,success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع حظر ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
DevAbs:sadd(HASSAN..'Abs:Ban:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم حظره من المجموعه")  
end,nil) 
end
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanUser)
end
if text and (text:match('^حضر (%d+)') or text:match('^حظر (%d+)')) and ChCheck(msg) then
local user = text:match('حضر (%d+)') or text:match('حظر (%d+)')
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الطرد والحظر من قبل حسن')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع حظر ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⌁︙ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⌁︙لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
DevAbs:sadd(HASSAN..'Abs:Ban:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم حظره من المجموعه")  
end,nil) 
end
end
--         UnBan          --
if text ==('الغاء الحظر') or text ==('الغاء حظر') and ChCheck(msg) then
function UnBanReply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_, result.sender_user_id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.sender_user_id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم الغاء حظره من المجموعه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnBanReply)
end end
if text and (text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')
function UnBanUser(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_, result.id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.id_,"Reply","⌁︙تم الغاء حظره من المجموعه")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnBanUser)
end
if text and (text:match('^الغاء الحظر (%d+)') or text:match('^الغاء حظر (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء الحظر (%d+)') or text:match('الغاء حظر (%d+)')
DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_, user)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = user, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,user,"Reply","⌁︙تم الغاء حظره من المجموعه")  
end 
end 
--          Mute          --
if Admin(msg) then
if text ==('كتم') and ChCheck(msg) then
function MuteReply(extra, result, success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع كتم ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
if DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙هو بالفعل مكتوم من المجموعه")  
else
DevAbs:sadd(HASSAN..'Abs:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم كتمه من المجموعه")  
end 
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteReply)
end end
if text and text:match('^كتم @(.*)') and ChCheck(msg) then
local username = text:match('^كتم @(.*)')
function MuteUser(extra,result,success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع كتم ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
if DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","⌁︙هو بالفعل مكتوم من المجموعه")  
else
DevAbs:sadd(HASSAN..'Abs:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم كتمه من المجموعه")  
end
end
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteUser)
end
if text and text:match('^كتم (%d+)') and ChCheck(msg) then
local user = text:match('كتم (%d+)')
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع كتم ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
if DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","⌁︙هو بالفعل مكتوم من المجموعه")  
else
DevAbs:sadd(HASSAN..'Abs:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم كتمه من المجموعه")  
end
end
end
--         UnMute         --
if text ==('الغاء الكتم') or text ==('الغاء كتم') and ChCheck(msg) then
function UnMuteReply(extra, result, success)
if not DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙هو ليس مكتوم لالغاء كتمه")  
else
DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم الغاء كتمه من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnMuteReply)
end end
if text and (text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')
function UnMuteUser(extra,result,success)
if result.id_ then
if not DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","⌁︙هو ليس مكتوم لالغاء كتمه")  
else
DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم الغاء كتمه من المجموعه")  
end
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnMuteUser)
end
if text and (text:match('^الغاء الكتم (%d+)') or text:match('^الغاء كتم (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء الكتم (%d+)') or text:match('الغاء كتم (%d+)')
if not DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","⌁︙هو ليس مكتوم لالغاء كتمه")  
else
DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم الغاء كتمه من المجموعه")  
end
end 
end 
--          Tkeed           --
if Admin(msg) then
if text ==('تقييد') or text ==('تقيد') and ChCheck(msg) then
function TkeedReply(extra, result, success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_)
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تقيده من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),TkeedReply)
end end
if text and (text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')) and ChCheck(msg) then
local username = text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')
function TkeedUser(extra,result,success)
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_)
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم تقيده من المجموعه")  
end
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,TkeedUser)
end
if text and (text:match('^تقييد (%d+)') or text:match('^تقيد (%d+)')) and ChCheck(msg) then
local user = text:match('تقييد (%d+)') or text:match('تقيد (%d+)')
if not Constructor(msg) and DevAbs:get(HASSAN.."Abs:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⌁︙لقد تم تعطيل الكتم والتقيد من قبل حسن')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(user, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user)
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم تقيده من المجموعه")  
end
end
--         UnTkeed          --
if text ==('الغاء تقييد') or text ==('الغاء تقيد') and ChCheck(msg) then
function UnTkeedReply(extra, result, success)
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم الغاء تقيده من المجموعه")  
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnTkeedReply)
end end
if text and (text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')
function UnTkeedUser(extra,result,success)
if result.id_ then
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم الغاء تقيده من المجموعه")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnTkeedUser)
end
if text and (text:match('^الغاء تقييد (%d+)') or text:match('^الغاء تقيد (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء تقييد (%d+)') or text:match('الغاء تقيد (%d+)')
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⌁︙تم الغاء تقيده من المجموعه")  
end
end 
end
--         BanAll         --
if SecondSudo(msg) then
if text ==('حضر عام') or text ==('حظر عام') then
function BanAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevAbs:sadd(HASSAN..'Abs:BanAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم حظره عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanAllReply)
end end
if text and (text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')) then
local username = text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')
function BanAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
ChatKick(msg.chat_id_, result.id_)
DevAbs:sadd(HASSAN..'Abs:BanAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم حظره عام من المجموعات")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanAllUser)
end
if text and (text:match('^حضر عام (%d+)') or text:match('^حظر عام (%d+)')) then
local user = text:match('حضر عام (%d+)') or text:match('حظر عام (%d+)')
if tonumber(user) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(user) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',user) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(msg.chat_id_, user)
DevAbs:sadd(HASSAN..'Abs:BanAll:', user)
ReplyStatus(msg,user,"Reply","⌁︙تم حظره عام من المجموعات")  
end
--         MuteAll        --
if text ==('كتم عام') then
function MuteAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevAbs:sadd(HASSAN..'Abs:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم كتمه عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteAllReply)
end end
if text and text:match('^كتم عام @(.*)') then
local username = text:match('^كتم عام @(.*)')
function MuteAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
DevAbs:sadd(HASSAN..'Abs:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم كتمه عام من المجموعات")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteAllUser)
end
if text and text:match('^كتم عام (%d+)') then
local user = text:match('كتم عام (%d+)')
if tonumber(user) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(user) == true then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevAbs:sismember(HASSAN..'Abs:SecondSudo:',user) and not Sudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevAbs:sadd(HASSAN..'Abs:MuteAll:', user)
ReplyStatus(msg,user,"Reply","⌁︙تم كتمه عام من المجموعات")  
end
--         UnAll          --
if text ==('الغاء عام') or text ==('الغاء العام') then
function UnAllReply(extra, result, success)
DevAbs:srem(HASSAN..'Abs:BanAll:', result.sender_user_id_)
DevAbs:srem(HASSAN..'Abs:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnAllReply)
end end
if text and (text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')) then
local username = text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')
function UnAllUser(extra,result,success)
if result.id_ then
DevAbs:srem(HASSAN..'Abs:BanAll:', result.id_)
DevAbs:srem(HASSAN..'Abs:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⌁︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnAllUser)
end
if text and (text:match('^الغاء عام (%d+)') or text:match('^الغاء العام (%d+)')) then
local user = text:match('الغاء عام (%d+)') or text:match('الغاء العام (%d+)')
DevAbs:srem(HASSAN..'Abs:BanAll:', user)
DevAbs:srem(HASSAN..'Abs:MuteAll:', user)
ReplyStatus(msg,user,"Reply","⌁︙تم الغاء (الحظر • الكتم) عام من المجموعات")  
end
end
end
if (text == "تغير المطور الاساسي" or text == "نقل ملكيه البوت" or text == "تغيير المطور الاساسي" or text == "↫ تغير المطور الاساسي ⌁") and msg.reply_to_message_id_ == 0 and Sudo(msg) then 
send(msg.chat_id_, msg.id_,'⌁︙يجب التاكد ان المطور الجديد ارسل start لخاص البوت بعد ذلك يمكنك ارسال ايدي المطور')
DevAbs:setex(HASSAN.."Abs:EditDev"..msg.sender_user_id_,300,true)
end
if DevAbs:get(HASSAN.."Abs:EditDev"..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_,'⌁︙تم الغاء امر تغير المطور الاساسي')
DevAbs:del(HASSAN.."Abs:EditDev"..msg.sender_user_id_)
return false
end
if text and text:match("^(%d+)$") then 
tdcli_function ({ID = "GetUser",user_id_ = text},function(arg,dp) 
if dp.first_name_ ~= false then
DevAbs:del(HASSAN.."Abs:EditDev"..msg.sender_user_id_)
DevAbs:set(HASSAN.."Abs:NewDev"..msg.sender_user_id_,dp.id_)
if dp.username_ ~= false then DevUser = '\n⌁︙المعرف ↫ [@'..dp.username_..']' else DevUser = '' end
local Text = '⌁︙الايدي ↫ '..dp.id_..DevUser..'\n⌁︙الاسم ↫ ['..CatchName(dp.first_name_,15)..'](tg://user?id='..dp.id_..')\n⌁︙تم حفظ المعلومات بنجاح\n⌁︙استخدم الازرار للتاكيد ↫ ⤈'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/setyes"},{text="لا",callback_data="/setno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
send(msg.chat_id_, msg.id_,"⌁︙المعلومات خاطئه قم بالتاكد واعد المحاوله")
DevAbs:del(HASSAN.."Abs:EditDev"..msg.sender_user_id_)
end
end,nil)
return false
end
end
--     Source HASSAN     --
if Admin(msg) then
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع مطي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
if DevAbs:sismember(HASSAN..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙هو مطي شرفع منه بعد😹💔") 
else
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه في قائمة المطايه") 
DevAbs:sadd(HASSAN..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل مطي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
if not DevAbs:sismember(HASSAN..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙هو ليس مطي ليتم تنزيله") 
else
DevAbs:srem(HASSAN..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله من قائمة المطايه") 
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and (text:match("^رفع ابن متعه$") or text:match("^رفع ابن متعة$")) and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه ابن متعه بنجاح") 
DevAbs:sadd(HASSAN..'User:Don:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and (text:match("^تنزيل ابن متعه$") or text:match("^تنزيل ابن متعة$")) and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله ابن متعه بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع عفير$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه عفير بنجاح") 
DevAbs:sadd(HASSAN..'User:Don1:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل عفير$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don1:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله عفير بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع مهتدي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه مهتدي بنجاح") 
DevAbs:sadd(HASSAN..'User:Don12:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل مهتدي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don12:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله مهتدي بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع ابن نرجس الزانية$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه ابن نرجس الزانية بنجاح") 
DevAbs:sadd(HASSAN..'User:Don124:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل ابن نرجس الزانية$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don124:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله ابن نرجس الزانية بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع وهابي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه وهابي بنجاح") 
DevAbs:sadd(HASSAN..'User:Don123:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل وهابي$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don123:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله وهابي بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع لطام$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه لطام بنجاح") 
DevAbs:sadd(HASSAN..'User:Don1234:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل لطام$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don1234:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله لطام بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع زرارة ابو الضراط$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفعه زرارةابو الضراط بنجاح") 
DevAbs:sadd(HASSAN..'User:Don12345:'..msg.chat_id_, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل زرارة ابو الضراط$") and not DevAbs:get(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
DevAbs:srem(HASSAN..'User:Don12345:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تنزيله زرارة ابو الضراط بنجاح") 
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source HASSAN     --
end
if Admin(msg) then
if text and (text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')
local Minutes = string.gsub(mutept, 'm', '')
local num1 = tonumber(Minutes) * 60 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تقيده لمدة ↫ "..mutept.." د") 
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end 
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end
if text and (text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')
local hour = string.gsub(mutept, 'h', '')
local num1 = tonumber(hour) * 3600 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تقيده لمدة ↫ "..mutept.." س") 
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
if text and (text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')
local day = string.gsub(mutept, 'd', '')
local num1 = tonumber(day) * 86400 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا تستطيع تقيد ↫ '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم تقيده لمدة ↫ "..mutept.." ي") 
DevAbs:sadd(HASSAN..'Abs:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
end 
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ == 0 and ChCheck(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف رسائل (%d+)$")
DevAbs:set('HASSANTEAM:'..HASSAN..'id:user'..msg.chat_id_,TXT)  
DevAbs:setex('HASSANTEAM:'..HASSAN.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل عدد الرسائل الان \n⌁︙ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Abs(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف رسائل (%d+)$")
function Reply(extra, result, success)
DevAbs:del(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_) 
DevAbs:incrby(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_,Num) 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اضافة "..Num..' رساله', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ == 0 and ChCheck(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف نقاط (%d+)$")
DevAbs:set('HASSANTEAM:'..HASSAN..'ids:user'..msg.chat_id_,TXT)  
DevAbs:setex('HASSANTEAM:'..HASSAN.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل عدد النقاط الان \n⌁︙ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Abs(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف نقاط (%d+)$")
function Reply(extra, result, success)
DevAbs:incrby(HASSAN..'Abs:GamesNumber'..msg.chat_id_..result.sender_user_id_,Num) 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اضافة "..Num..' نقطه', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if DevAbs:get(HASSAN..'Abs:Lock:Clean'..msg.chat_id_) then if msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.photo_ or msg.content_.animation_ then if msg.reply_to_message_id_ ~= 0 then DevAbs:sadd(HASSAN.."Abs:cleaner"..msg.chat_id_, msg.id_) else DevAbs:sadd(HASSAN.."Abs:cleaner"..msg.chat_id_, msg.id_) end end end
if Manager(msg) and msg.reply_to_message_id_ ~= 0 then
if text and text:match("^تثبيت$") and ChCheck(msg) then 
if DevAbs:sismember(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, "⌁︙التثبيت والغاء واعادة التثبيت تم قفله من قبل حسن", 1, 'md')
return false  
end
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100",""),message_id_ = msg.reply_to_message_id_,disable_notification_ = 1},function(arg,data) 
if data.ID == "Ok" then
DevAbs:set(HASSAN..'Abs:PinnedMsg'..msg.chat_id_,msg.reply_to_message_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تثبيت الرساله بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙البوت ليس ادمن هنا !', 1, 'md')
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات', 1, 'md')
return false  
end
end,nil)
end 
end
if Admin(msg) then
if text == "المميزين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:VipMem:'..msg.chat_id_)
text = "⌁︙قائمة المميزين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد مميزين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
if Manager(msg) then
if text == "الادمنيه" and ChCheck(msg) or text == "الادمنية" and ChCheck(msg) then 
local abs =  'Abs:Admins:'..msg.chat_id_
local List = DevAbs:smembers(HASSAN..abs)
text = "⌁︙قائمة الادمنيه ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد ادمنيه*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end
--     Source HASSAN     -- 
if Constructor(msg) then
if text == "المدراء" and ChCheck(msg) or text == "مدراء" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Managers:'..msg.chat_id_)
text = "⌁︙قائمة المدراء ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد مدراء*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المنظفين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Cleaner:'..msg.chat_id_)
text = "⌁︙قائمة المنظفين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد منظفين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
if BasicConstructor(msg) then
if text == "المنشئين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Constructor:'..msg.chat_id_)
text = "⌁︙قائمة المنشئين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد منشئين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
if AbsConstructor(msg) then
if text == "المنشئين الاساسيين" and ChCheck(msg) or text == "منشئين اساسيين" and ChCheck(msg) or text == "المنشئين الاساسين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_)
text = "⌁︙قائمة المنشئين الاساسيين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد منشئين اساسيين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
end 
if text ==("المنشئ") and ChCheck(msg) or text ==("المالك") and ChCheck(msg) then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حساب المنشئ محذوف", 1, "md")
return false  
end
local UserName = (dp.username_ or "GO_XXO")
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙منشئ المجموعه ↫ ["..dp.first_name_.."](T.me/"..UserName..")", 1, "md")  
end,nil)   
end
end
end,nil)   
end
if Admin(msg) then
if text == "المكتومين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Muted:'..msg.chat_id_)
text = "⌁︙قائمة المكتومين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد مكتومين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المقيدين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Tkeed:'..msg.chat_id_)
text = "⌁︙قائمة المقيدين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد مقيدين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المحظورين" and ChCheck(msg) or text == "المحضورين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:Ban:'..msg.chat_id_)
text = "⌁︙قائمة المحظورين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد محظورين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "قائمه المنع" and ChCheck(msg) then
local List = DevAbs:hkeys(HASSAN..'Abs:Filters:'..msg.chat_id_)
text = "⌁︙قائمة المنع ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k, v in pairs(List) do
text = text..k..'~ ❨ '..v..' ❩\n'
end
if #List == 0 then
text = "⌁︙لا توجد كلمات ممنوعه"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "المطايه" and ChCheck(msg) or text == "المطاية" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Donky:'..msg.chat_id_)
text = "⌁︙قائمة مطاية المجموعه 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد مطايه كلها اوادم* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "أبناء المتعة" and ChCheck(msg) or text == "ابناء المتعه" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don:'..msg.chat_id_)
text = "⌁︙قائمة أبناء المتعة 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد أبناء متعة* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "العفيريين" and ChCheck(msg) or text == "العفيرين" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don1:'..msg.chat_id_)
text = "⌁︙قائمة العفيريين 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد عفيريين* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "المهتدين" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don12:'..msg.chat_id_)
text = "⌁︙قائمة المهتدين 💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد مهتدين* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "ابناء نرجس الزانية" and ChCheck(msg) or text == "الشيعه" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don124:'..msg.chat_id_)
text = "⌁︙قائمة أبناء نرجس الزانية 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد شيعه هنا* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "الوهابية" and ChCheck(msg) or text == "الوهابيه" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don123:'..msg.chat_id_)
text = "⌁︙قائمة الوهابيه 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد وهابيه هنا* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "اللطامه" and ChCheck(msg) or text == "اللطامة" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don1234:'..msg.chat_id_)
text = "⌁︙قائمة اللطامه 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد لطامه هنا* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "زرارة ابو الضراط" and ChCheck(msg) or text == "الضراط" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN..'User:Don12345:'..msg.chat_id_)
text = "⌁︙قائمة زرارة ابو الضراط 😹💔 ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد زرارة ابو الضراط هنا* 😹💔"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
end 
if text == "المطورين الثانويين" and SecondSudo(msg) or text == "الثانويين" and SecondSudo(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:SecondSudo:')
text = "⌁︙قائمة المطورين الثانويين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*عذرا لم يتم رفع اي مطورين ثانويين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if SudoBot(msg) then
if text == "قائمه العام" and ChCheck(msg) or text == "المحظورين عام" and ChCheck(msg) or text == "المكتومين عام" and ChCheck(msg) or text == "↫ قائمه العام ⌁" and ChCheck(msg) then 
local BanAll = DevAbs:smembers(HASSAN..'Abs:BanAll:')
local MuteAll = DevAbs:smembers(HASSAN..'Abs:MuteAll:')
if #BanAll ~= 0 then 
text = "⌁︙قائمة المحظورين عام ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(BanAll) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = ""
end
if #MuteAll ~= 0 then 
text = text.."⌁︙قائمة المكتومين عام ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(MuteAll) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = text
end
if #BanAll ~= 0 or #MuteAll ~= 0 then 
text = text
else
text = "⌁︙*لم يتم حظر او كتم اي عضو*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المطورين" and ChCheck(msg) or text == "↫ المطورين ⌁" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:SudoBot:')
text = "⌁︙قائمة المطورين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local sudouser = DevAbs:get(HASSAN..'Abs:Sudos'..v) 
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."] ↬ Gps : "..(sudouser or 0).."\n"
else
text = text..""..k.."~ : `"..v.."` ↬ Gps : "..(sudouser or 0).."\n"
end end
if #List == 0 then
text = "⌁︙*عذرا لم يتم رفع اي مطورين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المدراء العامين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:ManagerAll:')
text = "⌁︙قائمة المدراء العامين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد مدراء عامين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
if text == "المميزين عام" and ChCheck(msg) or text == "المميزين العامين" and ChCheck(msg) then 
local List = DevAbs:smembers(HASSAN..'Abs:VipAll:')
text = "⌁︙قائمة المميزين العام ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⌁︙*لا يوجد مميزين عام*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source HASSAN     -- 
if text == "الادمنيه العامين" and ChCheck(msg) then 
local abs =  'Abs:AdminAll:'
local List = DevAbs:smembers(HASSAN..abs)
text = "⌁︙قائمة الادمنيه العامين ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevAbs:get(HASSAN..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⌁︙*لا يوجد ادمنيه عامين*"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, "md")
end  
if text ==("رفع المنشئ") and ChCheck(msg) or text ==("رفع المالك") and ChCheck(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
DevAbs:del(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_)
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
end
end
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حساب المنشئ محذوف", 1, "md")
return false  
end
local UserName = (dp.username_ or "GO_XXO")
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم رفع منشئ المجموعه ↫ ["..dp.first_name_.."](T.me/"..UserName..")", 1, "md") 
DevAbs:sadd(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,dp.id_)
end,nil)   
end,nil)   
end
end 
if Manager(msg) then
if text == 'منع' and tonumber(msg.reply_to_message_id_) > 0 and ChCheck(msg) then 
function filter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevAbs:sadd(HASSAN.."Abs:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم منع الملصق بنجاح لن يتم ارساله مجددا', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevAbs:sadd(HASSAN.."Abs:FilterPhoto"..msg.chat_id_,photo)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم منع الصوره بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
if result.content_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevAbs:sadd(HASSAN.."Abs:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم منع المتحركه بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,filter_by_reply) 
end
if text == 'الغاء منع' and tonumber(msg.reply_to_message_id_) > 0 and ChCheck(msg) then     
function unfilter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevAbs:srem(HASSAN.."Abs:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء منع الملصق يمكنهم ارساله الان', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevAbs:srem(HASSAN.."Abs:FilterPhoto"..msg.chat_id_,photo)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء منع الصوره يمكنهم ارسالها الان', 1, 'md')
return false
end
if result.content_.animation_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevAbs:srem(HASSAN.."Abs:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء منع المتحركه يمكنهم ارسالها الان', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,unfilter_by_reply) 
end
end
if text and (text == "تفعيل تحويل الصيغ" or text == "تفعيل التحويل") and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل تحويل الصيغ'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Thwel:Abs'..msg.chat_id_) 
end
if text and (text == "تعطيل تحويل الصيغ" or text == "تعطيل التحويل") and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل تحويل الصيغ'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Thwel:Abs'..msg.chat_id_,true)  
end
if text == 'تحويل' and not DevAbs:get(HASSAN..'Abs:Thwel:Abs'..msg.chat_id_) then  
if tonumber(msg.reply_to_message_id_) > 0 then 
function ThwelByReply(extra, result, success)
if result.content_.photo_ then 
local Abs = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.photo_.sizes_[1].photo_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Abs.result.file_path,msg.sender_user_id_..'.png') 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.png')
os.execute('rm -rf ./'..msg.sender_user_id_..'.png') 
end   
if result.content_.sticker_ then 
local Abs = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.sticker_.sticker_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Abs.result.file_path,msg.sender_user_id_..'.jpg') 
sendPhoto(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.jpg','⌁︙تم تحويل الملصق الى صوره')     
os.execute('rm -rf ./'..msg.sender_user_id_..'.jpg') 
end
if result.content_.audio_ then 
local Abs = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.audio_.audio_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Abs.result.file_path,msg.sender_user_id_..'.ogg') 
sendVoice(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.ogg',"⌁︙تم تحويل الـMp3 الى بصمه")
os.execute('rm -rf ./'..msg.sender_user_id_..'.ogg') 
end   
if result.content_.voice_ then 
local Abs = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.voice_.voice_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Abs.result.file_path,msg.sender_user_id_..'.mp3') 
sendAudio(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.mp3')  
os.execute('rm -rf ./'..msg.sender_user_id_..'.mp3') 
end
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ThwelByReply) 
end
end
if text ==("كشف") and msg.reply_to_message_id_ ~= 0 and ChCheck(msg) or text ==("ايدي") and msg.reply_to_message_id_ ~= 0 and ChCheck(msg) then 
function id_by_reply(extra, result, success) 
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..data.id_) or 0
local user_nkt = tonumber(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..data.id_) or 0)
if DevAbs:sismember(HASSAN..'Abs:BanAll:',result.sender_user_id_) then
Tkeed = 'محظور عام'
elseif DevAbs:sismember(HASSAN..'Abs:MuteAll:',result.sender_user_id_) then
Tkeed = 'مكتوم عام'
elseif DevAbs:sismember(HASSAN..'Abs:Ban:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'محظور'
elseif DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مكتوم'
elseif DevAbs:sismember(HASSAN..'Abs:Tkeed:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⌁︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAbs:sismember(HASSAN..'Abs:SudoBot:',result.sender_user_id_) and SudoBot(msg) then
sudobot = '\n⌁︙عدد الكروبات ↫ '..(DevAbs:get(HASSAN..'Abs:Sudos'..result.sender_user_id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(result.sender_user_id_,msg.chat_id_) ~= false then
CustomTitle = '\n⌁︙لقبه ↫ '..GetCustomTitle(result.sender_user_id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '⌁︙اسمه ↫ ['..CatchName(data.first_name_,20)..'](tg://user?id='..result.sender_user_id_..')\n⌁︙ايديه ↫ ❨ `'..result.sender_user_id_..'` ❩\n⌁︙رتبته ↫ '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n⌁︙رسائله ↫ ❨ '..user_msgs..' ❩\n⌁︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n⌁︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙معرفه ↫ [@'..data.username_..']\n⌁︙ايديه ↫ ❨ `'..result.sender_user_id_..'` ❩\n⌁︙رتبته ↫ '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n⌁︙رسائله ↫ ❨ '..user_msgs..' ❩\n⌁︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n⌁︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
end 
getMessage(msg.chat_id_, msg.reply_to_message_id_,id_by_reply) 
end
if text and text:match('^كشف @(.*)') and ChCheck(msg) or text and text:match('^ايدي @(.*)') and ChCheck(msg) then 
local username = text:match('^كشف @(.*)') or text:match('^ايدي @(.*)')
tdcli_function ({ID = "SearchPublicChat",username_ = username},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙*المعرف غير صحيح*', 1, 'md')
return false  end
if res.type_.ID == "ChannelChatInfo" then 
if res.type_.channel_.is_supergroup_ == false then
local ch = 'قناة'
local chn = '⌁︙نوع الحساب ↫ ❨ '..ch..' ❩\n⌁︙الايدي ↫ ❨ `'..res.id_..'` ❩\n⌁︙المعرف ↫ ❨ [@'..username..'] ❩\n⌁︙الاسم ↫ ❨ ['..res.title_..'] ❩'
Dev_Abs(msg.chat_id_, msg.id_, 1,chn, 1, 'md')
else
local gr = 'مجموعه'
local grr = '⌁︙نوع الحساب ↫ ❨ '..gr..' ❩\n⌁︙الايدي ↫ ❨ '..res.id_..' ❩\n⌁︙المعرف ↫ ❨ [@'..username..'] ❩\n⌁︙الاسم ↫ ❨ ['..res.title_..'] ❩'
Dev_Abs(msg.chat_id_, msg.id_, 1,grr, 1, 'md')
end
return false  end
if res.id_ then  
tdcli_function ({ID = "GetUser",user_id_ = res.id_},function(arg,data) 
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..res.id_) or 0
local user_nkt = tonumber(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..res.id_) or 0)
if DevAbs:sismember(HASSAN..'Abs:BanAll:',res.id_) then
Tkeed = 'محظور عام'
elseif DevAbs:sismember(HASSAN..'Abs:MuteAll:',res.id_) then
Tkeed = 'مكتوم عام'
elseif DevAbs:sismember(HASSAN..'Abs:Ban:'..msg.chat_id_,res.id_) then
Tkeed = 'محظور'
elseif DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_,res.id_) then
Tkeed = 'مكتوم'
elseif DevAbs:sismember(HASSAN..'Abs:Tkeed:'..msg.chat_id_,res.id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⌁︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAbs:sismember(HASSAN..'Abs:SudoBot:',res.id_) and SudoBot(msg) then
sudobot = '\n⌁︙عدد الكروبات ↫ '..(DevAbs:get(HASSAN..'Abs:Sudos'..res.id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(res.id_,msg.chat_id_) ~= false then
CustomTitle = '\n⌁︙لقبه ↫ '..GetCustomTitle(res.id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙الحساب محذوف', 1, 'md')
return false  end
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙معرفه ↫ [@'..data.username_..']\n⌁︙ايديه ↫ ❨ `'..res.id_..'` ❩\n⌁︙رتبته ↫ '..IdRank(res.id_, msg.chat_id_)..''..sudobot..'\n⌁︙رسائله ↫ ❨ '..user_msgs..' ❩\n⌁︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n⌁︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end,nil)
end 
end,nil)
return false 
end
if text and text:match('كشف (%d+)') and ChCheck(msg) or text and text:match('ايدي (%d+)') and ChCheck(msg) then 
local iduser = text:match('كشف (%d+)') or text:match('ايدي (%d+)')  
tdcli_function ({ID = "GetUser",user_id_ = iduser},function(arg,data) 
if data.message_ == "User not found" then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙لم يتم التعرف على الحساب', 1, 'md')
return false  
end
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..iduser) or 0
local user_nkt = tonumber(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..iduser) or 0)
if DevAbs:sismember(HASSAN..'Abs:BanAll:',iduser) then
Tkeed = 'محظور عام'
elseif DevAbs:sismember(HASSAN..'Abs:MuteAll:',iduser) then
Tkeed = 'مكتوم عام'
elseif DevAbs:sismember(HASSAN..'Abs:Ban:'..msg.chat_id_,iduser) then
Tkeed = 'محظور'
elseif DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_,iduser) then
Tkeed = 'مكتوم'
elseif DevAbs:sismember(HASSAN..'Abs:Tkeed:'..msg.chat_id_,iduser) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⌁︙القيود ↫ '..Tkeed
else 
Tked = '' 
end
if DevAbs:sismember(HASSAN..'Abs:SudoBot:',iduser) and SudoBot(msg) then
sudobot = '\n⌁︙عدد الكروبات ↫ '..(DevAbs:get(HASSAN..'Abs:Sudos'..iduser) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(iduser,msg.chat_id_) ~= false then
CustomTitle = '\n⌁︙لقبه ↫ '..GetCustomTitle(iduser,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '⌁︙اسمه ↫ ['..CatchName(data.first_name_,20)..'](tg://user?id='..iduser..')\n⌁︙ايديه ↫ ❨ `'..iduser..'` ❩\n⌁︙رتبته ↫ '..IdRank(data.id_, msg.chat_id_)..''..sudobot..'\n⌁︙رسائله ↫ ❨ '..user_msgs..' ❩\n⌁︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n⌁︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙معرفه ↫ [@'..data.username_..']\n⌁︙ايديه ↫ ❨ `'..iduser..'` ❩\n⌁︙رتبته ↫ '..IdRank(data.id_, msg.chat_id_)..''..sudobot..'\n⌁︙رسائله ↫ ❨ '..user_msgs..' ❩\n⌁︙تفاعله ↫ '..formsgs(user_msgs)..''..CustomTitle..'\n⌁︙نقاطه ↫ ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
return false 
end 
if text == 'كشف القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and ChCheck(msg) then 
function kshf_by_reply(extra, result, success)
if DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_,result.sender_user_id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevAbs:sismember(HASSAN..'Abs:Ban:'..msg.chat_id_,result.sender_user_id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevAbs:sismember(HASSAN..'Abs:BanAll:',result.sender_user_id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevAbs:sismember(HASSAN..'Abs:MuteAll:',result.sender_user_id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevAbs:sismember(HASSAN..'Abs:Tkeed:',result.sender_user_id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الحظر العام ↫ '..banall..'\n⌁︙الكتم العام ↫ '..muteall..'\n⌁︙الحظر ↫ '..banned..'\n⌁︙الكتم ↫ '..muted..'\n⌁︙التقيد ↫ '..tkeed..'', 1, 'md')  
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kshf_by_reply) 
end
if text and text:match('^كشف القيود @(.*)') and Admin(msg) and ChCheck(msg) then 
local username = text:match('^كشف القيود @(.*)') 
function kshf_by_username(extra, result, success)
if result.id_ then
if DevAbs:sismember(HASSAN..'Abs:Muted:'..msg.chat_id_,result.id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevAbs:sismember(HASSAN..'Abs:Ban:'..msg.chat_id_,result.id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevAbs:sismember(HASSAN..'Abs:BanAll:',result.id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevAbs:sismember(HASSAN..'Abs:MuteAll:',result.id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevAbs:sismember(HASSAN..'Abs:Tkeed:',result.id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الحظر العام ↫ '..banall..'\n⌁︙الكتم العام ↫ '..muteall..'\n⌁︙الحظر ↫ '..banned..'\n⌁︙الكتم ↫ '..muted..'\n⌁︙التقيد ↫ '..tkeed..'', 1, 'md')  
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')  
end
end
resolve_username(username,kshf_by_username) 
end
if text == 'رفع القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and ChCheck(msg) then 
function unbanreply(extra, result, success) 
if tonumber(result.sender_user_id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
ReplyStatus(msg,result.sender_user_id_,"Reply","⌁︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.sender_user_id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_,result.sender_user_id_) DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_,result.sender_user_id_) DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_,result.sender_user_id_)   
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply) 
end
if text and text:match('^رفع القيود (%d+)') and Admin(msg) and ChCheck(msg) then 
local user = text:match('رفع القيود (%d+)') 
if tonumber(user) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,user,"Reply","⌁︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..user.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_,user) DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_,user) DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_,user)   
end,nil)  
end
if text and text:match('^رفع القيود @(.*)') and Admin(msg) and ChCheck(msg) then  
local username = text:match('رفع القيود @(.*)')  
function unbanusername(extra,result,success)  
if result and result.message_ and result.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*المعرف غير صحيح*', 1, 'md')  
return false  
end
if result and result.type_ and result.type_.channel_ and result.type_.channel_.ID == "Channel" then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا معرف قناة وليس معرف حساب', 1, 'md') 
return false  
end
if tonumber(result.id_) == tonumber(HASSAN) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = result.id_},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,result.id_,"Reply","⌁︙تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_,result.id_) DevAbs:srem(HASSAN..'Abs:Ban:'..msg.chat_id_,result.id_) DevAbs:srem(HASSAN..'Abs:Muted:'..msg.chat_id_,result.id_)   
end,nil)   
end  
resolve_username(username,unbanusername) 
end 
if Manager(msg) then
if text and text:match("^تغيير الايدي$") and ChCheck(msg) or text and text:match("^تغير الايدي$") and ChCheck(msg) then 
local List = {
[[
゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .
゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .
゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .
゠𝙸𝙳 𖨈 #id 𖥲 .
]],
[[
➭- 𝒔𝒕𝒂𓂅 #stast 𓍯. 💕
➮- 𝒖𝒔𝒆𝒓𓂅 #username 𓍯. 💕
➭- 𝒎𝒔𝒈𝒆𓂅 #msgs 𓍯. 💕
➭- 𝒊𝒅 𓂅 #id 𓍯. 💕
]],
[[
⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★
• 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏⚚
• 🖤 | 𝑺𝑻𝑨 : #stast 🧙🏻‍♂️ ☥
• 🖤 | 𝑰𝑫 : #id ‌‌‏♕
• 🖤 | 𝑴𝑺𝑮 : #msgs 𓆊
]],
[[
┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .
├ 𝐌𝐒𝐆 𖤱 #msgs 𖦴 .
├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .
└ 𝐈𝐃 𖤱 #id 𖦴 .
]],
[[
𓄼🇮🇶 𝑼𝒔𝒆𝒓𝑵𝒂𝒎𝒆 : #username 
𓄼🇮🇶 𝑺𝒕𝒂𝒔𝒕 : #stast 
𓄼🇮🇶 𝒊𝒅 : #id 
𓄼🇮🇶 𝑮𝒂𝒎𝒆𝑺 : #game 
𓄼🇮🇶 𝑴𝒔𝒈𝒔 : #msgs
]],
[[
➞: 𝒔𝒕𝒂𓂅 #stast 𓍯➸💞.
➞: 𝒖𝒔𝒆𝒓𓂅 #username 𓍯➸💞.
➞: 𝒎𝒔𝒈𝒆𓂅 #msgs 𓍯➸💞.
➞: 𝒊𝒅 𓂅 #id 𓍯➸💞.
]],
[[
☆•𝐮𝐬𝐞𝐫 : #username 𖣬  
☆•𝐦𝐬𝐠  : #msgs 𖣬 
☆•𝐬𝐭𝐚 : #stast 𖣬 
☆•𝐢𝐝  : #id 𖣬
]],
[[
- 𓏬 𝐔𝐬𝐄𝐫 : #username 𓂅 .
- 𓏬 𝐌𝐬𝐆  : #msgs 𓂅 .
- 𓏬 𝐒𝐭𝐀 : #stast 𓂅 .
- 𓏬 𝐈𝐃 : #id 𓂅 .
]],
[[
.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  
.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast  
.𖣂 𝙡𝘿 , #id  
.𖣂 𝙂𝙖𝙢𝙨 , #game 
.𖣂 𝙢𝙨𝙂𝙨 , #msgs
]],
[[
⌁︙𝐔𝐒𝐄𝐑 ↬ #username 
⌁︙𝐈𝐃 ↬ #id
⌁︙𝐒𝐓𝐀𝐒𝐓 ↬ #stast
⌁︙𝐀𝐔𝐓𝐎 ↬ #cont 
⌁︙𝐌𝐀𝐒𝐆 ↬ #msgs
⌁︙𝐆𝐀𝐌𝐄 ↬ #game
]],
[[
ᯓ 𝗨𝗦𝗘𝗥𝗡𝗮𝗺𝗘 . #username 🇺🇸 ꙰
ᯓ 𝗦𝗧𝗮𝗦𝗧 . #stast 🇺🇸 ꙰
ᯓ 𝗜𝗗 . #id 🇺🇸 ꙰
ᯓ 𝗚𝗮𝗺𝗘𝗦 . #game 🇺🇸 ꙰
ᯓ 𝗺𝗦𝗚𝗦 . #msgs 🇺🇸 ꙰
]],
[[
- ᴜѕᴇʀɴᴀᴍᴇ ➥• #username .
- ᴍѕɢѕ ➥• #msgs .
- ѕᴛᴀᴛѕ ➥• #stast .
- ʏᴏᴜʀ ɪᴅ ➥• #id  .
- ᴇᴅɪᴛ ᴍsɢ ➥• #edit .
- ᴅᴇᴛᴀɪʟs ➥• #auto . 
- ɢᴀᴍᴇ ➥• #game .
]]}
local Text_Rand = List[math.random(#List)]
DevAbs:set(HASSAN.."Abs:GpIds:Text"..msg.chat_id_,Text_Rand)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم تغير كليشة الايدي")  
end
if SecondSudo(msg) then
if text and text:match("^تعيين الايدي العام$") or text and text:match("^تعين الايدي العام$") or text and text:match("^تعيين كليشة الايدي$") then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙رجائا اتبع التعليمات للتعيين \n⌁︙لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
DevAbs:set("HASSAN:New:id:"..HASSAN..msg.sender_user_id_,'HASSANTEAM')
return "HASSANTEAM"
end
if text and DevAbs:get("HASSAN:New:id:"..HASSAN..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ كليشة الايدي', 1, 'md')
DevAbs:del("HASSAN:New:id:"..HASSAN..msg.sender_user_id_)
return false
end
DevAbs:del("HASSAN:New:id:"..HASSAN..msg.sender_user_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ كليشة الايدي العامه', 1, 'md')
DevAbs:set(HASSAN.."Abs:AllIds:Text",text)
return false
end
if text and text:match("^حذف الايدي العام$") or text and text:match("^مسح الايدي العام$") or text and text:match("^حذف كليشة الايدي$") then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف كليشة الايدي العامه")  
DevAbs:del(HASSAN.."Abs:AllIds:Text")
end
end
if text and text:match("^تعيين الايدي$") and ChCheck(msg) or text and text:match("^تعين الايدي$") and ChCheck(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙رجائا اتبع التعليمات للتعيين \n⌁︙لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
DevAbs:set("HASSAN:New:id:"..HASSAN..msg.chat_id_..msg.sender_user_id_,'HASSANTEAM')
return "HASSANTEAM"
end
if text and Manager(msg) and DevAbs:get("HASSAN:New:id:"..HASSAN..msg.chat_id_..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ كليشة الايدي', 1, 'md')
DevAbs:del("HASSAN:New:id:"..HASSAN..msg.chat_id_..msg.sender_user_id_)
return false
end
DevAbs:del("HASSAN:New:id:"..HASSAN..msg.chat_id_..msg.sender_user_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ الكليشه الجديده', 1, 'md')
DevAbs:set(HASSAN.."Abs:GpIds:Text"..msg.chat_id_,text)
return false
end
if text and text:match("^حذف الايدي$") and ChCheck(msg) or text and text:match("^مسح الايدي$") and ChCheck(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف كليشة الايدي")  
DevAbs:del(HASSAN.."Abs:GpIds:Text"..msg.chat_id_)
end
end
if msg.reply_to_message_id_ ~= 0 then
return ""
else
if text and (text:match("^ايدي$") or text:match("^id$") or text:match("^Id$")) and ChCheck(msg) then
function HASSANTEAM(extra,abbas,success)
if abbas.username_ then username = '@'..abbas.username_ else username = 'لا يوجد' end
if GetCustomTitle(msg.sender_user_id_,msg.chat_id_) ~= false then CustomTitle = GetCustomTitle(msg.sender_user_id_,msg.chat_id_) else CustomTitle = 'لا يوجد' end
local function getpro(extra, abbas, success) 
local msgsday = DevAbs:get(HASSAN..'Abs:UsersMsgs'..HASSAN..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local edit_msg = DevAbs:get(HASSAN..'Abs:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local user_nkt = tonumber(DevAbs:get(HASSAN..'Abs:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
local cont = (tonumber(DevAbs:get(HASSAN..'Abs:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local msguser = tonumber(DevAbs:get(HASSAN..'Abs:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local Texting = {"مو صوره ظيم بالنبي ،🤤💞","مقتنع بصورتك !؟ 😹🖤","ملاك وناسيك بكروبنه ،🤤💞","وفالله ،🤤💞","كشخه برب ،😉🤍","لزكت بيها دغيرها عاد ،😒😕","صورتك مامرتاحلها ،🙄😶","حلغوم والله ،🥺💘","مو صوره غنبله براسها ٦٠ حظ ،😹🤍"}
local Description = Texting[math.random(#Texting)]
if abbas.photos_[0] then
if not DevAbs:get(HASSAN..'Abs:Lock:Id'..msg.chat_id_) then 
if not DevAbs:get(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_) then 
if DevAbs:get(HASSAN.."Abs:AllIds:Text") then
newpicid = DevAbs:get(HASSAN.."Abs:AllIds:Text")
newpicid = newpicid:gsub('#username',(username or 'لا يوجد'))
newpicid = newpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newpicid = newpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
newpicid = newpicid:gsub('#game',(user_nkt or 'لا يوجد'))
newpicid = newpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
newpicid = newpicid:gsub('#cont',(cont or 'لا يوجد'))
newpicid = newpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newpicid = newpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
newpicid = newpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newpicid = newpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newpicid = newpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#Description',(Description or 'لا يوجد'))
else
newpicid = "⌁︙"..Description.."\n⌁︙معرفك ↫ ❨ "..username.." ❩\n⌁︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n⌁︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⌁︙رسائلك ↫ ❨ "..user_msgs.." ❩\n⌁︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n⌁︙تفاعلك ↫ "..formsgs(msguser).."\n⌁︙نقاطك ↫ ❨ "..user_nkt.." ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end 
if not DevAbs:get(HASSAN.."Abs:GpIds:Text"..msg.chat_id_) then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, abbas.photos_[0].sizes_[1].photo_.persistent_id_,newpicid,msg.id_,msg.id_.."")
else 
local new_id = DevAbs:get(HASSAN.."Abs:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(abbas.total_count_ or '')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, abbas.photos_[0].sizes_[1].photo_.persistent_id_,new_id,msg.id_,msg.id_.."")
end
else
if DevAbs:get(HASSAN.."Abs:AllIds:Text") then
newallid = DevAbs:get(HASSAN.."Abs:AllIds:Text")
newallid = newallid:gsub('#username',(username or 'لا يوجد'))
newallid = newallid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newallid = newallid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newallid = newallid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
newallid = newallid:gsub('#game',(user_nkt or 'لا يوجد'))
newallid = newallid:gsub('#edit',(edit_msg or 'لا يوجد'))
newallid = newallid:gsub('#cont',(cont or 'لا يوجد'))
newallid = newallid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newallid = newallid:gsub('#msgday',(msgsday or 'لا يوجد'))
newallid = newallid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newallid = newallid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newallid = newallid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newallid = newallid:gsub('#Description',(Description or 'لا يوجد'))
else
newallid = "⌁︙معرفك ↫ ❨ "..username.." ❩\n⌁︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n⌁︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⌁︙رسائلك ↫ ❨ "..user_msgs.." ❩\n⌁︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n⌁︙تفاعلك ↫ "..formsgs(msguser).."\n⌁︙نقاطك ↫ ❨ "..user_nkt.." ❩"
end 
if not DevAbs:get(HASSAN.."Abs:GpIds:Text"..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, newallid, 1, 'html')
else
local new_id = DevAbs:get(HASSAN.."Abs:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
Dev_Abs(msg.chat_id_, msg.id_, 1, new_id, 1, 'html')  
end
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عذرا الايدي معطل ', 1, 'md')
end
else
if DevAbs:get(HASSAN.."Abs:AllIds:Text") then
notpicid = DevAbs:get(HASSAN.."Abs:AllIds:Text")
notpicid = notpicid:gsub('#username',(username or 'لا يوجد'))
notpicid = notpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
notpicid = notpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
notpicid = notpicid:gsub('#game',(user_nkt or 'لا يوجد'))
notpicid = notpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
notpicid = notpicid:gsub('#cont',(cont or 'لا يوجد'))
notpicid = notpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
notpicid = notpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
notpicid = notpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
notpicid = notpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
notpicid = notpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#Description',(Description or 'لا يوجد'))
else
notpicid = "⌁︙لا استطيع عرض صورتك لانك قمت بحظر البوت او انك لاتمتلك صوره في بروفايلك\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙معرفك ↫ ❨ "..username.." ❩\n⌁︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n⌁︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⌁︙رسائلك ↫ ❨ "..user_msgs.." ❩\n⌁︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n⌁︙تفاعلك ↫ "..formsgs(msguser).."\n⌁︙نقاطك ↫ ❨ "..user_nkt.." ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end 
if not DevAbs:get(HASSAN..'Abs:Lock:Id'..msg.chat_id_) then
if not DevAbs:get(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, notpicid, 1, 'html')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙معرفك ↫ ❨ "..username.." ❩\n⌁︙ايديك ↫ ❨ "..msg.sender_user_id_.." ❩\n⌁︙رتبتك ↫ "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⌁︙رسائلك ↫ ❨ "..user_msgs.." ❩\n⌁︙سحكاتك ↫ ❨ "..edit_msg.." ❩\n⌁︙رسائلك ↫ ❨ "..user_msgs.." ❩\n⌁︙تفاعلك ↫ "..formsgs(msguser).."\n⌁︙نقاطك ↫ ❨ "..user_nkt.." ❩", 1, 'md')
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عذرا الايدي معطل', 1, 'md')
end end end
tdcli_function ({ ID = "GetUserProfilePhotos", user_id_ = msg.sender_user_id_, offset_ = 0, limit_ = 1 }, getpro, nil)
end
getUser(msg.sender_user_id_, HASSANTEAM)
end
end 
if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^قفل (.*)$") then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "التعديل" then
if not DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التعديل")  
DevAbs:set(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التعديل بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "التعديل الميديا" or LockText[2] == "تعديل الميديا" then
if not DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل تعديل الميديا")  
DevAbs:set(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تعديل الميديا بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه" then
if not DevAbs:get(HASSAN..'Abs:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الفارسيه")  
DevAbs:set(HASSAN..'Abs:Lock:Farsi'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفارسيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفشار" then
if DevAbs:get(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الفشار")  
DevAbs:del(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفشار بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الطائفيه" then
if DevAbs:get(HASSAN..'Abs:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الطائفيه")  
DevAbs:del(HASSAN..'Abs:Lock:Taf'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الطائفيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكفر" then
if DevAbs:get(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الكفر")  
DevAbs:del(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الكفر بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه بالطرد" then
if not DevAbs:get(HASSAN..'Abs:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الفارسيه بالطرد")  
DevAbs:set(HASSAN..'Abs:Lock:FarsiBan'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفارسيه بالطرد بالفعل مقفله ', 1, 'md')
end
end
if LockText[2] == "البوتات" or LockText[2] == "البوتات بالحذف" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل البوتات بالحذف")  
DevAbs:set(HASSAN.."Abs:Lock:Bots"..msg.chat_id_,"del")  
end
if LockText[2] == "البوتات بالطرد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل البوتات بالطرد")  
DevAbs:set(HASSAN.."Abs:Lock:Bots"..msg.chat_id_,"kick")  
end
if LockText[2] == "البوتات بالتقييد" or LockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل البوتات بالتقيد")  
DevAbs:set(HASSAN.."Abs:Lock:Bots"..msg.chat_id_,"ked")  
end
if LockText[2] == "التكرار" or LockText[2] == "التكرار بالحذف" then 
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","del")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التكرار بالحذف")  
end
if LockText[2] == "التكرار بالطرد" then 
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","kick")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التكرار بالطرد")  
end
if LockText[2] == "التكرار بالتقيد" or LockText[2] == "التكرار بالتقييد" then 
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التكرار بالتقيد")  
end
if LockText[2] == "التكرار بالكتم" then 
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","mute")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التكرار بالكتم")  
end
if BasicConstructor(msg) then
if LockText[2] == "التثبيت" then
if not DevAbs:get(HASSAN..'Abs:Lock:Pin'..msg.chat_id_) then
tdcli_function ({ ID = "GetChannelFull",  channel_id_ = msg.chat_id_:gsub("-100","") }, function(arg,data)  DevAbs:set(HASSAN.."Abs:PinnedMsg"..msg.chat_id_,data.pinned_message_id_)  end,nil)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التثبيت")  
DevAbs:set(HASSAN..'Abs:Lock:Pin'..msg.chat_id_,true)
DevAbs:sadd(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_) 
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التثبيت بالفعل مقفل في المجموعه', 1, 'md')
end end end
end
end
end
if Admin(msg) then
if text and (text:match("^ضع تكرار (%d+)$") or text:match("^وضع تكرار (%d+)$")) then   
local TextSpam = text:match("ضع تكرار (%d+)$") or text:match("وضع تكرار (%d+)$")
if tonumber(TextSpam) < 2 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بتحديد عدد اكبر من 2 للتكرار', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم وضع عدد التكرار ↫ '..TextSpam, 1, 'md')
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Num:Spam" ,TextSpam) 
end
end
if text and (text:match("^ضع زمن التكرار (%d+)$") or text:match("^وضع زمن التكرار (%d+)$")) then  
local TextSpam = text:match("ضع زمن التكرار (%d+)$") or text:match("وضع زمن التكرار (%d+)$")
DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Num:Spam:Time" ,TextSpam) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم وضع زمن التكرار ↫ '..TextSpam, 1, 'md')
end
if Manager(msg) then
if text and text == 'تفعيل الايدي بالصوره' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الايدي بالصوره بالتاكيد مفعل', 1, 'md')
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الايدي بالصوره'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_)
end end
if text and text == 'تعطيل الايدي بالصوره' and ChCheck(msg) then
if DevAbs:get(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الايدي بالصوره بالتاكيد معطل', 1, 'md')
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الايدي بالصوره'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:Id:Photo'..msg.chat_id_,true)
end end 

if text and text == 'تفعيل الايدي' and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Lock:Id'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الايدي بالتاكيد مفعل ', 1, 'md')
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الايدي بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:Id'..msg.chat_id_)
end end 
if text and text == 'تعطيل الايدي' and ChCheck(msg) then
if DevAbs:get(HASSAN..'Abs:Lock:Id'..msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الايدي بالتاكيد معطل ', 1, 'md')
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الايدي بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:Id'..msg.chat_id_,true)
end end
end
if text == 'ضع رابط' or text == 'وضع رابط' or text == 'ضع الرابط' or text == 'وضع الرابط' then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevAbs:setex(HASSAN.."Abs:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
if text == 'انشاء رابط' or text == 'انشاء الرابط' then
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if not DevAbs:get(HASSAN.."Abs:Groups:Links"..msg.chat_id_)  then 
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
DevAbs:set(HASSAN.."Abs:Groups:Links"..msg.chat_id_,LinkGroup) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم انشاء رابط جديد ارسل ↫ الرابط', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ليست لدي صلاحية دعوة المستخدمين عبر الرابط يرجى التحقق من الصلاحيات', 1, 'md')
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevAbs:setex(HASSAN.."Abs:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
end
end
if Admin(msg) then
if text and text:match("^تفعيل الترحيب$") and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الترحيب بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN.."Abs:Lock:Welcome"..msg.chat_id_,true)
end
if text and text:match("^تعطيل الترحيب$") and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الترحيب بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN.."Abs:Lock:Welcome"..msg.chat_id_)
end
if DevAbs:get(HASSAN..'Abs:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ كليشة الترحيب', 1, 'md')
DevAbs:del(HASSAN..'Abs:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAbs:del(HASSAN..'Abs:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ كليشة الترحيب', 1, 'md')
return false   
end
if text and text:match("^ضع ترحيب$") and ChCheck(msg) or text and text:match("^وضع ترحيب$") and ChCheck(msg) or text and text:match("^اضف ترحيب$") and ChCheck(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي الترحيب الان\n⌁︙تستطيع اضافة مايلي ↫ ⤈\n⌁︙دالة عرض الاسم ↫ firstname\n⌁︙دالة عرض المعرف ↫ username', 1, 'md')
DevAbs:set(HASSAN..'Abs:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
if text and text:match("^حذف الترحيب$") and ChCheck(msg) or text and text:match("^حذف ترحيب$") and ChCheck(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف الترحيب")  
DevAbs:del(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_)
end
if text and text:match("^جلب الترحيب$") and ChCheck(msg) or text and text:match("^جلب ترحيب$") and ChCheck(msg) or text and text:match("^الترحيب$") and ChCheck(msg) then
local wel = DevAbs:get(HASSAN..'Abs:Groups:Welcomes'..msg.chat_id_)
if wel then
Dev_Abs(msg.chat_id_, msg.id_, 1, wel, 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لم يتم وضع الترحيب \n⌁︙ارسل ↫ ضع ترحيب للحفظ ', 1, 'md')
end
end
if DevAbs:get(HASSAN..'Abs:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_) then  
if text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء حفظ الوصف", 1, 'md')
DevAbs:del(HASSAN..'Abs:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAbs:del(HASSAN..'Abs:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
https.request('https://api.telegram.org/bot'..TokenBot..'/setChatDescription?chat_id='..msg.chat_id_..'&description='..text) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تغيير وصف المجموعه', 1, 'md')
return false  
end 
if text and text:match("^ضع وصف$") and ChCheck(msg) or text and text:match("^وضع وصف$") and ChCheck(msg) then  
DevAbs:set(HASSAN..'Abs:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_,true)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي الوصف الان', 1, 'md')
end
if text and text == "منع" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then       
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل لي الكلمه الان", 1, 'md') 
DevAbs:set(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_,"add")  
return false  
end    
if DevAbs:get(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "add" then
if text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر المنع', 1, 'md')
DevAbs:del(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم منع الكلمه ↫ "..text, 1, 'html')
DevAbs:del(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
DevAbs:hset(HASSAN..'Abs:Filters:'..msg.chat_id_, text,'newword')
return false
end
if text and text == "الغاء منع" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then       
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل لي الكلمه الان", 1, 'md') 
DevAbs:set(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_,"del")  
return false  
end    
if DevAbs:get(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "del" then   
if text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر الغاء المنع', 1, 'md')
DevAbs:del(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
if not DevAbs:hget(HASSAN..'Abs:Filters:'..msg.chat_id_, text) then  
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙الكلمه ↫ "..text.." غير ممنوعه", 1, 'html')
DevAbs:del(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
else
DevAbs:hdel(HASSAN..'Abs:Filters:'..msg.chat_id_, text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙الكلمه ↫ "..text.." تم الغاء منعها", 1, 'html')
DevAbs:del(HASSAN.."Abs:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
end
return false
end
if SudoBot(msg) then
if text and text == "الاحصائيات" and ChCheck(msg) or text and text == "↫ الاحصائيات ⌁" then
local gps = DevAbs:scard(HASSAN.."Abs:Groups") local users = DevAbs:scard(HASSAN.."Abs:Users") 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙احصائيات البوت ↫ ⤈\n⌁︙عدد المشتركين ↫ ❨ '..users..' ❩\n⌁︙عدد المجموعات ↫ ❨ '..gps..' ❩', 1, 'md')
end
if text and text == "المشتركين" and ChCheck(msg) or text and text == "↫ المشتركين ⌁" then
local users = DevAbs:scard(HASSAN.."Abs:Users")
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عدد المشتركين ↫ ❨ '..users..' ❩', 1, 'md')
end
end
if text and text == 'المجموعات' and ChCheck(msg) or text and text == '↫ المجموعات ⌁' then
if not SudoBot(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطورين فقط ', 1, 'md')
else
local List = DevAbs:smembers(HASSAN.."Abs:Groups")
local t = '⌁︙مجموعات البوت ↫ ⤈ \n'
for k,v in pairs(List) do
t = t..k.."~ : `"..v.."`\n" 
end
if #List == 0 then
t = '⌁︙لا يوجد مجموعات مفعله'
end
Dev_Abs(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end end
if text and text:match('^تنظيف (%d+)$') and ChCheck(msg) then  
if not DevAbs:get(HASSAN..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_) then  
local Number = tonumber(text:match('^تنظيف (%d+)$')) 
if Number > 1000 then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لاتستطيع تنظيف اكثر من 1000 رساله', 1, 'md')
return false  
end  
local Message = msg.id_
for i=1,tonumber(Number) do
DeleteMessage(msg.chat_id_,{[0]=Message})
Message = Message - 1048576 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تنظيف *'..Number..'* من الرسائل', 1, 'md')
DevAbs:setex(HASSAN..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_,300,true)
end 
end
if text == "تنظيف المشتركين" and SecondSudo(msg) and ChCheck(msg) then 
local pv = DevAbs:smembers(HASSAN.."Abs:Users")
local sendok = 0
for i = 1, #pv do
tdcli_function({ID='GetChat',chat_id_ = pv[i]
},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",  
chat_id_ = pv[i], action_ = {  ID = "SendMessageTypingAction", progress_ = 100} 
},function(arg,data) 
if data.ID and data.ID == "Ok" then
else
DevAbs:srem(HASSAN.."Abs:Users",pv[i])
sendok = sendok + 1
end
if #pv == i then 
if sendok == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙*لا يوجد مشتركين وهميين*', 1, 'md')
else
local ok = #pv - sendok
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عدد المشتركين الان ↫ { '..#pv..' }\n⌁︙تم حذف ↫ { '..sendok..' } من المشتركين\n⌁︙العدد الحقيقي الان  ↫ ( '..ok..' ) \n', 1, 'md')
end
end
end,nil)
end,nil)
end
return false
end
if text == "تنظيف الكروبات" and SecondSudo(msg) and ChCheck(msg) or text == "تنظيف المجموعات" and SecondSudo(msg) and ChCheck(msg) then 
local group = DevAbs:smembers(HASSAN.."Abs:Groups")
local w = 0
local q = 0
for i = 1, #group do
tdcli_function({ID='GetChat',chat_id_ = group[i]
},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
DevAbs:srem(HASSAN.."Abs:Groups",group[i]) 
changeChatMemberStatus(group[i], HASSAN, "Left")
w = w + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevAbs:srem(HASSAN.."Abs:Groups",group[i]) 
q = q + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevAbs:srem(HASSAN.."Abs:Groups",group[i]) 
q = q + 1
end
if data and data.code_ and data.code_ == 400 then
DevAbs:srem(HASSAN.."Abs:Groups",group[i]) 
w = w + 1
end
if #group == i then 
if (w + q) == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙*لاتوجد مجموعات وهميه*', 1, 'md')   
else
local HASSANgp2 = (w + q)
local HASSANgp3 = #group - HASSANgp2
if q == 0 then
HASSANgp2 = ''
else
HASSANgp2 = '\n⌁︙تم حذف ↫ { '..q..' } مجموعه من البوت'
end
if w == 0 then
HASSANgp1 = ''
else
HASSANgp1 = '\n⌁︙تم حذف ↫ { '..w..' } مجموعه بسبب تنزيل البوت الى عضو'
end
Dev_Abs(msg.chat_id_, msg.id_, 1,'⌁︙عدد الكروبات الان ↫ { '..#group..' }'..HASSANgp1..''..HASSANgp2..'\n⌁︙العدد الحقيقي الان  ↫ ( '..HASSANgp3..' ) \n ', 1, 'md')
end end
end,nil)
end
return false
end 
end
if text == "تفعيل امسح" and Constructor(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل امسح بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:Clean'..msg.chat_id_,true)  
end
if text == "تعطيل امسح" and Constructor(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل امسح بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:Clean'..msg.chat_id_) 
end
if Cleaner(msg) then
if DevAbs:get(HASSAN..'Abs:Lock:Clean'..msg.chat_id_) then 
if text == "الميديا" and ChCheck(msg) or text == "عدد الميديا" and ChCheck(msg) then 
local M = DevAbs:scard(HASSAN.."Abs:cleaner"..msg.chat_id_)
if M ~= 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙عدد الميديا ↫ "..M, 1, 'md') 
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتوجد ميديا هنا", 1, 'md') 
end end
if text == "امسح" and ChCheck(msg) or text == "تنظيف ميديا" and ChCheck(msg) or text == "تنظيف الميديا" and ChCheck(msg) then
local List = DevAbs:smembers(HASSAN.."Abs:cleaner"..msg.chat_id_)
local Del = 0
for k,v in pairs(List) do
Del = (Del + 1)
local Message = v
DeleteMessage(msg.chat_id_,{[0]=Message})
Message = Message - 1048576 
end
if Del ~= 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف "..Del.." من الميديا", 1, 'md') 
DevAbs:del(HASSAN.."Abs:cleaner"..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتوجد ميديا هنا", 1, 'md') 
end end 
end
end
if Admin(msg) then
if text == "تنظيف تعديل" or text == "تنظيف التعديل" and ChCheck(msg) then   
Abs_Del = {[0]= msg.id_}
local Message = msg.id_
for i=1,100 do
Message = Message - 1048576
Abs_Del[i] = Message
end
tdcli_function({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Abs_Del},function(arg,data)
new = 0
Abs_Del2 = {}
for i=0 ,data.total_count_ do
if data.messages_[i] and (not data.messages_[i].edit_date_ or data.messages_[i].edit_date_ ~= 0) then
Abs_Del2[new] = data.messages_[i].id_
new = new + 1
end
end
DeleteMessage(msg.chat_id_,Abs_Del2)
end,nil)  
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تنظيف 100 من الرسائل المعدله', 1, 'md')
end
if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^فتح (.*)$") then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "التعديل" then
if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح التعديل")  
DevAbs:del(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التعديل بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التعديل الميديا" or UnLockText[2] == "تعديل الميديا" then
if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح تعديل الميديا")  
DevAbs:del(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تعديل الميديا بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه" then
if DevAbs:get(HASSAN..'Abs:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الفارسيه")  
DevAbs:del(HASSAN..'Abs:Lock:Farsi'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفارسيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفشار" then
if not DevAbs:get(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الفشار")  
DevAbs:set(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفشار بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الطائفيه" then
if not DevAbs:get(HASSAN..'Abs:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الطائفيه")  
DevAbs:set(HASSAN..'Abs:Lock:Taf'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الطائفيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكفر" then
if not DevAbs:get(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الكفر")  
DevAbs:set(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الكفر بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه بالطرد" then
if DevAbs:get(HASSAN..'Abs:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الفارسيه بالطرد")  
DevAbs:del(HASSAN..'Abs:Lock:FarsiBan'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفارسيه بالطرد بالفعل مفتوحه', 1, 'md')
end
end
if UnLockText[2] == "البوتات" or UnLockText[2] == "البوتات بالطرد" or UnLockText[2] == "البوتات بالتقييد" or UnLockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح البوتات")  
DevAbs:del(HASSAN.."Abs:Lock:Bots"..msg.chat_id_)  
end
if UnLockText[2] == "التكرار" then 
DevAbs:hdel(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح التكرار")  
end
if BasicConstructor(msg) then
if UnLockText[2] == "التثبيت" then
if DevAbs:get(HASSAN..'Abs:Lock:Pin'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح التثبيت")  
DevAbs:del(HASSAN..'Abs:Lock:Pin'..msg.chat_id_)
DevAbs:srem(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التثبيت بالفعل مفتوح في المجموعه', 1, 'md')
end end end
end
end
if Admin(msg) then
if text and text:match("^قفل (.*)$") then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "الدردشة" then
if not DevAbs:get(HASSAN..'Abs:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل المنتدى لذا سيحذف البوت اي رسالة مرسلة من الاعضاء لحين فتحه من قبل المشرفين إلى ان نلقاكم بإذن الله تعالى لكم منا كل الشكر والتقدير")  
DevAbs:set(HASSAN..'Abs:Lock:Text'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الدردشة بالفعل مقفله في المنتدى لا تلح بارك الله فيك', 1, 'md')
end
end
if LockText[2] == "الاونلاين" then
if not DevAbs:get(HASSAN..'Abs:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الاونلاين")  
DevAbs:set(HASSAN..'Abs:Lock:Inline'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاونلاين بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصور" then
if not DevAbs:get(HASSAN..'Abs:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الصور")  
DevAbs:set(HASSAN..'Abs:Lock:Photo'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الصور بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكلايش" then
if not DevAbs:get(HASSAN..'Abs:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الكلايش")  
DevAbs:set(HASSAN..'Abs:Lock:Spam'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الكلايش بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الدخول" then
if not DevAbs:get(HASSAN..'Abs:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الدخول")  
DevAbs:set(HASSAN..'Abs:Lock:Join'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الدخول بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفيديو" then
if not DevAbs:get(HASSAN..'Abs:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الفيديو")  
DevAbs:set(HASSAN..'Abs:Lock:Videos'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفيديو بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "المتحركه" then
if not DevAbs:get(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل المتحركه")  
DevAbs:set(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المتحركه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاغاني" then
if not DevAbs:get(HASSAN..'Abs:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الاغاني")  
DevAbs:set(HASSAN..'Abs:Lock:Music'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاغاني بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصوت" then
if not DevAbs:get(HASSAN..'Abs:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الصوت")  
DevAbs:set(HASSAN..'Abs:Lock:Voice'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الصوت بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الروابط" then
if not DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الروابط")  
DevAbs:set(HASSAN..'Abs:Lock:Links'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الروابط بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المواقع" then
if not DevAbs:get(HASSAN..'Abs:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل المواقع")  
DevAbs:set(HASSAN..'Abs:Lock:Location'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المواقع بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المعرف" or LockText[2] == "المعرفات" then
if not DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل المعرفات")  
DevAbs:set(HASSAN..'Abs:Lock:Tags'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المعرفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملفات" then
if not DevAbs:get(HASSAN..'Abs:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الملفات")  
DevAbs:set(HASSAN..'Abs:Lock:Document'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الملفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الهاشتاك" or LockText[2] == "التاك" then
if not DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الهاشتاك")  
DevAbs:set(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الهاشتاك بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الجهات" then
if not DevAbs:get(HASSAN..'Abs:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الجهات")  
DevAbs:set(HASSAN..'Abs:Lock:Contact'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '️⌁︙الجهات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الشبكات" then
if not DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الشبكات")  
DevAbs:set(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_,true) 
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الشبكات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "العربيه" then
if not DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل العربيه")  
DevAbs:set(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العربيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الانكليزيه" then
if not DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الانكليزيه")  
DevAbs:set(HASSAN..'Abs:Lock:English'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الانكليزيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملصقات" then
if not DevAbs:get(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الملصقات")  
DevAbs:set(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الملصقات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الماركداون" then
if not DevAbs:get(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الماركداون")  
DevAbs:set(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الماركداون بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاشعارات" then
if not DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل الاشعارات")  
DevAbs:set(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاشعارات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "التوجيه" then
if not DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التوجيه")  
DevAbs:set(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_,true)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التوجيه بالفعل مقفل في المجموعه', 1, 'md')
end
end
end
end
if Admin(msg) then
if text and text:match("^فتح (.*)$") then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "الدردشة" then
if DevAbs:get(HASSAN..'Abs:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح المنتدى إدارة المنتدى الأن اصبح بأمكانكم الكلام نعتذر على قفل المنتدى")  
DevAbs:del(HASSAN..'Abs:Lock:Text'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الدردشة مفتوحه في المجموعه لعل الشخص الذي لا يستطيع التكلم مكتوم او الدردشة مقفوله من بوت أخر وأن كان مكتوم اكتب الغاء الكتم', 1, 'md')
end
end
if UnLockText[2] == "الصور" then
if DevAbs:get(HASSAN..'Abs:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الصور")  
DevAbs:del(HASSAN..'Abs:Lock:Photo'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الصور بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكلايش" then
if DevAbs:get(HASSAN..'Abs:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الكلايش")  
DevAbs:del(HASSAN..'Abs:Lock:Spam'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الكلايش بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الدخول" then
if DevAbs:get(HASSAN..'Abs:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الدخول")  
DevAbs:del(HASSAN..'Abs:Lock:Join'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الدخول بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفيديو" then
if DevAbs:get(HASSAN..'Abs:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الفيديو")  
DevAbs:del(HASSAN..'Abs:Lock:Videos'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الفيديو بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملفات" then
if DevAbs:get(HASSAN..'Abs:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الملفات")  
DevAbs:del(HASSAN..'Abs:Lock:Document'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الملفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاونلاين" then
if DevAbs:get(HASSAN..'Abs:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الاونلاين")  
DevAbs:del(HASSAN..'Abs:Lock:Inline'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاونلاين بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الماركداون" then
if DevAbs:get(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الماركداون")  
DevAbs:del(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الماركداون بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المتحركه" then
if DevAbs:get(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح المتحركه")  
DevAbs:del(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المتحركه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاغاني" then
if DevAbs:get(HASSAN..'Abs:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الاغاني")  
DevAbs:del(HASSAN..'Abs:Lock:Music'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاغاني بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الصوت" then
if DevAbs:get(HASSAN..'Abs:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الصوت")  
DevAbs:del(HASSAN..'Abs:Lock:Voice'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الصوت بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الروابط" then
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الروابط")  
DevAbs:del(HASSAN..'Abs:Lock:Links'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الروابط بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المواقع" then
if DevAbs:get(HASSAN..'Abs:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح المواقع")  
DevAbs:del(HASSAN..'Abs:Lock:Location'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المواقع بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المعرف" or UnLockText[2] == "المعرفات" then
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح المعرفات")  
DevAbs:del(HASSAN..'Abs:Lock:Tags'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المعرفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الهاشتاك" or UnLockText[2] == "التاك" then
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الهاشتاك")  
DevAbs:del(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الهاشتاك بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الجهات" then
if DevAbs:get(HASSAN..'Abs:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الجهات")  
DevAbs:del(HASSAN..'Abs:Lock:Contact'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الجهات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الشبكات" then
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الشبكات")  
DevAbs:del(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الشبكات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "العربيه" then
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح العربيه")  
DevAbs:del(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙العربيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الانكليزيه" then
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الانكليزيه")  
DevAbs:del(HASSAN..'Abs:Lock:English'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الانكليزيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاشعارات" then
if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الاشعارات")  
DevAbs:del(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الاشعارات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملصقات" then
if DevAbs:get(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح الملصقات")  
DevAbs:del(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙الملصقات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التوجيه" then
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح التوجيه")  
DevAbs:del(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙التوجيه بالفعل مفتوح في المجموعه', 1, 'md')
end
end
end
end
if text and text:match("^قفل التفليش$") or text and text:match("^تفعيل الحمايه القصوى$") then
if not Constructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمنشئين فقط', 1, 'md')
else
DevAbs:set(HASSAN.."Abs:Lock:Bots"..msg.chat_id_,"del") DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed") 
LockList ={'Abs:Lock:Links','Abs:Lock:Contact','Abs:Lock:Forwards','Abs:Lock:Videos','Abs:Lock:Gifs','Abs:Lock:EditMsgs','Abs:Lock:Stickers','Abs:Lock:Farsi','Abs:Lock:Spam','Abs:Lock:WebLinks','Abs:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevAbs:set(HASSAN..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل التفليش")  
end
end
if text and text:match("^فتح التفليش$") then
if not Constructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمنشئين فقط', 1, 'md')
else
DevAbs:hdel(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Abs:Lock:Links','Abs:Lock:Contact','Abs:Lock:Forwards','Abs:Lock:Videos','Abs:Lock:Gifs','Abs:Lock:EditMsgs','Abs:Lock:Stickers','Abs:Lock:Farsi','Abs:Lock:Spam','Abs:Lock:WebLinks','Abs:Lock:Photo'}
for i,UnLock in pairs(UnLockList) do
DevAbs:del(HASSAN..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح التفليش")  
end
end
if text and text:match("^قفل الكل$") then
if not Constructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمنشئين فقط', 1, 'md')
else
DevAbs:del(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:Lock:Taf'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_) 
DevAbs:set(HASSAN.."Abs:Lock:Bots"..msg.chat_id_,"del") DevAbs:hset(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed") 
LockList ={'Abs:Lock:EditMsgs','Abs:Lock:Farsi','Abs:Lock:TagServr','Abs:Lock:Inline','Abs:Lock:Photo','Abs:Lock:Spam','Abs:Lock:Videos','Abs:Lock:Gifs','Abs:Lock:Music','Abs:Lock:Voice','Abs:Lock:Links','Abs:Lock:Location','Abs:Lock:Tags','Abs:Lock:Stickers','Abs:Lock:Markdown','Abs:Lock:Forwards','Abs:Lock:Document','Abs:Lock:Contact','Abs:Lock:Hashtak','Abs:Lock:WebLinks'}
for i,Lock in pairs(LockList) do
DevAbs:set(HASSAN..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم قفل جميع الاوامر")  
end
end
if text and text:match("^فتح الكل$") then
if not Constructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمنشئين فقط', 1, 'md')
else
DevAbs:set(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_,true) DevAbs:set(HASSAN..'Abs:Lock:Taf'..msg.chat_id_,true) DevAbs:set(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_,true) DevAbs:hdel(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Abs:Lock:EditMsgs','Abs:Lock:Text','Abs:Lock:Arabic','Abs:Lock:English','Abs:Lock:Join','Abs:Lock:Bots','Abs:Lock:Farsi','Abs:Lock:FarsiBan','Abs:Lock:TagServr','Abs:Lock:Inline','Abs:Lock:Photo','Abs:Lock:Spam','Abs:Lock:Videos','Abs:Lock:Gifs','Abs:Lock:Music','Abs:Lock:Voice','Abs:Lock:Links','Abs:Lock:Location','Abs:Lock:Tags','Abs:Lock:Stickers','Abs:Lock:Markdown','Abs:Lock:Forwards','Abs:Lock:Document','Abs:Lock:Contact','Abs:Lock:Hashtak','Abs:Lock:WebLinks'}
for i,UnLock in pairs(UnLockList) do
DevAbs:del(HASSAN..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم فتح جميع الاوامر")  
end
end
if Admin(msg) then
if text and (text:match("^ضع سبام (%d+)$") or text:match("^وضع سبام (%d+)$")) then
local SetSpam = text:match("ضع سبام (%d+)$") or text:match("وضع سبام (%d+)$")
if tonumber(SetSpam) < 40 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙اختر عدد اكبر من 40 حرف ', 1, 'md')
else
DevAbs:set(HASSAN..'Abs:Spam:Text'..msg.chat_id_,SetSpam)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم وضع عدد السبام ↫'..SetSpam, 1, 'md')
end
end
end
if Manager(msg) then
if text == "فحص" or text == "فحص البوت" then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..HASSAN)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙صلاحيات البوت هي ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙حذف الرسائل ↫ '..DEL..'\n⌁︙دعوة المستخدمين ↫ '..INV..'\n⌁︙حظر المستخدمين ↫ '..BAN..'\n⌁︙تثبيت الرسائل ↫ '..PIN..'\n⌁︙تغيير المعلومات ↫ '..EDT..'\n⌁︙اضافة مشرفين ↫ '..VIP..'\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
end end
if text and text:match("^تغير رد المطور (.*)$") then
local Text = text:match("^تغير رد المطور (.*)$") 
DevAbs:set(HASSAN.."Abs:SudoBot:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المطور الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد منشئ الاساسي (.*)$") then
local Text = text:match("^تغير رد منشئ الاساسي (.*)$") 
DevAbs:set(HASSAN.."Abs:BasicConstructor:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المنشئ الاساسي الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المنشئ (.*)$") then
local Text = text:match("^تغير رد المنشئ (.*)$") 
DevAbs:set(HASSAN.."Abs:Constructor:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المنشئ الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المدير (.*)$") then
local Text = text:match("^تغير رد المدير (.*)$") 
DevAbs:set(HASSAN.."Abs:Managers:Rd"..msg.chat_id_,Text) 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المدير الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد الادمن (.*)$") then
local Text = text:match("^تغير رد الادمن (.*)$") 
DevAbs:set(HASSAN.."Abs:Admins:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد الادمن الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المميز (.*)$") then
local Text = text:match("^تغير رد المميز (.*)$") 
DevAbs:set(HASSAN.."Abs:VipMem:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المميز الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد المنظف (.*)$") then
local Text = text:match("^تغير رد المنظف (.*)$") 
DevAbs:set(HASSAN.."Abs:Cleaner:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد المنظف الى ↫ "..Text, 1, 'md')
end
if text and text:match("^تغير رد العضو (.*)$") then
local Text = text:match("^تغير رد العضو (.*)$") 
DevAbs:set(HASSAN.."Abs:mem:Rd"..msg.chat_id_,Text)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تغير رد العضو الى ↫ "..Text, 1, 'md')
end
if text == "حذف ردود الرتب" or text == "مسح ردود الرتب" then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف جميع ردود الرتب", 1, 'md')
DevAbs:del(HASSAN.."Abs:mem:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:Cleaner:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:VipMem:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:Admins:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:Managers:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:Constructor:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:BasicConstructor:Rd"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:SudoBot:Rd"..msg.chat_id_)
end
end
if text == "كشف البوتات" and ChCheck(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(extra,result,success)
local admins = result.members_  
text = '⌁︙*قائمة البوتات* ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
local n = 0
local t = 0
for i=0 , #admins do 
n = (n + 1)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_
},function(arg,data) 
if result.members_[i].status_.ID == "ChatMemberStatusMember" then  
ab = ''
elseif result.members_[i].status_.ID == "ChatMemberStatusEditor" then  
t = t + 1
ab = ' ✯'
end
text = text.."~ [@"..data.username_..']'..ab.."\n"
if #admins == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتوجد بوتات هنا*", 1, 'md')
return false end
if #admins == i then 
local a = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙*عدد البوتات هنا* ↫ '..n..'\n'
local f = '⌁︙*عدد البوتات المرفوعه* ↫ '..t..'\n⌁︙*ملاحضه علامة الـ*✯ *تعني ان البوت ادمن في هذه المجموعه*'
Dev_Abs(msg.chat_id_, msg.id_, 1, text..a..f, 1, 'md')
end
end,nil)
end
end,nil)
end
if text == 'حذف البوتات' and ChCheck(msg) or text == 'طرد البوتات' and ChCheck(msg) or text == 'مسح البوتات' and ChCheck(msg) then
tdcli_function ({ ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp)  
local admins = dp.members_  
local x = 0
local c = 0
for i=0 , #admins do 
if dp.members_[i].status_.ID == "ChatMemberStatusEditor" then  
x = x + 1 
end
if tonumber(admins[i].user_id_) ~= tonumber(HASSAN) then
ChatKick(msg.chat_id_,admins[i].user_id_)
end
c = c + 1
end     
if (c - x) == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*لاتوجد بوتات هنا*", 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙*عدد البوتات هنا* ↫ "..c.."\n⌁︙*عدد البوتات المرفوعه* ↫ "..x.."\n⌁︙*تم طرد* ↫ "..(c - x).." *من البوتات*", 1, 'md')
end 
end,nil)  
end 
end
if Admin(msg) then
if text and text:match("^حذف (.*)$") or text and text:match("^مسح (.*)$") then
local txts = {string.match(text, "^(حذف) (.*)$")}
local txtss = {string.match(text, "^(مسح) (.*)$")}
if Sudo(msg) then 
if txts[2] == 'الثانويين' or txtss[2] == 'الثانويين' or txts[2] == 'المطورين الثانويين' or txtss[2] == 'المطورين الثانويين' then
DevAbs:del(HASSAN..'Abs:SecondSudo:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المطورين الثانويين")  
end
end
if SecondSudo(msg) then 
if txts[2] == 'المطورين' or txtss[2] == 'المطورين' then
DevAbs:del(HASSAN..'Abs:SudoBot:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المطورين")  
end
if txts[2] == 'قائمه العام' or txtss[2] == 'قائمه العام' then
DevAbs:del(HASSAN..'Abs:BanAll:')
DevAbs:del(HASSAN..'Abs:MuteAll:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قائمة العام")  
end
end
if SudoBot(msg) then
if txts[2] == 'الادمنيه العامين' or txts[2] == 'الادمنيه العام' or txtss[2] == 'الادمنيه العامين' or txtss[2] == 'الادمنيه العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف الادمنيه العامين")  
DevAbs:del(HASSAN..'Abs:AdminAll:')
end
if txts[2] == 'المميزين عام' or txts[2] == 'المميزين العامين' or txtss[2] == 'المميزين عام' or txtss[2] == 'المميزين العامين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المميزين عام")  
DevAbs:del(HASSAN..'Abs:VipAll:')
end
if txts[2] == 'المدراء العامين' or txts[2] == 'المدراء العام' or txtss[2] == 'المدراء العامين' or txtss[2] == 'المدراء العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المدراء العامين")  
DevAbs:del(HASSAN..'Abs:ManagerAll:')
end
end
if AbsConstructor(msg) then
if txts[2] == 'المنشئين الاساسيين' or txtss[2] == 'المنشئين الاساسيين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المنشئين الاساسيين")  
DevAbs:del(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_)
end
end
if BasicConstructor(msg) then
if txts[2] == 'المنشئين' or txtss[2] == 'المنشئين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المنشئين")  
DevAbs:del(HASSAN..'Abs:Constructor:'..msg.chat_id_)
end end
if Constructor(msg) then
if txts[2] == 'المدراء' or txtss[2] == 'المدراء' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المدراء")  
DevAbs:del(HASSAN..'Abs:Managers:'..msg.chat_id_)
end 
if txts[2] == 'المنظفين' or txtss[2] == 'المنظفين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المنظفين")  
DevAbs:del(HASSAN..'Abs:Cleaner:'..msg.chat_id_)
end end
if Manager(msg) then
if txts[2] == 'الادمنيه' or txtss[2] == 'الادمنيه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف الادمنيه")  
DevAbs:del(HASSAN..'Abs:Admins:'..msg.chat_id_)
end
end
if txts[2] == 'المطايه' or txtss[2] == 'المطايه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المطايه")  
DevAbs:del(HASSAN..'User:Donky:'..msg.chat_id_)
end
if txts[2] == 'أبناء المتعة' or txtss[2] == 'ابناء المتعه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف أبناء المتعة")  
DevAbs:del(HASSAN..'User:Don:'..msg.chat_id_)
end
if txts[2] == 'العفيريين' or txtss[2] == 'العفيريين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف العفيريين")  
DevAbs:del(HASSAN..'User:Don1:'..msg.chat_id_)
end
if txts[2] == 'المهتدين' or txtss[2] == 'المهتدين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المهتدين")  
DevAbs:del(HASSAN..'User:Don12:'..msg.chat_id_)
end
if txts[2] == 'ابناء نرجس الزانية' or txtss[2] == 'ابناء نرجس الزانية' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف ابناء نرجس الزانية")  
DevAbs:del(HASSAN..'User:Don124:'..msg.chat_id_)
end
if txts[2] == 'الوهابية' or txtss[2] == 'الوهابية' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المهتدين")  
DevAbs:del(HASSAN..'User:Don123:'..msg.chat_id_)
end
if txts[2] == 'اللطامه' or txtss[2] == 'اللطامه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف اللطامه")  
DevAbs:del(HASSAN..'User:Don1234:'..msg.chat_id_)
end
if txts[2] == 'الضراط' or txtss[2] == 'الضراط' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف الضراط")  
DevAbs:del(HASSAN..'User:Don12345:'..msg.chat_id_)
end
if txts[2] == 'الرابط' or txtss[2] == 'الرابط' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف رابط المجموعه")  
DevAbs:del(HASSAN.."Abs:Groups:Links"..msg.chat_id_)
end
if txts[2] == 'المميزين' or txtss[2] == 'المميزين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المميزين")  
DevAbs:del(HASSAN..'Abs:VipMem:'..msg.chat_id_)
end
if txts[2] == 'المكتومين' or txtss[2] == 'المكتومين' then
DevAbs:del(HASSAN..'Abs:Muted:'..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المكتومين")  
end
if txts[2] == 'المقيدين' or txtss[2] == 'المقيدين' then     
local List = DevAbs:smembers(HASSAN..'Abs:Tkeed:'..msg.chat_id_)
for k,v in pairs(List) do   
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..v.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True") 
DevAbs:srem(HASSAN..'Abs:Tkeed:'..msg.chat_id_, v)
end 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المقيدين")  
end
if txts[2] == 'قائمه المنع' or txtss[2] == 'قائمه المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قائمة المنع")  
DevAbs:del(HASSAN..'Abs:Filters:'..msg.chat_id_)
end
if txts[2] == 'قوائم المنع' or txtss[2] == 'قوائم المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قوائم المنع")  
DevAbs:del(HASSAN..'Abs:Filters:'..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:FilterAnimation"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:FilterPhoto"..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:FilterSteckr"..msg.chat_id_)
end
if txts[2] == 'قائمه منع المتحركات' or txtss[2] == 'قائمه منع المتحركات' then     
DevAbs:del(HASSAN.."Abs:FilterAnimation"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قائمة منع المتحركات")  
end
if txts[2] == 'قائمه منع الصور' or txtss[2] == 'قائمه منع الصور' then     
DevAbs:del(HASSAN.."Abs:FilterPhoto"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قائمة منع الصور")  
end
if txts[2] == 'قائمه منع الملصقات' or txtss[2] == 'قائمه منع الملصقات' then     
DevAbs:del(HASSAN.."Abs:FilterSteckr"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف قائمة منع الملصقات")  
end
end
end
if text and text:match("^حذف القوائم$") and ChCheck(msg) or text and text:match("^مسح القوائم$") and ChCheck(msg) then
if not BasicConstructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمنشئ الاساسي فقط', 1, 'md')
else
DevAbs:del(HASSAN..'Abs:Ban:'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:Admins:'..msg.chat_id_) DevAbs:del(HASSAN..'User:Donky:'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:VipMem:'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:Filters:'..msg.chat_id_) DevAbs:del(HASSAN..'Abs:Muted:'..msg.chat_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف ↫ ❨ قائمة المنع • المحظورين • المكتومين • الادمنيه • المميزين • المطايه ❩ بنجاح \n ✓", 1, 'md')
end end
if text and text:match("^حذف جميع الرتب$") and ChCheck(msg) or text and text:match("^مسح جميع الرتب$") and ChCheck(msg) or text and text:match("^تنزيل جميع الرتب$") and ChCheck(msg) then
if not AbsConstructor(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لمنشئ المجموعه فقط', 1, 'md')
else
local basicconstructor = DevAbs:smembers(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_)
local constructor = DevAbs:smembers(HASSAN..'Abs:Constructor:'..msg.chat_id_)
local Managers = DevAbs:smembers(HASSAN..'Abs:Managers:'..msg.chat_id_)
local admins = DevAbs:smembers(HASSAN..'Abs:Admins:'..msg.chat_id_)
local vipmem = DevAbs:smembers(HASSAN..'Abs:VipMem:'..msg.chat_id_)
local donky = DevAbs:smembers(HASSAN..'User:Donky:'..msg.chat_id_)
if #basicconstructor ~= 0 then basicconstructort = 'المنشئين الاساسيين • ' else basicconstructort = '' end
if #constructor ~= 0 then constructort = 'المنشئين • ' else constructort = '' end
if #Managers ~= 0 then Managerst = 'المدراء • ' else Managerst = '' end
if #admins ~= 0 then adminst = 'الادمنيه • ' else adminst = '' end
if #vipmem ~= 0 then vipmemt = 'المميزين • ' else vipmemt = '' end
if #donky ~= 0 then donkyt = 'المطايه • ' else donkyt = '' end
if #basicconstructor ~= 0 or #constructor ~= 0 or #Managers ~= 0 or #admins ~= 0 or #vipmem ~= 0 or #donky ~= 0 then 
DevAbs:del(HASSAN..'Abs:BasicConstructor:'..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Constructor:'..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Managers:'..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Admins:'..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:VipMem:'..msg.chat_id_)
DevAbs:del(HASSAN..'User:Donky:'..msg.chat_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف جميع الرتب التاليه ↫ ❨ "..basicconstructort..''..constructort..''..Managerst..''..adminst..''..vipmemt..''..donkyt.." ❩ بنجاح \n ✓", 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لاتوجد رتب هنا", 1, 'md')
end 
end 
end
if Admin(msg) then 
if text and text:match("^الاعدادات$") and ChCheck(msg) then
if not DevAbs:get(HASSAN..'Abs:Spam:Text'..msg.chat_id_) then
spam_c = 400
else
spam_c = DevAbs:get(HASSAN..'Abs:Spam:Text'..msg.chat_id_)
end
if DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_, "Spam:User") == "kick" then     
flood = "بالطرد"     
elseif DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") == "keed" then     
flood = "بالتقيد"     
elseif DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") == "mute" then     
flood = "بالكتم"           
elseif DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Spam:User") == "del" then     
flood = "بالحذف"
else     
flood = "مفتوح"     
end
if DevAbs:get(HASSAN.."Abs:Lock:Bots"..msg.chat_id_) == "del" then
lock_bots = "بالحذف"
elseif DevAbs:get(HASSAN.."Abs:Lock:Bots"..msg.chat_id_) == "ked" then
lock_bots = "بالتقيد"   
elseif DevAbs:get(HASSAN.."Abs:Lock:Bots"..msg.chat_id_) == "kick" then
lock_bots = "بالطرد"    
else
lock_bots = "مفتوحه"    
end
if DevAbs:get(HASSAN..'Abs:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه'end
if DevAbs:get(HASSAN..'Abs:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفله' else mute_photo = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفله' else mute_video = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفله' else mute_gifs = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Music'..msg.chat_id_) then mute_music = 'مقفله' else mute_music = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفله' else mute_in = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفله' else mute_voice = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفله' else mute_edit = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفله' else lock_pin = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفله' else lock_sticker = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفله' else lock_tgservice = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفله' else lock_wp = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفله' else lock_htag = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفله' else lock_tag = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Location'..msg.chat_id_) then lock_location = 'مقفله' else lock_location = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفله' else lock_contact = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then lock_english = 'مقفله' else lock_english = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفله' else lock_arabic = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفله' else lock_forward = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Document'..msg.chat_id_) then lock_file = 'مقفله' else lock_file = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفله' else markdown = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفله' else lock_spam = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفل' else lock_Join = 'مفتوح' end
if DevAbs:get(HASSAN.."Abs:Lock:Welcome"..msg.chat_id_) then send_welcome = 'مقفله' else send_welcome = 'مفتوحه' end
if DevAbs:get(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end
if DevAbs:get(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end
if DevAbs:get(HASSAN..'Abs:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end
if DevAbs:get(HASSAN..'Abs:Lock:Farsi'..msg.chat_id_) then lock_farsi = 'مقفله' else lock_farsi = 'مفتوحه' end
local Flood_Num = DevAbs:hget(HASSAN.."Abs:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
local TXTE = "⌁︙اعدادات المجموعه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
.."⌁︙الروابط ↫ "..mute_links.."\n"
.."⌁︙المعرف ↫ "..lock_tag.."\n"
.."⌁︙البوتات ↫ "..lock_bots.."\n"
.."⌁︙المتحركه ↫ "..mute_gifs.."\n"
.."⌁︙الملصقات ↫ "..lock_sticker.."\n"
.."⌁︙الملفات ↫ "..lock_file.."\n"
.."⌁︙الصور ↫ "..mute_photo.."\n"
.."⌁︙الفيديو ↫ "..mute_video.."\n"
.."⌁︙الاونلاين ↫ "..mute_in.."\n"
.."⌁︙الدردشة ↫ "..mute_text.."\n"
.."⌁︙التوجيه ↫ "..lock_forward.."\n"
.."⌁︙الاغاني ↫ "..mute_music.."\n"
.."⌁︙الصوت ↫ "..mute_voice.."\n"
.."⌁︙الجهات ↫ "..lock_contact.."\n"
.."⌁︙الماركداون ↫ "..markdown.."\n"
.."⌁︙الهاشتاك ↫ "..lock_htag.."\n"
.."⌁︙التعديل ↫ "..mute_edit.."\n"
.."⌁︙التثبيت ↫ "..lock_pin.."\n"
.."⌁︙الاشعارات ↫ "..lock_tgservice.."\n"
.."⌁︙الكلايش ↫ "..lock_spam.."\n"
.."⌁︙الدخول ↫ "..lock_Join.."\n"
.."⌁︙الشبكات ↫ "..lock_wp.."\n"
.."⌁︙المواقع ↫ "..lock_location.."\n"
.."⌁︙الفشار ↫ "..lock_fshar.."\n"
.."⌁︙الكفر ↫ "..lock_kaf.."\n"
.."⌁︙الطائفيه ↫ "..lock_taf.."\n"
.."⌁︙العربيه ↫ "..lock_arabic.."\n"
.."⌁︙الانكليزيه ↫ "..lock_english.."\n"
.."⌁︙الفارسيه ↫ "..lock_farsi.."\n"
.."⌁︙التكرار ↫ "..flood.."\n"
.."⌁︙عدد التكرار ↫ "..Flood_Num.."\n"
.."⌁︙عدد السبام ↫ "..spam_c.."\n"
.."┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙[Source Channel](https://t.me/GO_XXO)\n"
Dev_Abs(msg.chat_id_, msg.id_, 1, TXTE, 1, 'md')
end
end
if text and text:match("^كول (.*)$") then
local txt = {string.match(text, "^(كول) (.*)$")}
Dev_Abs(msg.chat_id_,0, 1, txt[2], 1, 'md')
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if DevAbs:get(HASSAN..'Abs:setrules'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء حفظ قوانين المجموعه', 1, 'md')
DevAbs:del(HASSAN..'Abs:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevAbs:del(HASSAN..'Abs:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:rules'..msg.chat_id_,text)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حفظ قوانين المجموعه', 1, 'md')
return false   
end
if text and text:match("^ضع قوانين$") and ChCheck(msg) or text and text:match("^وضع قوانين$") and ChCheck(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي القوانين الان', 1, 'md')
DevAbs:set(HASSAN..'Abs:setrules'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
end
if text and text:match("^القوانين$") then
local rules = DevAbs:get(HASSAN..'Abs:rules'..msg.chat_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, rules, 1, nil)
end
if text == 'رقمي' then
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(extra,result,success)
if result.phone_number_  then
MyNumber = "⌁︙رقمك ↫ +"..result.phone_number_
else
MyNumber = "⌁︙تم وضع رقمك لجهات اتصالك فقط"
end
send(msg.chat_id_, msg.id_,MyNumber)
end,nil)
end
if text == "تفعيل الزخرفه" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الزخرفه بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Zrf:Abs'..msg.chat_id_) 
end
if text == "تعطيل الزخرفه" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الزخرفه بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Zrf:Abs'..msg.chat_id_,true)  
end
if DevAbs:get(HASSAN..'Zrf:Abs'..msg.chat_id_..''..msg.sender_user_id_) then 
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر الزخرفه', 1, 'md')
DevAbs:del(HASSAN..'Zrf:Abs'..msg.chat_id_..''..msg.sender_user_id_)
return false  
end 
UrlZrf = https.request('https://apiabs.ml/zrf.php?abs='..URL.escape(text)) 
Zrf = JSON.decode(UrlZrf) 
t = "⌁︙قائمة الزخرفه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'md')
DevAbs:del(HASSAN..'Zrf:Abs'..msg.chat_id_..''..msg.sender_user_id_)
return false   
end
if not DevAbs:get(HASSAN..'Abs:Zrf:Abs'..msg.chat_id_) then
if text == 'زخرفه' and ChCheck(msg) or text == 'الزخرفه' and ChCheck(msg) then  
DevAbs:setex(HASSAN.."Zrf:Abs"..msg.chat_id_..""..msg.sender_user_id_,300,true)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي الكلمه لزخرفتها \nيمكنك الزخرفة باللغه { en } ~ { ar } ', 1, 'md')
end
end
if not DevAbs:get(HASSAN..'Abs:Zrf:Abs'..msg.chat_id_) then
if text and text:match("^زخرفه (.*)$") and ChCheck(msg) or text and text:match("^زخرف (.*)$") and ChCheck(msg) then 
local TextZrf = text:match("^زخرفه (.*)$") or text:match("^زخرف (.*)$") 
UrlZrf = https.request('https://apiabs.ml/zrf.php?abs='..URL.escape(TextZrf)) 
Zrf = JSON.decode(UrlZrf) 
t = "⌁︙قائمة الزخرفه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'md')
end
end
if text == "تفعيل الابراج" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الابراج بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Brg:Abs'..msg.chat_id_) 
end
if text == "تعطيل الابراج" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الابراج بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Brg:Abs'..msg.chat_id_,true)  
end
if not DevAbs:get(HASSAN..'Abs:Brg:Abs'..msg.chat_id_) then
if text and text:match("^برج (.*)$") and ChCheck(msg) or text and text:match("^برجي (.*)$") and ChCheck(msg) then 
local TextBrg = text:match("^برج (.*)$") or text:match("^برجي (.*)$") 
UrlBrg = https.request('https://apiabs.ml/brg.php?brg='..URL.escape(TextBrg)) 
Brg = JSON.decode(UrlBrg) 
t = Brg.ok.abs  
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
if text and (text == "تفعيل اوامر النسب" or text == "تفعيل نسبه الحب" or text == "تفعيل نسبه الكره" or text == "تفعيل نسبه الرجوله" or text == "تفعيل نسبه الانوثه" or text == "تفعيل نسبه الغباء") and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل اوامر النسب'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) 
end
if text and (text == "تعطيل اوامر النسب" or text == "تعطيل نسبه الحب" or text == "تعطيل نسبه الكره" or text == "تعطيل نسبه الرجوله" or text == "تعطيل نسبه الانوثه" or text == "تعطيل نسبه الغباء") and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل اوامر النسب'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_,true)  
end
if not DevAbs:get(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) then
if text == "نسبه الحب" and ChCheck(msg) or text == "نسبة الحب" and ChCheck(msg) then
DevAbs:set(HASSAN..'LoveNsba:Abs'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بارسل اسمين لحساب نسبة الحب بينهما كمثال ↫ جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الحب" and text ~= "نسبة الحب" and DevAbs:get(HASSAN..'LoveNsba:Abs'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر نسبة الحب ', 1, 'md')
DevAbs:del(HASSAN..'LoveNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Abs = math.random(0,100);
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙نسبة الحب بين '..text..' هي : '..Abs..'%', 1, 'md')
DevAbs:del(HASSAN..'LoveNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAbs:get(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) then
if text == "نسبه الكره" and ChCheck(msg) or text == "نسبة الكره" and ChCheck(msg) then
DevAbs:set(HASSAN..'HataNsba:Abs'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بارسل اسمين لحساب نسبة الكره بينهما كمثال ↫ جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الكره" and text ~= "نسبة الكره" and DevAbs:get(HASSAN..'HataNsba:Abs'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر نسبة الكره ', 1, 'md')
DevAbs:del(HASSAN..'HataNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Abs = math.random(0,100);
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙نسبة الكره بين '..text..' هي : '..Abs..'%', 1, 'md')
DevAbs:del(HASSAN..'HataNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAbs:get(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) then
if text and (text == "نسبه الرجوله" or text == "نسبة الرجوله" or text == "نسبه رجوله" or text == "نسبة رجوله") and ChCheck(msg) then
DevAbs:set(HASSAN..'RjolaNsba:Abs'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بارسل اسم الشخص لقياس نسبة رجولته كمثال ↫ جاك', 1, 'md')
end
end
if text and text ~= "نسبه الرجوله" and text ~= "نسبة الرجوله" and text ~= "نسبه رجوله" and text ~= "نسبة رجوله" and DevAbs:get(HASSAN..'RjolaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر نسبة الرجوله ', 1, 'md')
DevAbs:del(HASSAN..'RjolaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Abs = math.random(0,100);
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙نسبة رجولة '..text..' هي : '..Abs..'%', 1, 'md')
DevAbs:del(HASSAN..'RjolaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAbs:get(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) then
if text and (text == "نسبه الانوثه" or text == "نسبة الانوثه" or text == "نسبه انوثه" or text == "نسبة انوثه") and ChCheck(msg) then
DevAbs:set(HASSAN..'AnothaNsba:Abs'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بارسل اسم الشخص لقياس نسبة انوثته كمثال ↫ روز', 1, 'md')
end
end
if text and text ~= "نسبه الانوثه" and text ~= "نسبة الانوثه" and text ~= "نسبه انوثه" and text ~= "نسبة انوثه" and DevAbs:get(HASSAN..'AnothaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر نسبة الانوثه ', 1, 'md')
DevAbs:del(HASSAN..'AnothaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Abs = math.random(0,100);
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙نسبة انوثة '..text..' هي : '..Abs..'%', 1, 'md')
DevAbs:del(HASSAN..'AnothaNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevAbs:get(HASSAN..'Abs:Nsba:Abs'..msg.chat_id_) then
if text and (text == "نسبه الغباء" or text == "نسبة الغباء") and ChCheck(msg) then
DevAbs:set(HASSAN..'StupidNsba:Abs'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙قم بارسل اسم الشخص لقياس نسبة غبائه كمثال ↫ جاك او روز', 1, 'md')
end
end
if text and text ~= "نسبه الغباء" and text ~= "نسبة الغباء" and DevAbs:get(HASSAN..'StupidNsba:Abs'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم الغاء امر نسبة الغباء ', 1, 'md')
DevAbs:del(HASSAN..'StupidNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Abs = math.random(0,100);
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙نسبة غباء '..text..' هي : '..Abs..'%', 1, 'md')
DevAbs:del(HASSAN..'StupidNsba:Abs'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if text == "تفعيل حساب العمر" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل حساب العمر'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Age:Abs'..msg.chat_id_) 
end
if text == "تعطيل حساب العمر" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل حساب العمر'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Age:Abs'..msg.chat_id_,true)  
end
if not DevAbs:get(HASSAN..'Abs:Age:Abs'..msg.chat_id_) then
if text and text:match("^احسب (.*)$") and ChCheck(msg) or text and text:match("^عمري (.*)$") and ChCheck(msg) then 
local TextAge = text:match("^احسب (.*)$") or text:match("^عمري (.*)$") 
UrlAge = https.request('https://apiabs.ml/age.php?age='..URL.escape(TextAge)) 
Age = JSON.decode(UrlAge) 
t = Age.ok.abs
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
if text == "تفعيل معاني الاسماء" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل معاني الاسماء'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Mean:Abs'..msg.chat_id_) 
end
if text == "تعطيل معاني الاسماء" and Manager(msg) and ChCheck(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل معاني الاسماء'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Mean:Abs'..msg.chat_id_,true)  
end
if not DevAbs:get(HASSAN..'Abs:Mean:Abs'..msg.chat_id_) then
if text and text:match("^معنى الاسم (.*)$") and ChCheck(msg) or text and text:match("^معنى اسم (.*)$") and ChCheck(msg) then 
local TextMean = text:match("^معنى الاسم (.*)$") or text:match("^معنى اسم (.*)$") 
UrlMean = https.request('https://apiabs.ml/Mean.php?Abs='..URL.escape(TextMean)) 
Mean = JSON.decode(UrlMean) 
t = Mean.ok.abs
Dev_Abs(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
if text == "غنيلي" and ChCheck(msg) then
data,res = https.request('https://apiabs.ml/Audios.php')
if res == 200 then
Audios = json:decode(data)
if Audios.Info == true then
local Text ='⌁︙تم اختيار المقطع الصوتي لك'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '⌁ HASSAN TeAM .',url="t.me/GO_XXO"}},
}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. msg.chat_id_ .. '&voice='..URL.escape(Audios.info)..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
end
if Admin(msg) then
if DevAbs:get(HASSAN..'Abs:LockSettings'..msg.chat_id_) then 
if text == "الروابط" then if DevAbs:get(HASSAN..'Abs:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الروابط ↫ "..mute_links.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "المعرف" or text == "المعرفات" then if DevAbs:get(HASSAN..'Abs:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفوله' else lock_tag = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙المعرف ↫ "..lock_tag.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "المتحركه" or text == "الملصقات المتحركه" then if DevAbs:get(HASSAN..'Abs:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفوله' else mute_gifs = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙المتحركه ↫ "..mute_gifs.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الملصقات" then if DevAbs:get(HASSAN..'Abs:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفوله' else lock_sticker = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الملصقات ↫ "..lock_sticker.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الصور" then if DevAbs:get(HASSAN..'Abs:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفوله' else mute_photo = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الصور ↫ "..mute_photo.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الفيديو" or text == "الفيديوهات" then if DevAbs:get(HASSAN..'Abs:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفوله' else mute_video = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الفيديو ↫ "..mute_video.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الاونلاين" then if DevAbs:get(HASSAN..'Abs:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفل' else mute_in = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙الاونلاين ↫ "..mute_in.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الدردشة" then if DevAbs:get(HASSAN..'Abs:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الدردشة ↫ "..mute_text.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "التوجيه" or text == "اعاده التوجيه" then if DevAbs:get(HASSAN..'Abs:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفل' else lock_forward = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙التوجيه ↫ "..lock_forward.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الاغاني" then if DevAbs:get(HASSAN..'Abs:Lock:Music'..msg.chat_id_) then mute_music = 'مقفوله' else mute_music = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الاغاني ↫ "..mute_music.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الصوت" or text == "الصوتيات" then if DevAbs:get(HASSAN..'Abs:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفول' else mute_voice = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙الصوت ↫ "..mute_voice.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الجهات" or text == "جهات الاتصال" then if DevAbs:get(HASSAN..'Abs:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفوله' else lock_contact = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الجهات ↫ "..lock_contact.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الماركداون" then if DevAbs:get(HASSAN..'Abs:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفل' else markdown = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙الماركداون ↫ "..markdown.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الهاشتاك" then if DevAbs:get(HASSAN..'Abs:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفل' else lock_htag = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙الهاشتاك ↫ "..lock_htag.."\n"Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "التعديل" then if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفل' else mute_edit = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙التعديل ↫ "..mute_edit.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "التثبيت" then if DevAbs:get(HASSAN..'Abs:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفل' else lock_pin = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙التثبيت ↫ "..lock_pin.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الاشعارات" then if DevAbs:get(HASSAN..'Abs:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفوله' else lock_tgservice = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الاشعارات ↫ "..lock_tgservice.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الكلايش" then if DevAbs:get(HASSAN..'Abs:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفوله' else lock_spam = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الكلايش ↫ "..lock_spam.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الدخول" then if DevAbs:get(HASSAN..'Abs:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفول' else lock_Join = 'مفتوح' end local HASSANTEAM = "\n" .."⌁︙الدخول ↫ "..lock_Join.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الشبكات" then if DevAbs:get(HASSAN..'Abs:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفوله' else lock_wp = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الشبكات ↫ "..lock_wp.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "المواقع" then if DevAbs:get(HASSAN..'Abs:Lock:Location'..msg.chat_id_) then lock_location = 'مقفوله' else lock_location = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙المواقع ↫ "..lock_location.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "العربيه" then if DevAbs:get(HASSAN..'Abs:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفوله' else lock_arabic = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙العربيه ↫ "..lock_arabic.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الانكليزيه" then if DevAbs:get(HASSAN..'Abs:Lock:English'..msg.chat_id_) then lock_english = 'مقفوله' else lock_english = 'مفتوحه' end local HASSANTEAM = "\n" .."⌁︙الانكليزيه ↫ "..lock_english.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الكفر" then if DevAbs:get(HASSAN..'Abs:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end local HASSANTEAM = "\n" .."⌁︙الكفر ↫ "..lock_kaf.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الفشار" then if DevAbs:get(HASSAN..'Abs:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end local HASSANTEAM = "\n" .."⌁︙الفشار ↫ "..lock_fshar.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
if text == "الطائفيه" then if DevAbs:get(HASSAN..'Abs:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end local HASSANTEAM = "\n" .."⌁︙الطائفيه ↫ "..lock_taf.."\n" Dev_Abs(msg.chat_id_, msg.id_, 1, HASSANTEAM, 1, 'md') end
end
if text == 'تفعيل كشف الاعدادات' and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل كشف الاعدادات'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:LockSettings'..msg.chat_id_,true)  
end
if text == 'تعطيل كشف الاعدادات' and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل كشف الاعدادات'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:LockSettings'..msg.chat_id_) 
end
if text == 'تفعيل اوامر التحشيش' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل اوامر التحشيش'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_)
end
if text == 'تعطيل اوامر التحشيش' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل اوامر التحشيش'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:Stupid'..msg.chat_id_,true)
end
if text == 'تفعيل ردود المدير' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل ردود المدير'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:GpRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المدير' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل ردود المدير'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:GpRed'..msg.chat_id_,true)
end
if text == 'تفعيل ردود المطور' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل ردود المطور'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:AllRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المطور' and Manager(msg) and ChCheck(msg) then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل ردود المطور'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:AllRed'..msg.chat_id_,true)
end
if SecondSudo(msg) then
if text == 'تفعيل المغادره' or text == '↫ تفعيل المغادره ⌁' then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل المغادره بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN.."Abs:Left:Bot"..HASSAN)
end
if text == 'تعطيل المغادره' or text == '↫ تعطيل المغادره ⌁' then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل المغادره بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN.."Abs:Left:Bot"..HASSAN,true) 
end 
if text == 'تفعيل الاذاعه' or text == '↫ تفعيل الاذاعه ⌁' then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الاذاعه بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN.."Abs:Send:Bot"..HASSAN)
end
if text == 'تعطيل الاذاعه' or text == '↫ تعطيل الاذاعه ⌁' then 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الاذاعه بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN.."Abs:Send:Bot"..HASSAN,true) 
end
end
if text and text:match("^ضع اسم (.*)$") and Manager(msg) and ChCheck(msg) then
local txt = {string.match(text, "^(ضع اسم) (.*)$")}
tdcli_function ({ ID = "ChangeChatTitle",chat_id_ = msg.chat_id_,title_ = txt[2] },function(arg,data) 
if data.message_ == "Channel chat title can be changed by administrators only" then
send(msg.chat_id_,msg.id_,"⌁︙البوت ليس ادمن يرجى ترقيتي !")  
return false  
end 
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⌁︙ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات")  
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تغير اسم المجموعه'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
end
if msg.content_.photo_ then
if DevAbs:get(HASSAN..'Abs:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_) then
if msg.content_.photo_.sizes_[3] then
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
tdcli_function ({ID = "ChangeChatPhoto",chat_id_ = msg.chat_id_,photo_ = getInputFile(photo_id) }, function(arg,data)   
if data.code_ == 3 then
send(msg.chat_id_, msg.id_,"⌁︙عذرا البوت ليس ادمن يرجى ترقيتي والمحاوله لاحقا") 
DevAbs:del(HASSAN..'Abs:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
return false  end
if data.message_ == "CHAT_ADMIN_REQUIRED" then 
send(msg.chat_id_, msg.id_,"⌁︙ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات") 
DevAbs:del(HASSAN..'Abs:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
else
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تغير صورة المجموعه'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
DevAbs:del(HASSAN..'Abs:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
end 
end
if text and text:match("^ضع صوره$") and ChCheck(msg) or text and text:match("^وضع صوره$") and ChCheck(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, '⌁︙ارسل صورة المجموعه الان', 1, 'md')
DevAbs:set(HASSAN..'Abs:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
if text and text:match("^حذف الصوره$") and ChCheck(msg) or text and text:match("^مسح الصوره$") and ChCheck(msg) then
https.request("https://api.telegram.org/bot"..TokenBot.."/deleteChatPhoto?chat_id="..msg.chat_id_) 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف صورة المجموعه")  
return false  
end
if Manager(msg) then
if text and text:match("^الغاء تثبيت$") and ChCheck(msg) or text and text:match("^الغاء التثبيت$") and ChCheck(msg) then
if DevAbs:sismember(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, "⌁︙التثبيت والغاء واعادة التثبيت تم قفله من قبل حسن", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
DevAbs:del(HASSAN..'Abs:PinnedMsg'..msg.chat_id_)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم الغاء تثبيت الرساله'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⌁︙انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⌁︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end
if text and text:match("^الغاء تثبيت الكل$") then  
if DevAbs:sismember(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, "⌁︙التثبيت والغاء واعادة التثبيت تم قفله من قبل حسن", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم الغاء تثبيت الكل'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
https.request('https://api.telegram.org/bot'..TokenBot..'/unpinAllChatMessages?chat_id='..msg.chat_id_)
DevAbs:del(HASSAN.."Abs:PinnedMsg"..msg.chat_id_)
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⌁︙انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⌁︙ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end
if text and text:match("^اعاده تثبيت$") and ChCheck(msg) or text and text:match("^اعاده التثبيت$") and ChCheck(msg) or text and text:match("^اعادة التثبيت$") and ChCheck(msg) then
if DevAbs:sismember(HASSAN.."Abs:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Abs(msg.chat_id_,msg.id_, 1, "⌁︙التثبيت والغاء واعادة التثبيت تم قفله من قبل حسن", 1, 'md')
return false  
end
local pin_id = DevAbs:get(HASSAN..'Abs:PinnedMsg'..msg.chat_id_)
if pin_id then
pin(msg.chat_id_,pin_id,0)
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم اعادة تثبيت الرساله'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end end
end
if text == 'طرد المحذوفين' or text == 'مسح المحذوفين' or text == 'طرد الحسابات المحذوفه' or text == 'حذف المحذوفين' then  
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),offset_ = 0,limit_ = 1000}, function(arg,del)
for k, v in pairs(del.members_) do
tdcli_function({ID = "GetUser",user_id_ = v.user_id_},function(b,data) 
if data.first_name_ == false then
ChatKick(msg.chat_id_, data.id_)
end
end,nil)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم طرد المحذوفين")  
end,nil)
end
if text and text:match("^مسح المحظورين$") or text and text:match("^حذف المحظورين$") and ChCheck(msg) or text and text:match("^مسح المطرودين$") or text and text:match("^حذف المطرودين$") and ChCheck(msg) then
local function RemoveBlockList(extra, result)
if tonumber(result.total_count_) == 0 then 
Dev_Abs(msg.chat_id_, msg.id_, 0,'⌁︙*لا يوجد محظورين*', 1, 'md')
DevAbs:del(HASSAN..'Abs:Ban:'..msg.chat_id_)
else
local x = 0
for x,y in pairs(result.members_) do
changeChatMemberStatus(msg.chat_id_, y.user_id_, 'Left', dl_cb, nil)
DevAbs:del(HASSAN..'Abs:Ban:'..msg.chat_id_)
x = x + 1
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف المحظورين")  
end
end
tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersKicked"},offset_ = 0,limit_ = 200}, RemoveBlockList, {chat_id_ = msg.chat_id_, msg_id_ = msg.id_})    
end
end
if text and text:match("^معلومات المجموعه$") and ChCheck(msg) or text and text:match("^عدد الاعضاء$") and ChCheck(msg) or text and text:match("^عدد الكروب$") and ChCheck(msg) or text and text:match("^عدد الادمنيه$") and ChCheck(msg) or text and text:match("^عدد المحظورين$") and ChCheck(msg) then
local Muted = DevAbs:scard(HASSAN.."Abs:Muted:"..msg.chat_id_) or "0"
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function({ID="GetChannelFull",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه ↫ ❨ '..dp.title_..' ❩\n⌁︙الايدي ↫ ❨ '..msg.chat_id_..' ❩\n⌁︙عدد الاعضاء ↫ ❨ *'..data.member_count_..'* ❩\n⌁︙عدد الادمنيه ↫ ❨ *'..data.administrator_count_..'* ❩\n⌁︙عدد المطرودين ↫ ❨ *'..data.kicked_count_..'* ❩\n⌁︙عدد المكتومين ↫ ❨ *'..Muted..'* ❩\n⌁︙عدد رسائل المجموعه ↫ ❨ *'..(msg.id_/2097152/0.5)..'* ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n', 1, 'md') 
end,nil)
end,nil)
end
if text and text:match('^كشف (-%d+)') then
local ChatId = text:match('كشف (-%d+)') 
if not SudoBot(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطورين فقط', 1, 'md')
else
local ConstructorList = DevAbs:scard(HASSAN.."Abs:Constructor:"..ChatId) or 0
local BanedList = DevAbs:scard(HASSAN.."Abs:Ban:"..ChatId) or 0
local ManagerList = DevAbs:scard(HASSAN.."Abs:Managers:"..ChatId) or 0
local MutedList = DevAbs:scard(HASSAN.."Abs:Muted:"..ChatId) or 0
local TkeedList = DevAbs:scard(HASSAN.."Abs:Abs:Tkeed:"..ChatId) or 0
local AdminsList = DevAbs:scard(HASSAN.."Abs:Admins:"..ChatId) or 0
local VipList = DevAbs:scard(HASSAN.."Abs:VipMem:"..ChatId) or 0
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..ChatId))
if LinkGp.ok == true then LinkGroup = LinkGp.result else LinkGroup = 't.me/GO_XXO' end
tdcli_function({ID ="GetChat",chat_id_=ChatId},function(arg,dp)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = ChatId:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
if dp.id_ then
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,Abs) 
if Abs.first_name_ ~= false then
ConstructorAbs = "["..Abs.first_name_.."](T.me/"..(Abs.username_ or "GO_XXO")..")"
else 
ConstructorAbs = "حساب محذوف"
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙المجموعه ↫ ["..dp.title_.."]("..LinkGroup..")\n⌁︙الايدي ↫ ( `"..ChatId.."` )\n⌁︙المنشئ ↫ "..ConstructorAbs.."\n⌁︙عدد المدراء ↫ ( *"..ManagerList.."* )\n⌁︙عدد المنشئين ↫ ( *"..ConstructorList.."* )\n⌁︙عدد الادمنيه ↫ ( *"..AdminsList.."* )\n⌁︙عدد المميزين ↫ ( *"..VipList.."* )\n⌁︙عدد المحظورين ↫ ( *"..BanedList.."* )\n⌁︙عدد المقيدين ↫ ( *"..TkeedList.."* )\n⌁︙عدد المكتومين ↫ ( *"..MutedList.."* )", 1,"md")
end,nil)
end
end
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لم تتم اضافتي بها لاقوم بكشفها", 1, "md")
end
end,nil)
end,nil)
end 
end
if text and text:match("^غادر (-%d+)$")  then
local Text = { string.match(text, "^(غادر) (-%d+)$")}
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط', 1, 'md')
else 
tdcli_function({ID ="GetChat",chat_id_=Text[2]},function(arg,dp) 
if dp.id_ then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙المجموعه ↫ ["..dp.title_.."]\n⌁︙تمت المغادره منها بنجاح", 1, "md")
Dev_Abs(Text[2], 0, 1, "⌁︙بامر المطور تم مغادرة هذه المجموعه ", 1, "md")  
ChatLeave(dp.id_, HASSAN)
DevAbs:srem(HASSAN.."Abs:Groups", dp.id_)
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لم تتم اضافتي بها لاقوم بمغادرتها", 1, "md")
end 
end,nil)
end 
end
if text and text:match("^تعين عدد الاعضاء (%d+)$") and SecondSudo(msg) or text and text:match("^تعيين عدد الاعضاء (%d+)$") and SecondSudo(msg) then
local Num = text:match("تعين عدد الاعضاء (%d+)$") or text:match("تعيين عدد الاعضاء (%d+)$")
DevAbs:set(HASSAN..'Abs:Num:Add:Bot',Num) 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم وضع عدد الاعضاء ↫ *'..Num..'* عضو', 1, 'md')
end
if text == 'تفعيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط', 1, 'md')
else 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل البوت الخدمي'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:FreeBot'..HASSAN) 
end 
end
if text == 'تعطيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط', 1, 'md')
else 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل البوت الخدمي'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:FreeBot'..HASSAN,true) 
end 
end
if ChatType == 'sp' or ChatType == 'gp'  then
if text == 'تفعيل الالعاب' and Manager(msg) and ChCheck(msg) or text == 'تفعيل اللعبه' and Manager(msg) and ChCheck(msg) then   
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل الالعاب بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN..'Abs:Lock:Games'..msg.chat_id_) 
end
if text == 'تعطيل الالعاب' and Manager(msg) and ChCheck(msg) or text == 'تعطيل اللعبه' and Manager(msg) and ChCheck(msg) then  
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل الالعاب بنجاح'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN..'Abs:Lock:Games'..msg.chat_id_,true)  
end
if text == "تفعيل الرابط" or text == "تفعيل جلب الرابط" then 
if Admin(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تفعيل جلب رابط المجموعه'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:del(HASSAN.."Abs:Lock:GpLinks"..msg.chat_id_)
return false  
end
end
if text == "تعطيل الرابط" or text == "تعطيل جلب الرابط" then 
if Admin(msg) then
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم تعطيل جلب رابط المجموعه'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
DevAbs:set(HASSAN.."Abs:Lock:GpLinks"..msg.chat_id_,"ok")
return false  
end
end
if text and text:match('^تفعيل$') and SudoBot(msg) and ChCheck(msg) then
if ChatType ~= 'sp' then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
if tonumber(data.member_count_) < tonumber(DevAbs:get(HASSAN..'Abs:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عدد اعضاء المجموعه اقل من ↫ *'..(DevAbs:get(HASSAN..'Abs:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
DevAbs:del(HASSAN..'Abs:AbsConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_
for i=0 , #admins do
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAbs:srem(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)
else
DevAbs:sadd(HASSAN..'Abs:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevAbs:sadd(HASSAN.."Abs:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAbs:sadd(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevAbs:srem(HASSAN.."Abs:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevAbs:srem(HASSAN.."Abs:AbsConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevAbs:sismember(HASSAN..'Abs:Groups',msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه بالتاكيد مفعله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","⌁︙تم تفعيل المجموعه "..dp.title_)  
DevAbs:sadd(HASSAN.."Abs:Groups",msg.chat_id_)
if not DevAbs:get(HASSAN..'Abs:SudosGp'..msg.sender_user_id_..msg.chat_id_) and not SecondSudo(msg) then 
DevAbs:incrby(HASSAN..'Abs:Sudos'..msg.sender_user_id_,1)
DevAbs:set(HASSAN..'Abs:SudosGp'..msg.sender_user_id_..msg.chat_id_,"abs")
end
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAbs:set(HASSAN.."Abs:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"⌁︙تم تفعيل مجموعه جديده ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙بواسطة ↫ "..Name.."\n⌁︙اسم المجموعه ↫ ["..NameChat.."]\n⌁︙عدد اعضاء المجموعه ↫ ❨ *"..NumMem.."* ❩\n⌁︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⌁︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الوقت ↫ "..os.date("%I:%M%p").."\n⌁︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end,nil)
end
if text == 'تعطيل' and SudoBot(msg) and ChCheck(msg) then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
if not DevAbs:sismember(HASSAN..'Abs:Groups',msg.chat_id_) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙المجموعه بالتاكيد معطله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","⌁︙تم تعطيل المجموعه "..dp.title_)  
DevAbs:srem(HASSAN.."Abs:Groups",msg.chat_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevAbs:set(HASSAN.."Abs:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"⌁︙تم تعطيل مجموعه جديده ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙بواسطة ↫ "..Name.."\n⌁︙اسم المجموعه ↫ ["..NameChat.."]\n⌁︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⌁︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الوقت ↫ "..os.date("%I:%M%p").."\n⌁︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end
end
if text and text:match("^المطور$") then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
if not Sudo(msg) then
SendText(DevId,"⌁︙هناك من بحاجه الى مساعده ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الشخص ↫ "..Name.."\n⌁︙اسم المجموعه ↫ ["..NameChat.."]\n⌁︙ايدي المجموعه ↫ ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⌁︙رابط المجموعه ↫ ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الوقت ↫ "..os.date("%I:%M%p").."\n⌁︙التاريخ ↫ "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end
if text == 'جلب نسخه السورس' then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
sendDocument(DevId, 0, 0, 1, nil, './HASSAN.lua', dl_cb, nil)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عزيزي المطور تم ارسال نسخة ملف السورس الى الخاص', 1, 'md')
end end
if text == 'روابط الكروبات' or text == 'روابط المجموعات' then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
local List = DevAbs:smembers(HASSAN.."Abs:Groups")
if #List == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لا يوجد مجموعات مفعله', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙جاري ارسال نسخه تحتوي على '..#List..' مجموعه', 1, 'md')
local text = "⌁︙Source HASSAN\n⌁︙File Bot Groups\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local GroupsManagers = DevAbs:scard(HASSAN.."Abs:Managers:"..v) or 0
local GroupsAdmins = DevAbs:scard(HASSAN.."Abs:Admins:"..v) or 0
local Groupslink = DevAbs:get(HASSAN.."Abs:Groups:Links" ..v)
text = text..k.." ↬ ⤈ \n⌁︙Group ID ↬ "..v.."\n⌁︙Group Link ↬ "..(Groupslink or "Not Found").."\n⌁︙Group Managers ↬ "..GroupsManagers.."\n⌁︙Group Admins ↬ "..GroupsAdmins.."\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end
local File = io.open('GroupsBot.txt', 'w')
File:write(text)
File:close()
local abbas = 'https://api.telegram.org/bot' .. TokenBot .. '/sendDocument'
local curl = 'curl "' .. abbas .. '" -F "chat_id=' .. msg.chat_id_ .. '" -F "document=@' .. 'GroupsBot.txt' .. '"'
io.popen(curl)
end
end
end
if text == "اذاعه بالخاص" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه خاص ⌁" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAbs:setex(HASSAN.."Abs:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⌁︙للخروج ارسل ↫ ( الغاء ) \n ✓'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAbs:get(HASSAN.."Abs:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevAbs:smembers(HASSAN..'Abs:Users') 
if msg.content_.text_ then
for k,v in pairs(List) do 
AbsText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AbsText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AbsText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AbsText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AbsText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AbsText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AbsText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AbsText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اذاعة "..AbsText.." بنجاح \n⌁︙‏الى ↫ ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
if text == "اذاعه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه عام ⌁" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAbs:setex(HASSAN.."Abs:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⌁︙للخروج ارسل ↫ ( الغاء ) \n ✓'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAbs:get(HASSAN.."Abs:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevAbs:smembers(HASSAN..'Abs:Groups') 
if msg.content_.text_ then
for k,v in pairs(List) do 
AbsText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AbsText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AbsText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AbsText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AbsText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AbsText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AbsText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AbsText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اذاعة "..AbsText.." بنجاح \n⌁︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
if text == "اذاعه بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه عام بالتوجيه ⌁" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAbs:setex(HASSAN.."Abs:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙ارسل الرساله الان لتوجيها \n⌁︙للخروج ارسل ↫ ( الغاء ) \n ✓'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAbs:get(HASSAN.."Abs:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevAbs:smembers(HASSAN..'Abs:Groups')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اذاعة رسالتك بالتوجيه \n⌁︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
if text == "اذاعه خاص بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه خاص بالتوجيه ⌁" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAbs:setex(HASSAN.."Abs:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙ارسل الرساله الان لتوجيها \n⌁︙للخروج ارسل ↫ ( الغاء ) \n ✓'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAbs:get(HASSAN.."Abs:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevAbs:smembers(HASSAN..'Abs:Users')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اذاعة رسالتك بالتوجيه \n⌁︙‏الى ↫ ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
if text == "اذاعه بالتثبيت" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "↫ اذاعه بالتثبيت ⌁" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevAbs:get(HASSAN.."Abs:Send:Bot"..HASSAN) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⌁︙الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevAbs:setex(HASSAN.."Abs:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙ارسل لي سواء ↫ ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⌁︙للخروج ارسل ↫ ( الغاء ) \n ✓'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevAbs:get(HASSAN.."Abs:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" then   
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local List = DevAbs:smembers(HASSAN.."Abs:Groups") 
if msg.content_.text_ then
for k,v in pairs(List) do 
AbsText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.text_) 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
AbsText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,photo) 
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
AbsText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.animation_.animation_.persistent_id_)
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
AbsText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.video_.video_.persistent_id_)
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
AbsText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.voice_.voice_.persistent_id_)
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
AbsText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.audio_.audio_.persistent_id_)
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
AbsText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.document_.document_.persistent_id_)
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
AbsText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
DevAbs:set(HASSAN..'Abs:PinnedMsgs'..v,msg.content_.sticker_.sticker_.persistent_id_) 
end 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم اذاعة "..AbsText.." بالتثبيت \n⌁︙‏في ↫ ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevAbs:del(HASSAN.."Abs:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end
if text == 'حذف رد' and Manager(msg) and ChCheck(msg) or text == 'مسح رد' and  Manager(msg) and ChCheck(msg) then
DevAbs:set(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'DelGpRed')
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد' and Manager(msg) and ChCheck(msg) then
DevAbs:set(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'SetGpRed')
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetGpRed = DevAbs:get(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SetGpRed == 'SetGpRed' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل لي الرد سواء كان ↫ ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⌁︙يمكنك اضافة الى النص ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙للخروج ارسل ↫ ( الغاء )\n ✓" ,  1, "md")
DevAbs:set(HASSAN..'Abs:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'','SaveGpRed')
DevAbs:set(HASSAN..'Abs:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'',text)
DevAbs:sadd(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_..'',text)
DevAbs:set(HASSAN..'DelManagerRep'..msg.chat_id_..'',text)
return false
end
end
if text == 'حذف رد عام' and SecondSudo(msg) or text == '↫ حذف رد عام ⌁' and SecondSudo(msg) or text == 'مسح رد عام' and SecondSudo(msg) then
DevAbs:set(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_,'DelAllRed')
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد عام' and SecondSudo(msg) or text == '↫ اضف رد عام ⌁' and SecondSudo(msg) then
DevAbs:set(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_,'SetAllRed')
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetAllRed = DevAbs:get(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_)
if SetAllRed == 'SetAllRed' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل لي الرد سواء كان ↫ ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⌁︙يمكنك اضافة الى النص ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙للخروج ارسل ↫ ( الغاء )\n ✓" ,  1, "md")
DevAbs:set(HASSAN.."Abs:Add:AllRed"..msg.sender_user_id_,'SaveAllRed')
DevAbs:set(HASSAN.."Abs:Add:AllText"..msg.sender_user_id_, text)
DevAbs:sadd(HASSAN.."Abs:Sudo:AllRed",text)
DevAbs:set(HASSAN.."DelSudoRep",text)
return false 
end end
if text == 'الردود' and Manager(msg) and ChCheck(msg) or text == 'ردود المدير' and Manager(msg) and ChCheck(msg) then
local redod = DevAbs:smembers(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_..'')
MsgRep = '⌁︙ردود المدير ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for k,v in pairs(redod) do
if DevAbs:get(HASSAN.."Abs:Gif:GpRed"..v..msg.chat_id_) then
dp = 'متحركه 🎭'
elseif DevAbs:get(HASSAN.."Abs:Voice:GpRed"..v..msg.chat_id_) then
dp = 'بصمه 🎙'
elseif DevAbs:get(HASSAN.."Abs:Stecker:GpRed"..v..msg.chat_id_) then
dp = 'ملصق 🃏'
elseif DevAbs:get(HASSAN.."Abs:Text:GpRed"..v..msg.chat_id_) then
dp = 'رساله ✉'
elseif DevAbs:get(HASSAN.."Abs:Photo:GpRed"..v..msg.chat_id_) then
dp = 'صوره 🎇'
elseif DevAbs:get(HASSAN.."Abs:Video:GpRed"..v..msg.chat_id_) then
dp = 'فيديو 📽'
elseif DevAbs:get(HASSAN.."Abs:File:GpRed"..v..msg.chat_id_) then
dp = 'ملف 📁'
elseif DevAbs:get(HASSAN.."Abs:Audio:GpRed"..v..msg.chat_id_) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) ↫ {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '⌁︙لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end
if text == 'حذف الردود' and Manager(msg) and ChCheck(msg) or text == 'مسح الردود' and Manager(msg) and ChCheck(msg) or text == 'حذف ردود المدير' and Manager(msg) and ChCheck(msg) or text == 'مسح ردود المدير' and Manager(msg) and ChCheck(msg) then
local redod = DevAbs:smembers(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_..'')
if #redod == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevAbs:del(HASSAN..'Abs:Gif:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Voice:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Audio:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Photo:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Stecker:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Video:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:File:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Text:GpRed'..v..msg.chat_id_)
DevAbs:del(HASSAN..'Abs:Manager:GpRed'..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف ردود المدير")  
return false
end
end
if  text == "ردود المطور" and SecondSudo(msg) or text == "الردود العام" and SecondSudo(msg) or text == "ردود العام" and SecondSudo(msg) or text == "↫ الردود العام ⌁" and SecondSudo(msg) then
local redod = DevAbs:smembers(HASSAN.."Abs:Sudo:AllRed")
MsgRep = '⌁︙ردود المطور ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for k,v in pairs(redod) do
if DevAbs:get(HASSAN.."Abs:Gif:AllRed"..v) then
dp = 'متحركه 🎭'
elseif DevAbs:get(HASSAN.."Abs:Voice:AllRed"..v) then
dp = 'بصمه 🎙'
elseif DevAbs:get(HASSAN.."Abs:Stecker:AllRed"..v) then
dp = 'ملصق 🃏'
elseif DevAbs:get(HASSAN.."Abs:Text:AllRed"..v) then
dp = 'رساله ✉'
elseif DevAbs:get(HASSAN.."Abs:Photo:AllRed"..v) then
dp = 'صوره 🎇'
elseif DevAbs:get(HASSAN.."Abs:Video:AllRed"..v) then
dp = 'فيديو 📽'
elseif DevAbs:get(HASSAN.."Abs:File:AllRed"..v) then
dp = 'ملف 📁'
elseif DevAbs:get(HASSAN.."Abs:Audio:AllRed"..v) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) ↫ {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '⌁︙لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end
if text == "حذف ردود المطور" and SecondSudo(msg) or text == "حذف ردود العام" and SecondSudo(msg) or text == "مسح ردود المطور" and SecondSudo(msg) then
local redod = DevAbs:smembers(HASSAN.."Abs:Sudo:AllRed")
if #redod == 0 then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevAbs:del(HASSAN.."Abs:Add:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Gif:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Voice:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Audio:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Photo:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Stecker:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Video:AllRed"..v)
DevAbs:del(HASSAN.."Abs:File:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Text:AllRed"..v)
DevAbs:del(HASSAN.."Abs:Sudo:AllRed")
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⌁︙تم حذف ردود المطور")  
return false
end
end 
if text and text == "تغيير اسم البوت" or text and text == "وضع اسم البوت" or text and text == "تغير اسم البوت" then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل لي اسم البوت الان" ,  1, "md") 
DevAbs:set(HASSAN..'Abs:NameBot'..msg.sender_user_id_..'', 'msg')
return false 
end
end
if text and text == 'حذف اسم البوت' or text == 'مسح اسم البوت' then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
DevAbs:del(HASSAN..'Abs:NameBot')
local HASSANTEAM = '⌁︙اهلا عزيزي ↫ '..AbsRank(msg)..' \n⌁︙تم حذف اسم البوت'
absmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HASSANTEAM, 14, string.len(msg.sender_user_id_))
end end 
if text and text:match("^استعاده الاوامر$") and SecondSudo(msg) or text and text:match("^استعادة كلايش الاوامر$") and SecondSudo(msg) then
HelpList ={'Abs:Help','Abs:Help1','Abs:Help2','Abs:Help3','Abs:Help4','Abs:Help5','Abs:Help6'}
for i,Help in pairs(HelpList) do
DevAbs:del(HASSAN..Help) 
end
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم استعادة الكلايش الاصليه" ,  1, "md") 
end
if text == "تعيين الاوامر" and SecondSudo(msg) or text == "تعيين امر الاوامر" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (الاوامر) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help0'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help0'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help0'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "الاوامر" or text == "اوامر" or text == "مساعده" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر يخص الرتب الاعلى فقط\n⌁︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help')
local text =  [[
⌁︙اهلا بك في قائمة الاوامر ↫ ⤈ 
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙م1 ↫ اوامر الحمايه
⌁︙م2 ↫ اوامر الادمنيه
⌁︙م3 ↫ اوامر المدراء
⌁︙م4 ↫ اوامر المنشئين
⌁︙م5 ↫ اوامر المطورين
⌁︙م6 ↫ اوامر الاعضاء
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]] 
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end
end
if text == "تعيين امر م1" and SecondSudo(msg) or text == "تعيين امر م١" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م1) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help01'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help01'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help01'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help1', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م1" or text == "م١" or text == "اوامر1" or text == "اوامر١" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر يخص الرتب الاعلى فقط\n⌁︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help1')
local text =  [[
⌁︙اوامر حماية المجموعه ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙قفل • فتح ↫ الروابط
⌁︙قفل • فتح ↫ المعرفات
⌁︙قفل • فتح ↫ البوتات
⌁︙قفل • فتح ↫ المتحركه
⌁︙قفل • فتح ↫ الملصقات
⌁︙قفل • فتح ↫ الملفات
⌁︙قفل • فتح ↫ الصور
⌁︙قفل • فتح ↫ الفيديو
⌁︙قفل • فتح ↫ الاونلاين
⌁︙قفل • فتح ↫ الدردشة
⌁︙قفل • فتح ↫ التوجيه
⌁︙قفل • فتح ↫ الاغاني
⌁︙قفل • فتح ↫ الصوت
⌁︙قفل • فتح ↫ الجهات
⌁︙قفل • فتح ↫ الماركداون
⌁︙قفل • فتح ↫ التكرار
⌁︙قفل • فتح ↫ الهاشتاك
⌁︙قفل • فتح ↫ التعديل
⌁︙قفل • فتح ↫ التثبيت
⌁︙قفل • فتح ↫ الاشعارات
⌁︙قفل • فتح ↫ الكلايش
⌁︙قفل • فتح ↫ الدخول
⌁︙قفل • فتح ↫ الشبكات
⌁︙قفل • فتح ↫ المواقع
⌁︙قفل • فتح ↫ الفشار
⌁︙قفل • فتح ↫ الكفر
⌁︙قفل • فتح ↫ الطائفيه
⌁︙قفل • فتح ↫ الكل
⌁︙قفل • فتح ↫ العربيه
⌁︙قفل • فتح ↫ الانكليزيه
⌁︙قفل • فتح ↫ الفارسيه
⌁︙قفل • فتح ↫ التفليش
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙اوامر حمايه اخرى ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙قفل • فتح + الامر ↫ ⤈
⌁︙التكرار بالطرد
⌁︙التكرار بالكتم
⌁︙التكرار بالتقيد
⌁︙الفارسيه بالطرد
⌁︙البوتات بالطرد
⌁︙البوتات بالتقيد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م2" and SecondSudo(msg) or text == "تعيين امر م٢" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م2) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help21'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help21'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help21'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help2', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م2" or text == "م٢" or text == "اوامر2" or text == "اوامر٢" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر يخص الرتب الاعلى فقط\n⌁︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help2')
local text =  [[
⌁︙اوامر الادمنيه ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙الاعدادت
⌁︙تاك للكل 
⌁︙انشاء رابط
⌁︙ضع وصف
⌁︙ضع رابط
⌁︙ضع صوره
⌁︙حذف الرابط
⌁︙كشف البوتات
⌁︙طرد البوتات
⌁︙تنظيف + العدد
⌁︙تنظيف التعديل
⌁︙كللهم + الكلمه
⌁︙اسم البوت + الامر
⌁︙ضع • حذف ↫ ترحيب
⌁︙ضع • حذف ↫ قوانين
⌁︙اضف • حذف ↫ صلاحيه
⌁︙الصلاحيات • حذف الصلاحيات
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙ضع سبام + العدد
⌁︙ضع تكرار + العدد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع مميز • تنزيل مميز
⌁︙المميزين • حذف المميزين
⌁︙كشف القيود • رفع القيود
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙حذف • مسح + بالرد
⌁︙منع • الغاء منع
⌁︙قائمه المنع
⌁︙حذف قائمه المنع
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تفعيل • تعطيل ↫ الرابط
⌁︙تفعيل • تعطيل ↫ الالعاب
⌁︙تفعيل • تعطيل ↫ الترحيب
⌁︙تفعيل • تعطيل ↫ كشف الاعدادات
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙طرد المحذوفين
⌁︙طرد ↫ بالرد • بالمعرف • بالايدي
⌁︙كتم • الغاء كتم
⌁︙تقيد • الغاء تقيد
⌁︙حظر • الغاء حظر
⌁︙المكتومين • حذف المكتومين
⌁︙المقيدين • حذف المقيدين
⌁︙المحظورين • حذف المحظورين
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تقييد دقيقه + عدد الدقائق
⌁︙تقييد ساعه + عدد الساعات
⌁︙تقييد يوم + عدد الايام
⌁︙الغاء تقييد ↫ لالغاء التقييد بالوقت
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م3" and SecondSudo(msg) or text == "تعيين امر م٣" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م3) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help31'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help31'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help31'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help3', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م3" or text == "م٣" or text == "اوامر3" or text == "اوامر٣" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر يخص الرتب الاعلى فقط\n⌁︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help3')
local text =  [[
⌁︙اوامر المدراء ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙فحص البوت
⌁︙ضع اسم + الاسم
⌁︙اضف • حذف ↫ رد
⌁︙ردود المدير
⌁︙حذف ردود المدير
⌁︙حذف قوائم المنع
⌁︙منع ↫ بالرد على ( ملصق • صوره • متحركه )
⌁︙حذف قائمه منع + ↫ ⤈
( الصور • المتحركات • الملصقات )
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تنزيل الكل
⌁︙رفع ادمن • تنزيل ادمن
⌁︙الادمنيه • حذف الادمنيه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تثبيت
⌁︙الغاء التثبيت
⌁︙اعاده التثبيت
⌁︙الغاء تثبيت الكل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تغير رد + اسم الرتبه + النص ↫ ⤈
⌁︙المطور • منشئ الاساسي
⌁︙المنشئ • المدير • الادمن
⌁︙المميز • المنظف • العضو
⌁︙حذف ردود الرتب
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تغيير الايدي ↫ لتغيير الكليشه
⌁︙تعيين الايدي ↫ لتعيين الكليشه
⌁︙حذف الايدي ↫ لحذف الكليشه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تفعيل • تعطيل + الامر ↫ ⤈
⌁︙اطردني • الايدي بالصوره • الابراج
⌁︙معاني الاسماء • اوامر النسب
⌁︙الايدي • تحويل الصيغ • اوامر التحشيش
⌁︙ردود المدير • ردود المطور
⌁︙ضافني • حساب العمر • الزخرفه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م4" and SecondSudo(msg) or text == "تعيين امر م٤" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م4) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help41'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help41'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده" ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help41'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help4', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٤" or text == "م4" or text == "اوامر4" or text == "اوامر٤" then
if not Admin(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر يخص الرتب الاعلى فقط\n⌁︙ارسل ↫ (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help4')
local text =  [[
⌁︙اوامر المنشئين ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تنزيل الكل
⌁︙الميديا • امسح
⌁︙اضف • حذف ↫ امر
⌁︙حذف الاوامر المضافه
⌁︙الاوامر المضافه
⌁︙اضف نقاط ↫ بالرد • بالايدي
⌁︙اضف رسائل ↫ بالرد • بالايدي
⌁︙رفع منظف • تنزيل منظف
⌁︙المنظفين • حذف المنظفين
⌁︙رفع مدير • تنزيل مدير
⌁︙المدراء • حذف المدراء
⌁︙تفعيل • تعطيل + الامر ↫ ⤈
⌁︙نزلني • امسح
⌁︙الحظر • الكتم
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙اوامر المنشئين الاساسيين ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙وضع لقب + اللقب
⌁︙تفعيل • تعطيل ↫ الرفع
⌁︙رفع منشئ • تنزيل منشئ
⌁︙المنشئين • حذف المنشئين
⌁︙رفع • تنزيل ↫ مشرف
⌁︙رفع بكل الصلاحيات
⌁︙حذف القوائم
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙اوامر منشئ المجموعه ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ منشئ اساسي
⌁︙حذف المنشئين الاساسيين 
⌁︙المنشئين الاساسيين 
⌁︙حذف جميع الرتب
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م5" and SecondSudo(msg) or text == "تعيين امر م٥" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م5) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help51'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help51'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده " ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help51'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help5', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٥" or text == "م5" or text == "اوامر5" or text == "اوامر٥" then
if not SudoBot(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙هذا الامر للمطورين فقط', 1, 'md')
else
local Help = DevAbs:get(HASSAN..'Abs:Help5')
local text =  [[
⌁︙اوامر المطورين ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙الكروبات
⌁︙المطورين
⌁︙المشتركين
⌁︙الاحصائيات
⌁︙المجموعات
⌁︙اسم البوت + غادر
⌁︙اسم البوت + تعطيل
⌁︙كشف + -ايدي المجموعه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ مدير عام
⌁︙حذف • المدراء العامين 
⌁︙رفع • تنزيل ↫ ادمن عام
⌁︙حذف • الادمنيه العامين 
⌁︙رفع • تنزيل ↫ مميز عام
⌁︙حذف • المميزين عام 
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙اوامر المطور الاساسي ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تحديث
⌁︙الملفات
⌁︙المتجر
⌁︙السيرفر
⌁︙روابط الكروبات
⌁︙تحديث السورس
⌁︙تنظيف الكروبات
⌁︙تنظيف المشتركين
⌁︙حذف جميع الملفات
⌁︙تعيين الايدي العام
⌁︙تغير المطور الاساسي
⌁︙حذف معلومات الترحيب
⌁︙تغير معلومات الترحيب
⌁︙غادر + -ايدي المجموعه
⌁︙تعيين عدد الاعضاء + العدد
⌁︙حظر عام • الغاء العام
⌁︙كتم عام • الغاء العام
⌁︙قائمه العام • حذف قائمه العام
⌁︙وضع • حذف ↫ اسم البوت
⌁︙اضف • حذف ↫ رد عام
⌁︙ردود المطور • حذف ردود المطور
⌁︙تعيين • حذف • جلب ↫ رد الخاص
⌁︙جلب نسخه الكروبات
⌁︙رفع النسخه + بالرد على الملف
⌁︙تعيين • حذف ↫ قناة الاشتراك
⌁︙جلب كليشه الاشتراك
⌁︙تغيير • حذف ↫ كليشه الاشتراك
⌁︙رفع • تنزيل ↫ مطور
⌁︙المطورين • حذف المطورين
⌁︙رفع • تنزيل ↫ مطور ثانوي
⌁︙الثانويين • حذف الثانويين
⌁︙تعيين • حذف ↫ كليشة الايدي
⌁︙اذاعه للكل بالتوجيه ↫ بالرد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙تفعيل ملف + اسم الملف
⌁︙تعطيل ملف + اسم الملف
⌁︙تفعيل • تعطيل + الامر ↫ ⤈
⌁︙الاذاعه • الاشتراك الاجباري
⌁︙ترحيب البوت • المغادره
⌁︙البوت الخدمي • التواصل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م6" and SecondSudo(msg) or text == "تعيين امر م٦" and SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة (م6) الان " ,  1, "md")
DevAbs:set(HASSAN..'Abs:Help61'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HASSANTEAM =  DevAbs:get(HASSAN..'Abs:Help61'..msg.sender_user_id_)
if HASSANTEAM == 'msg' then
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ الكليشه الجديده" ,  1, "md")
DevAbs:del(HASSAN..'Abs:Help61'..msg.sender_user_id_)
DevAbs:set(HASSAN..'Abs:Help6', text)
Dev_Abs(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٦" or text == "م6" or text == "اوامر6" or text == "اوامر٦" then
local Help = DevAbs:get(HASSAN..'Abs:Help6')
local text =  [[
⌁︙اوامر الاعضاء ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙السورس • موقعي • رتبتي • معلوماتي 
⌁︙رسائلي • حذف رسائلي • اسمي • معرفي 
⌁︙ايدي •ايديي • جهاتي • غنيلي • الالعاب 
⌁︙نقاطي • بيع نقاطي • القوانين • زخرفه 
⌁︙رابط الحذف • نزلني • اطردني • المطور 
⌁︙منو ضافني • مشاهدات المنشور • الرابط 
⌁︙رقمي •ايدي المجموعه • معلومات المجموعه 
⌁︙نسبه الحب • نسبه الكره • نسبه الغباء 
⌁︙نسبه الرجوله • نسبه الانوثه • التفاعل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙صلاحياتي
⌁︙كول + الكلمه
⌁︙زخرفه + اسمك
⌁︙برج + نوع البرج
⌁︙معنى اسم + الاسم
⌁︙احسب + تاريخ ميلادك
⌁︙بوسه • بوسها ↫ بالرد
⌁︙هينه • هينها ↫ بالرد • بالمعرف
⌁︙صيحه • صيحها ↫ بالرد • بالمعرف
⌁︙صلاحياته ↫ بالرد • بالمعرف • بالايدي
⌁︙ايدي • كشف  ↫ بالرد • بالمعرف • بالايدي
⌁︙تحويل + بالرد ↫ صوره • ملصق • صوت • بصمه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end
if text == "اوامر التحشيش" then
local text =  [[
⌁︙اوامر التحشيش ↫ ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ مطي
⌁︙المطايه • حذف المطايه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ ابن متعة
⌁︙أبناء المتعة • حذف أبناء المتعة
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ عفير
⌁︙العفيريين • حذف العفيريين
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ مهتدي
⌁︙المهتدين • حذف المهتدين
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ ابن نرجس الزانية
⌁︙ابناء نرجس الزانية • حذف ابناء نرجس الزانية
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ زرارة ابو الضراط
⌁︙الضراط • حذف الضراط
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ وهابي
⌁︙الوهابية • حذف الوهابية
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙رفع • تنزيل ↫ لطام
⌁︙اللطامه • حذف اللطامه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⌁︙[Source Channel](https://t.me/GO_XXO)
]]
Dev_Abs(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if SecondSudo(msg) then
if text == "تحديث السورس" or text == "تحديث سورس" then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙جاري تحديث سورس اهل البيت بين الاتباع والابتداع', 1, 'md') 
os.execute('rm -rf HASSAN.lua') 
os.execute('wget https://raw.githubusercontent.com/HASSANTEAM/HASSAN/master/HASSAN.lua') 
dofile('HASSAN.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n          ( تم تحديث السورس )          \n\27[0;34;49m\n") 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم التحديث الى الاصدار الجديد', 1, 'md') 
end
if text == 'تحديث' or text == 'تحديث البوت' or text == '↫ تحديث ⌁' then  
dofile('HASSAN.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n        ( تم تحديث ملفات البوت )        \n\27[0;34;49m\n") 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم تحديث ملفات البوت", 1, "md")
end 
if text == 'الملفات' then
Files = '\n⌁︙الملفات المفعله في البوت ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
i = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
i = i + 1
Files = Files..i..'~ : `'..v..'`\n'
end
end
if i == 0 then
Files = '⌁︙لا توجد ملفات في البوت'
end
send(msg.chat_id_, msg.id_,Files)
end
if text == "متجر الملفات" or text == 'المتجر' then
local Get_Files, res = https.request("https://raw.githubusercontent.com/HASSANTEAM/HASSANFiles/master/getfile.json")
if res == 200 then
local Get_info, res = pcall(JSON.decode,Get_Files);
vardump(res.plugins_)
if Get_info then
local TextS = "\n⌁︙قائمة ملفات متجر سورس اهل البيت بين الاتباع والابتداع\n⌁︙الملفات المتوفره حاليا ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
local TextE = "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙علامة ↫ (✔) تعني الملف مفعل\n⌁︙علامة ↫ (✖️) تعني الملف معطل\n"
local NumFile = 0
for name,Info in pairs(res.plugins_) do
local CheckFileisFound = io.open("Files/"..name,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
CheckFile = "(✔)"
else
CheckFile = "(✖️)"
end
NumFile = NumFile + 1
TextS = TextS.."⌁︙"..Info..' ↫ ⤈\n'..NumFile.."~ : `"..name..'` ↬ '..CheckFile.."\n"
end
send(msg.chat_id_, msg.id_,TextS..TextE) 
end
else
send(msg.chat_id_, msg.id_,"⌁︙لا يوجد اتصال من الـapi") 
end
end
if text == "مسح جميع الملفات" or text == "حذف جميع الملفات" then
os.execute("rm -fr Files/*")
send(msg.chat_id_,msg.id_,"⌁︙تم حذف جميع الملفات المفعله")
end
if text and text:match("^(تعطيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تعطيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/HASSANTEAM/HASSANFiles/master/HASSANFiles/"..FileName)
if Res == 200 then
os.execute("rm -fr Files/"..FileName)
send(msg.chat_id_, msg.id_,"\n⌁︙الملف ↫ *"..FileName.."*\n⌁︙تم تعطيله وحذفه من البوت بنجاح") 
dofile('HASSAN.lua')  
else
send(msg.chat_id_, msg.id_,"⌁︙لا يوجد ملف بهذا الاسم") 
end
end
if text and text:match("^(تفعيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تفعيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/HASSANTEAM/HASSANFiles/master/HASSANFiles/"..FileName)
if Res == 200 then
local ChekAuto = io.open("Files/"..FileName,'w+')
ChekAuto:write(GetJson)
ChekAuto:close()
send(msg.chat_id_, msg.id_,"\n⌁︙الملف ↫ *"..FileName.."*\n⌁︙تم تفعيله في البوت بنجاح") 
dofile('HASSAN.lua')  
else
send(msg.chat_id_, msg.id_,"⌁︙لا يوجد ملف بهذا الاسم") 
end
return false
end
end 
if text and (text == 'حذف معلومات الترحيب' or text == 'مسح معلومات الترحيب') and SecondSudo(msg) then    
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم حذف معلومات الترحيب', 1, 'md')   
DevAbs:del(HASSAN..'Abs:Text:BotWelcome')
DevAbs:del(HASSAN..'Abs:Photo:BotWelcome')
return false
end 
if text and (text == 'تفعيل ترحيب البوت' or text == 'تفعيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تفعيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevAbs:del(HASSAN..'Abs:Lock:BotWelcome')
return false
end 
if text and (text == 'تعطيل ترحيب البوت' or text == 'تعطيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تعطيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevAbs:set(HASSAN..'Abs:Lock:BotWelcome',true)
return false
end 
if text and (text == 'تغير معلومات الترحيب' or text == 'تغيير معلومات الترحيب' or text == '↫ تغير معلومات الترحيب ⌁') and SecondSudo(msg) then    
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙ارسل لي نص الترحيب', 1, 'md') 
DevAbs:del(HASSAN..'Abs:Text:BotWelcome')
DevAbs:del(HASSAN..'Abs:Photo:BotWelcome')
DevAbs:set(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_,"Text") 
return false
end 
if text and DevAbs:get(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_) == 'Text' then 
if text and text:match("^الغاء$") then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء الامر", 1, "md") 
DevAbs:del(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_)   
return false
end 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ النص ارسل لي صورة الترحيب\n⌁︙ارسل ↫ الغاء لحفظ النص فقط", 1, 'md')   
DevAbs:set(HASSAN.."Abs:Text:BotWelcome",text) 
DevAbs:set(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_,"Photo") 
return false 
end 
if DevAbs:get(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_) == 'Photo' then 
if text and text:match("^الغاء$") then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ النص والغاء حفظ صورة الترحيب", 1, "md") 
DevAbs:del(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_)    
return false
end 
if msg.content_.photo_ and msg.content_.photo_.sizes_[1] then   
DevAbs:set(HASSAN.."Abs:Photo:BotWelcome",msg.content_.photo_.sizes_[1].photo_.persistent_id_)
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حفظ النص وصورة الترحيب", 1, 'md')   
DevAbs:del(HASSAN.."Abs:Set:BotWelcome"..msg.sender_user_id_)   
end
return false
end
if text and text:match("^ضع كليشه المطور$") or text and text:match("^وضع كليشه المطور$") or text and text:match("^تغيير كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙ارسل كليشة المطور الان ", 1, "md")
DevAbs:setex(HASSAN.."Abs:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 300, true)
end end
if text and text:match("^مسح كليشه المطور$") or text and text:match("^حذف كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم حذف كليشة المطور", 1, "md")
DevAbs:del(HASSAN.."DevText")
end end
if DevAbs:get(HASSAN.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Abs(msg.chat_id_, msg.id_, 1, "⌁︙تم الغاء الامر", 1, "md") 
DevAbs:del(HASSAN.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevAbs:del(HASSAN.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local texxt = string.match(text, "(.*)") 
DevAbs:set(HASSAN..'Abs:textch:user',texxt)
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙تم تغيير كليشة الاشتراك الاجباري', 1, 'md')
end
if text and text:match("^تغير كليشه الاشتراك$") and SecondSudo(msg) or text and text:match("^تغيير كليشه الاشتراك$") and SecondSudo(msg) then  
DevAbs:setex(HASSAN.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
local text = '⌁︙حسنا ارسل كليشة الاشتراك الجديده'  
Dev_Abs(msg.chat_id_, msg.id_, 1,text, 1, 'md') 
end
if text == "حذف كليشه الاشتراك الاجباري" or text == "حذف كليشه الاشتراك" then  
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
DevAbs:del(HASSAN..'Abs:textch:user')
textt = "⌁︙تم حذف كليشة الاشتراك الاجباري"
Dev_Abs(msg.chat_id_, msg.id_, 1,textt, 1, 'md') 
end end
if text == 'كليشه الاشتراك' or text == 'جلب كليشه الاشتراك' then
if not SecondSudo(msg) then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙للمطور الاساسي فقط ', 1, 'md')
else
local chtext = DevAbs:get(HASSAN.."Abs:textch:user")
if chtext then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙كليشة الاشتراك ↫ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n['..chtext..']', 1, 'md')
else
local DevAbs6 = DevAbs:get(HASSAN.."DevAbs3")
if DevAbs6 then
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙عليك الاشتراك في قناة البوت \n⌁︙قناة البوت ↫ '..DevAbs6, 1, "html")
else
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙لم يتم تعيين قناة الاشتراك الاجباري \n⌁︙ارسل ↫ تعيين قناة الاشتراك للتعيين ', 1, 'md')
end end end end
if text == 'القناة' or text == 'قناة السورس' or text == 'قناه السورس' or text == 'قنات السورس' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, '⌁︙Channel ↬ @GO_XXO', 1, 'html')    
end 
if Sudo(msg) then 
if text == 'معلومات السيرفر' or text == 'السيرفر' then 
Dev_Abs(msg.chat_id_, msg.id_, 1, io.popen([[
LinuxVersion=`lsb_release -ds`
MemoryUsage=`free -m | awk 'NR==2{printf "%s/%sMB {%.2f%%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
Percentage=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
UpTime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}'`
echo '⌁︙نظام التشغيل ↫ ⤈\n`'"$LinuxVersion"'`' 
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الذاكره العشوائيه ↫ ⤈\n`'"$MemoryUsage"'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙وحدة التخزين ↫ ⤈\n`'"$HardDisk"'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙المعالج ↫ ⤈\n`'"`grep -c processor /proc/cpuinfo`""Core ~ {$Percentage%} "'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الدخول ↫ ⤈\n`'`whoami`'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙مدة تشغيل السيرفر ↫ ⤈\n`'"$UpTime"'`'
]]):read('*a'), 1, 'md')
end
end
HASSANFiles(msg)
elseif (data.ID == "UpdateMessageEdited") then
local msg = data
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.message_id_)},function(extra, result, success)
DevAbs:incr(HASSAN..'Abs:EditMsg'..result.chat_id_..result.sender_user_id_)
local text = result.content_.text_ or result.content_.caption_
local Text = result.content_.text_
if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) and not Text and not BasicConstructor(result) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
Media = 'الميديا'
if result.content_.ID == "MessagePhoto" then Media = 'الصوره'
elseif result.content_.ID == "MessageSticker" then Media = 'الملصق'
elseif result.content_.ID == "MessageVoice" then Media = 'البصمه'
elseif result.content_.ID == "MessageAudio" then Media = 'الصوت'
elseif result.content_.ID == "MessageVideo" then Media = 'الفيديو'
elseif result.content_.ID == "MessageAnimation" then Media = 'المتحركه'
end
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,dp) 
local absname = '⌁︙العضو ↫ ['..CatchName(dp.first_name_,15)..'](tg://user?id='..dp.id_..')'
local absid = '⌁︙ايديه ↫ `'..dp.id_..'`'
local abstext = '⌁︙قام بالتعديل على '..Media
local abstxt = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تعالو يامشرفين اعتقد يوجد مخرب لان قام بالتعديل على الصور'
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_  
text = '\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for i=0 , #admins do 
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,data) 
if data.first_name_ ~= false then
text = text.."~ [@"..data.username_.."]\n"
end
if #admins == i then 
SendText(msg.chat_id_, absname..'\n'..absid..'\n'..abstext..text..abstxt,0,'md') 
end
end,nil)
end
end,nil)
end,nil)
end
if not VipMem(result) then
Filters(result, text)
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or text:match("#") or text:match("@") or text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match("[Ww][Ww][Ww].") or text:match(".[Xx][Yy][Zz]") then
if DevAbs:get(HASSAN..'Abs:Lock:EditMsgs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
end end end 
end,nil)
elseif (data.ID == "UpdateMessageSendSucceeded") then
local msg = data.message_
local text = msg.content_.text_
local GetMsgPin = DevAbs:get(HASSAN..'Abs:PinnedMsgs'..msg.chat_id_)
if GetMsgPin ~= nil then
if text == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) if dp.ID == 'Ok' then;DevAbs:del(HASSAN..'Abs:PinnedMsgs'..msg.chat_id_);end;end,nil)   
elseif (msg.content_.sticker_) then 
if GetMsgPin == msg.content_.sticker_.sticker_.persistent_id_ then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAbs:del(HASSAN..'Abs:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.animation_) then 
if msg.content_.animation_.animation_.persistent_id_ == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAbs:del(HASSAN..'Abs:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.photo_) then
if msg.content_.photo_.sizes_[0] then
id_photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
id_photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
id_photo = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
id_photo = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
if id_photo == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevAbs:del(HASSAN..'Abs:PinnedMsgs'..msg.chat_id_) end,nil)   
end end end
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
print('\27[30;32mجاري تنظيف المجموعات الوهميه يرجى الانتظار\n\27[1;37m')
local PvList = DevAbs:smembers(HASSAN..'Abs:Users')  
for k,v in pairs(PvList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data) end,nil) 
end 
local GpList = DevAbs:smembers(HASSAN..'Abs:Groups') 
for k,v in pairs(GpList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
tdcli_function({ID = "ChangeChatMemberStatus",chat_id_=v,user_id_=HASSAN,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
DevAbs:srem(HASSAN..'Abs:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevAbs:srem(HASSAN..'Abs:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevAbs:srem(HASSAN..'Abs:Groups',v)  
end
if data and data.code_ and data.code_ == 400 then
DevAbs:srem(HASSAN..'Abs:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusEditor" then
DevAbs:sadd(HASSAN..'Abs:Groups',v)  
end end,nil) end
end
end 
