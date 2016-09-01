mruby-tempfile
==============

Tempfile class for mruby (experimental)

depend on mruby-io(iij/mruby, mruby-support-io branch), mruby-dir, mruby-simple-random, mruby-sprintf, mruby-time

## Implemented methods

### Tempfile
 - http://docs.ruby-lang.org/ja/1.9.3/class/Tempfile.html

| method                           | mruby-tempfile | memo |
| -------------------------------- | -------------- | ---- |
| Tempfile.new, Tempfile.open      | o              |      |
| Tempfile#close                   | o              |      |
| Tempfile#close!                  | o              |      |
| Tempfile#delete, Tempfile#unlink | o              |      |
| Tempfile#length, Tempfile#size   | o              |      |
| Tempfile#open                    | x              |      |
| Tempfile#path                    | o              |      |


## License

Copyright (c) 2013 Internet Initiative Japan Inc.

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
