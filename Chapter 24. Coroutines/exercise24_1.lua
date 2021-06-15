--[=[

  Exercise 24.1: Rewrite the producer–consumer example in the section called
  “Who Is the Boss?” using a producer-driven design, where the consumer is the
  coroutine and the producer is the main thread.

--]=]

function receive ()
  return coroutine.yield() -- yield receives x from producer
end

function send (cons, x)
  coroutine.resume(cons,x)  -- resume consumer with x
end

function producer (cons)
  while true do
    local x = io.read() -- produce new value
    send(cons, x)       -- send it to consumer by resuming it's thread
  end
end

function filter (cons)
  return coroutine.create(function (x) -- producer already sent first x
    for line = 1, math.huge do
      x = string.format("%5d %s", line, x)
      send(cons, x) -- send it to consumer
      x = receive() -- wait for another value from producer
    end
  end)
end

function consumer ()
  return coroutine.create(function (x) -- since producer is the boss, x was already sent
    while true do
      io.write(x, "\n")   -- consume new value
      x = receive()       -- wait for another value from producer
    end
  end)
end

producer(filter(consumer()))
