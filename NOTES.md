# Ruby Notes


## Newlines Gotchas (\r\n, \r, \n)

Did you know? On Windows (Ruby's) `File.read/write`
ALWAYS change `\n`  to `\r\n`?

Did you know? Modern Ruby leaves `\r` (classic Mac OS 9 before OS X)
alone (NOT longer treated as newline) only `\n` or `\r\n`.


```
A standalone \r (Carriage Return) is not supported
as a newline by default in modern Ruby methods
like File.read, File.foreach, or IO.readlines.
```


```
When you open a file using standard text modes
(like "w", "a", or via File.write),
Ruby automatically translates every standalone \n into \r\n
as it writes to the disk.ruby

Running on Windows:
File.write("output.txt", "Hello\nWorld")
# The actual bytes saved to disk will be: "Hello\r\nWorld"
```

**Universal Newline Options**

```
# Force Ruby to translate \r\n and \r into standard \n during the read operation
content = File.read("legacy_file.txt", newline: :universal)

Alternatively, you can achieve the same behavior using internal encoding options:
content = File.read("legacy_file.txt", encoding: "UTF-8", universal_newline: true)

Both approaches normalize all occurrences of \r\n and \r
into a unified \n character in memory,
ensuring standard string utilities behave predictably.
```

**Windows**

```
Windows historically uses \r\n for text files,
which causes Ruby to implement an automatic text-mode translation layer.

1.  Default (Text) Mode
When you open a file using standard text modes (like "w", "a", or via File.write),
Ruby automatically translates every standalone \n into \r\n
as it writes to the disk.

File.write("output.txt", "Hello\nWorld")
# The actual bytes saved to disk will be: "Hello\r\nWorld"


Force Linux Newlines (\n) Every where

Even if your script runs on Windows, this suppresses
the automatic OS translation layer and outputs strict LF:

File.write("linux_export.txt", "Line 1\nLine 2", newline: :lf)
```

```
If you want a bulletproof configuration for scripts that run on both Linux and Windows, use the explicit newline: hash options. They make your architectural intent clear to anyone reading your code:ruby# Universal Cross-Platform Clean Read/Write
shared_options = { encoding: "UTF-8", newline: :lf }

# 1. Read and instantly normalize to LF
text = File.read("source.txt", **shared_options)

# 2. Process text here...
processed_text = text.upcase

# 3. Write out keeping strict LF
File.write("destination.txt", processed_text, **shared_options)
```
