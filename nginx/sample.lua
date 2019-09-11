local redis = require "resty.redis"
local redisObject = redis:new()
redisObject:set_timeout(3000)

local ok, err = redisObject:connect("redis",6379)
if not ok then
  ngx.say("connection error: ",err)
  return
end

redisObject:incr(ngx.var.remote_addr)
redisObject:expire(ngx.var.remote_addr,30)

local counter = redisObject:get(ngx.var.remote_addr)
if tonumber(counter) > 10 then
  ngx.say("too much access")
else
  ngx.say("welcome!")
end