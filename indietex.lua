-- make4ht build file to extract notes from the web page produced by indietex.sty and make4ht 
-- to standalone HTML pages with yaml header
--

-- the output directory is configurable using environmental variables
-- this can be useful in Github Actions or other server builds
-- use "./" if it should be the current dir. it must exist
local output_dir = os.getenv("indieweb_dir") or "notes"
local mkutils = require "mkutils"
local log = logging.new("indietex")


local domfilter = require "make4ht-domfilter"

local function process_note(note)
  local new_note = {}
  local date_el = note:query_selector(".dt-published")[1]
  if date_el then
    new_note.timestamp = date_el:get_attribute("datetime")
    new_note.humandate = date_el:get_text()
  end
  local title = note:query_selector("h1.p-name")[1]
  if title then
    new_note.title = title:get_text()
  end
  local replyto = note:query_selector(".u-in-reply-to")[1]
  if replyto then
    new_note.reply_link = replyto:get_attribute("href")
    new_note.reply_title = replyto:get_text()
  end
  new_note._content = note:query_selector(".e-content")[1]
  if new_note._content then
    new_note._text_content = new_note._content:get_text()
  end
  return new_note
end

local stop_words_tbl = { "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now" }

local stop_words = {}
for _,v in ipairs(stop_words_tbl) do
  stop_words[v] = true
end

local function make_slug(title, max_words)
  -- make simple slug from title or contents
  local max_words = max_words or 999
  -- simply remove all non-ascii letters
  if not title then return nil end
  local title = string.lower(title)
  local words = {}
  local count = 0
  for word in title:gmatch("([^%s]+)") do
    -- remove all non-letter from word
    word = word:gsub("[%W]", "")
    -- remove stop words 
    if not stop_words[word] and word ~= "" then
      count = count + 1
      -- add only max_words words
      if count <= max_words then
        words[#words+1] = word
      end
    end
  end
  return table.concat(words, "-")
end

local function get_slug_date(timestamp)
  local timestamp = timestamp or ""
  -- get date component from the timestamp
  return timestamp:match("^(%d+%-%d+%-%d+)") or ""
end

local function save_note(note)
  -- make slug either from title or from the content, if title is missing
  local slug = make_slug(note.title) or make_slug(note._text_content, 6)
  local date = get_slug_date(note.timestamp)
  local output_dir = output_dir:gsub("/*$", "")
  -- base output filename on the output_dir, date and slug
  local filename = string.format("%s/%s-%s.html", output_dir, date, slug)
  local f, msg = io.open(filename, "w") 
  if not f then
    log:error("Cannot open output file", filename)
    log:debug(msg)
    return nil, msg
  end
  log:debug("Saving note: " .. filename)
  f:write("---\n")
  for key, value in pairs(note) do
    if not key:match("^_") then-- ignore keys starting with underscore, they are special
      f:write(key .. ': "' .. value .. "\"\n")
    end
  end
  f:write("---\n")
  f:write(note._content:serialize())
  f:close()
end


local function prepare_dir(path)
  mkutils.make_path(path)
end

local process = domfilter {
  function(dom)
    prepare_dir(output_dir)
    for _, note in ipairs(dom:query_selector(".h-entry")) do
      local new_note = process_note(note)
      save_note(new_note)
    end
    return dom
  end

}

Make:match("html$", process)
