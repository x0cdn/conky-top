function conky_kernel_release()
  local f = io.popen("uname -r 2>/dev/null")
  local r = f and f:read("*l") or ""
  if f then f:close() end
  r = r or ""
  return (r:gsub("%-cachyos.*", "-arch1-1"))
end
