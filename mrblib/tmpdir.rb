class Dir

  def self.tmpdir
    tmpdir = ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || ENV['USERPROFILE'] || "/tmp"

    tmpdir
  end

  def self._traverse(path)
    if File.directory?(path)
      Dir.entries(path) {|entry| _traverse(entry) }
    end
  ensure
    yield path
  end

  def self.mktmpdir(prefix_suffix=nil, *rest)
    path = Tmpname.create(prefix_suffix || "d", *rest) {|n| mkdir(n, 0700)}
    if block_given?
      begin
        yield path
      ensure
        stat = File.stat(File.dirname(path))
        if stat.world_writable? and !stat.sticky?
          raise ArgumentError, "parent directory is world writable but not sticky"
        end
        _traverse(path) {|entry|
          if File.directory?(entry)
            Dir.delete(entry)
          else
            File.delete(entry)
          end
        }
      end
    else
      path
    end
  end

  module Tmpname

    def self.tmpdir
      Dir.tmpdir
    end

    def self.create(basename, tmpdir=nil, opts={})
      tmpdir ||= tmpdir()
      max_try = opts.delete(:max_try)
      n = nil
      prefix, suffix = basename
      prefix = ((prefix.respond_to?(:to_str) && prefix.to_str) or
                raise ArgumentError, "unexpected prefix: #{prefix.inspect}")
      suffix &&= ((suffix.respond_to?(:to_str) && suffix.to_str) or
                  raise ArgumentError, "unexpected suffix: #{suffix.inspect}")
      [prefix, suffix].each {|fix|
        [File::SEPARATOR, File::ALT_SEPARATOR].each {|sep|
          fix.gsub!(sep, '') if fix && sep
        }
      }

      begin
        now = Time.now
        t = sprintf("%04d%02d%02d", now.year, now.month, now.day)
        path = "#{prefix}#{t}--#{rand(0x100000000).to_s(36)}#{n ? %[-#{n}] : ''}#{suffix||''}"
        path = File.join(tmpdir, path)
        yield(path, n, opts)
      rescue Errno::EEXIST
        n ||= 0
        n += 1
        retry if !max_try or n < max_try
        raise "cannot generate temporary name using `#{basename}' under `#{tmpdir}'"
      end
      path
    end
  end
end
