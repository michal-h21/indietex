# IndieTeX

Support for [Indieweb notes](https://indieweb.org/note) in LaTeX.

My idea is to create various notes a LaTeX source. Each note will be saved as a standalone HTML file using TeX4ht.

## intended Support

- https://indieweb.org/quotation
- https://indieweb.org/bookmark
- https://indieweb.org/reply
- https://indieweb.org/repost
- https://indieweb.org/note

## Titles 

Some post types shouldn't have titles (for example notes). This can create issues with RSS feeds, where title is needed.
Newsboat creates dummy titles, which is not nice. We can use something like "Note published on <date>" -- this is what Molly White does.

## links

- https://developer.mozilla.org/en-US/docs/Web/HTML/microformats

>> Microformats Prefixes
>> 
>> All microformats consist of a root, and a collection of properties.
>> Properties are all optional and potentially multivalued - applications
>> needing a singular value may use the first instance of a property.
>> Hierarchical data is represented with nested microformats, typically as
>> property values themselves.
>> 
>> All microformats class names use prefixes. Prefixes are syntax independent
>> of vocabularies, which are developed separately.
>> 
>>     "h-*" for root class names, e.g. "h-card", "h-entry", "h-feed", and many
>>     more. These top-level root classes usually indicate a type and
>>     corresponding expected vocabulary of properties. For example:
>>         h-card describes a person or organization
>>         h-entry describes episodic or date stamped online content like a blog post
>>         h-feed describes a stream or feed of posts
>>         You can find many more vocabularies on the microformats2 wiki.
>>     "p-*" for plain (text) properties, e.g. "p-name", "p-summary"
>>         Generic plain text parsing, element text in general. On certain HTML
>>         elements, use special attributes first, e.g. img/alt, abbr/title.
>>     "u-*" for URL properties, e.g. "u-url", "u-photo", "u-logo"
>>         Special parsing: element attributes a/href, img/src, object/data etc. attributes over element contents.
>>     "dt-*" for datetime properties, e.g. "dt-start", "dt-end", "dt-bday"
>>         Special parsing: time element datetime attribute,
>>         value-class-pattern and separate date time value parsing for
>>         readability.
>>     "e-*" for element tree properties where the entire contained element
>>     hierarchy is the value, e.g. "e-content". The "e-" prefix can also be
>>     mnemonically remembered as "element tree", "embedded markup", or
>>     "encapsulated markup".

- http://microformats.org/wiki/h-entry
