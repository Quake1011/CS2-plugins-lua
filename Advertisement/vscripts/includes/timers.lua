TIMERS_VERSION = "1.05.1"

TIMERS_THINK = 0.01

if Timers == nil then
  Timers = {}
  setmetatable(Timers, {
    __call = function(t, ...)
      return t:CreateTimer(...)
    end
  })
end

function Timers:start()
  Timers = self
  self.timers = {}
  local ent = SpawnEntityFromTableSynchronous("info_target", {targetname="timers_lua_thinker"})
  ent:SetThink("Think", self, "timers", TIMERS_THINK)
end

function Timers:Think()
  local now = Time()
  for k,v in pairs(Timers.timers) do
    local bUseGameTime = true
    if v.useGameTime ~= nil and v.useGameTime == false then
      bUseGameTime = false
    end
    local bOldStyle = false
    if v.useOldStyle ~= nil and v.useOldStyle == true then
      bOldStyle = true
    end
    local now = Time()
    if not bUseGameTime then
      now = Time()
    end
    if v.endTime == nil then
      v.endTime = now
    end
    if now >= v.endTime then
      Timers.timers[k] = nil
      Timers.runningTimer = k
      Timers.removeSelf = false
      local status, nextCall
      if v.context then
        status, nextCall = xpcall(function() return v.callback(v.context, v) end, function (msg)
                                    return msg..'\n'..debug.traceback()..'\n'
                                  end)
      else
        status, nextCall = xpcall(function() return v.callback(v) end, function (msg)
                                    return msg..'\n'..debug.traceback()..'\n'
                                  end)
      end

      Timers.runningTimer = nil
      if status then
        if nextCall and not Timers.removeSelf then
          if bOldStyle then
            v.endTime = v.endTime + nextCall - now
          else
            v.endTime = v.endTime + nextCall
          end
          Timers.timers[k] = v
        end
      else
        Timers:HandleEventError('Timer', k, nextCall)
      end
    end
  end

  return TIMERS_THINK
end

function Timers:HandleEventError(name, event, err)
  print(err)
  name = tostring(name or 'unknown')
  event = tostring(event or 'unknown')
  err = tostring(err or 'unknown')
  if not self.errorHandled then
    self.errorHandled = true
  end
end

function Timers:CreateTimer(name, args, context)
  if type(name) == "function" then
    if args ~= nil then
      context = args
    end
    args = {callback = name}
    name = DoUniqueString("timer")
  elseif type(name) == "table" then
    args = name
    name = DoUniqueString("timer")
  elseif type(name) == "number" then
    args = {endTime = name, callback = args}
    name = DoUniqueString("timer")
  end
  if not args.callback then
    print("Invalid timer created: "..name)
    return
  end
  local now = Time()
  if args.useGameTime ~= nil and args.useGameTime == false then
    now = Time()
  end
  if args.endTime == nil then
    args.endTime = now
  elseif args.useOldStyle == nil or args.useOldStyle == false then
    args.endTime = now + args.endTime
  end
  args.context = context
  Timers.timers[name] = args 
  return name
end

function Timers:RemoveTimer(name)
  Timers.timers[name] = nil
  if Timers.runningTimer == name then
    Timers.removeSelf = true
  end
end

function Timers:RemoveTimers(killAll)
  local timers = {}
  Timers.removeSelf = true
  if not killAll then
    for k,v in pairs(Timers.timers) do
      if v.persist then
        timers[k] = v
      end
    end
  end
  Timers.timers = timers
end

if not Timers.timers then Timers:start() end

