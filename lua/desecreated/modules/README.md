# Modules

These scripts should all return a table containing all of their relevant functions.
Ideally each script should construct itself only once. It can then store itself in a global table, and return this global table for all subsequent accesses.

Here is an example of the preferred behavior:

```lua
-- add.lua

if not addNumbers then
  
  local module = {}
  
  function module.add( x, y )
    return x+y
  end
  
  addNumbers = module
  
end

return addNumbers
```

Usage:

```lua

-- scriptusingadd.lua

local add = include("desecreated/modules/add.lua")

z = add.add( 5, 10 )
print( z )

-- 15
```
