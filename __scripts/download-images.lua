-- A Pandoc Lua filter to download remote images to a local cache
-- This filter ensures that only actual Image elements are processed,
-- leaving code blocks and text descriptions untouched.

function Image (img)
  local src = img.src
  if src:match("^http") then
    -- Generate a unique cached path using SHA1 of the URL
    -- Note: pandoc.utils.sha1 is available in Pandoc 2.0+
    local hash = pandoc.sha1(src)
    local ext = src:match("%.([^%.]+)$") or "png"
    local local_path = ".cache/images/" .. hash .. "." .. ext
    
    -- Check if we already have it in cache
    local f = io.open(local_path, "r")
    if f then
      f:close()
    else
      -- Download it using curl
      -- We print to stderr to avoid polluting the JSON/AST output
      io.stderr:write("  📥 [Filter] Downloading: " .. src .. "\n")
      os.execute("mkdir -p .cache/images")
      os.execute("curl -s -L \"" .. src .. "\" -o " .. local_path)
    end
    
    -- Update the image source to the local path
    img.src = local_path
  end
  return img
end
