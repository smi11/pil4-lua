--[=[

  Exercise 14.3: Modify the graph structure so that it can keep a label for each
  arc. The structure should represent each arc by an object, too, with two
  fields: its label and the node it points to. Instead of an adjacent set, each
  node keeps an incident set that contains the arcs that originate at that node.
  
  Adapt the function readgraph to read two node names plus a label from each
  line in the input file. (Assume that the label is a number.)

--]=]

-- Graphs

function name2node (graph, name)
  local node = graph[name]
  if not node then -- node does not exist; create a new one
    node = {name = name, incidents = {}}
    graph[name] = node
  end
  return node
end

-- Figure 14.3. Reading a graph from a file

function readgraph ()
  local graph = {}
  for line in io.lines() do -- split line in two names
    local namefrom, nameto, label = string.match(line, "(%S+)%s+(%S+)%s+(%d+)") -- find corresponding nodes
    local from = name2node(graph, namefrom)
    local to = name2node(graph, nameto)
    -- add an arc to incidents table
    from.incidents[to] = {label = tonumber(label), node = to}
  end
  return graph
end

-- Figure 14.4. Finding a path between two nodes

function findpath (curr, to, path, visited)
  path = path or {}
  visited = visited or {}
  if visited[curr] then -- node already visited?
    return nil -- no path here
  end
  visited[curr] = true -- mark node as visited
  path[#path + 1] = curr -- add it to path
  if curr == to then -- final node?
    return path
  end
  -- try all adjacent nodes
  for arc in pairs(curr.incidents) do
    local p = findpath(arc, to, path, visited)
    if p then return p end
  end
  table.remove(path) -- remove node from path
end

--

function printpath (path)
  for i = 1, #path do
    print(path[i].name, i < #path and path[i].incidents[path[i+1]].label or "")
  end
end

g = readgraph()
a = name2node(g, "a")
b = name2node(g, "b")
p = findpath(a, b)
if p then printpath(p) end
--> a 7   (printed path may differ each run)
--> 2 15
--> 4 11
--> 3 2
--> 6 9
--> b 
