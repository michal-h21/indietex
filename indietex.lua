-- make4ht build file to extract notes from the web page produced by indietex.sty and make4ht 
-- to standalone HTML pages with yaml header
--

-- the output directory is configurable using environmental variables
-- this can be useful in Github Actions or other server builds
local output_dir = os.getenv("indieweb_dir") or "notes"

local domfilter = require "make4ht-domfilter"

local function process_note(note)
  local new_note = {}
  local date_el = note:query_selector(".dt-published")[1]
  if date_el then
    new_note.timestamp = date_el:get_attribute("datetime")
    new_note.date = date_el:get_text()
  end
  print "-----"
  for k,v in pairs(new_note) do
    print(k,v)
  end
  return new_note
end

local function save_note(note)
  -- code
end

local process = domfilter {
  function(dom)
    for _, note in ipairs(dom:query_selector(".h-entry")) do
      local new_note = process_note(note)
      save_note(new_note)
    end
    return dom
  end

}

Make:match("html$", process)
