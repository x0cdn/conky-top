-- Read cached process lists for Conky. The heavy ps/proc scans are done once
-- by panel_data.sh; these functions only read one line from the cache files.
local base = '/home/topsh/.config/conky/'

local function read_line(file, n)
  local f = io.open(base .. file, 'r')
  if not f then return '' end
  local i = 1
  for line in f:lines() do
    if i == tonumber(n) then
      f:close()
      return line
    end
    i = i + 1
  end
  f:close()
  return ''
end

function conky_cpu(n)
  return read_line('cpu_procs.state', n)
end

function conky_mem(n)
  return read_line('mem_procs.state', n)
end

function conky_swap(n)
  return read_line('swap_procs.state', n)
end
