--[=[

  Exercise 16.1: Frequently, it is useful to add some prefix to a chunk of code
  when loading it. (We saw an example previously in this chapter, where we
  prefixed a return to an expression being loaded.) Write a function
  loadwithprefix that works like load, except that it adds its extra first
  argument (a string) as a prefix to the chunk being loaded.

  Like the original load, loadwithprefix should accept chunks represented both
  as strings and as reader functions. Even in the case that the original chunk
  is a string, loadwithprefix should not actually concatenate the prefix with
  the chunk. Instead, it should call load with a proper reader function that
  first returns the prefix and then returns the original chunk.

--]=]

function loadwithprefix(prefix, chunk)
  local n = 1 -- counter for which argument to return

  local function reader()
    if n == 1 then
      n = n + 1
      return prefix
    elseif n == 2 then
      if type(chunk) == "function" then -- don't increment n for function so we can
        return chunk()                  -- call it as many times as needed
      else
        n = n + 1
        return chunk
      end
    end
    return nil
  end

  return load(reader)
end

function test(n)
  return function()
           while n > 0 do
             n = n - 1
             return "print("..tostring(n+1)..")"
           end
           return nil
         end
end

local countdown = test(3)

-- use assert to make sure chunk was compiled okay
func = assert(loadwithprefix("print('Prefix for function')", countdown))
func()
--> Prefix for function
--> 3
--> 2
--> 1

func = assert(loadwithprefix("print('Prefix for string'); local a = 1", "print('a=',a)"))
func()
--> Prefix for string
--> a=      1

print(a)
--> nil   ('a' in second chunk is local therefore global 'a' should be nil)
 
