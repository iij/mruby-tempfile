class Dir

  def self.tmpdir
    tmpdir = ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || ENV['USERPROFILE'] || "/tmp"

    tmpdir
  end

  def self._tmpname(prefix_suffix = nil, tmpdir = nil)
    tmpdir ||= tmpdir()

    prefix, suffix = (prefix_suffix || 'd')
    if ! prefix.respond_to?(:to_str)
      raise ArgumentError, "unexpected prefix: #{prefix.inspect}"
    end
    prefix = prefix.to_str
    if suffix && ! suffix.respond_to?(:to_str)
      raise ArgumentError, "unexpected suffix: #{suffix.inspect}"
    end
    suffix = suffix.to_str if suffix
    [prefix, suffix].each {|fix|
      [File::SEPARATOR, File::ALT_SEPARATOR].each {|sep|
        fix.gsub!(sep, '') if fix && sep
      }
    }

    try = 0
    begin
      now = Time.now
      t = sprintf("%04d%02d%02d", now.year, now.month, now.day)
      rand_str = ''
      while rand_str.size < 7
        rand_str += rand(0x7fff).to_s(36) # 0x7fff is max value always ensured to be Fixnum
      end
      path = "#{prefix || ''}#{t}-#{Tempfile._getpid}-#{rand_str}#{try > 0 ? "-#{try}" : ''}#{suffix || ''}"
      path = File.join(tmpdir, path)
      yield path
    rescue Errno::EEXIST
      try += 1
      retry
    end
    path
  end

  def self.mktmpdir(prefix_suffix = nil, tmpdir = nil)

    path = _tmpname(prefix_suffix, tmpdir) {|p| mkdir(p, 0700) }

    if block_given?
      begin
        yield path
      ensure
        stat = File.stat(File.dirname(path))
        if stat.world_writable? and !stat.sticky?
          raise ArgumentError, "parent directory is world writable but not sticky"
        end
        remover = lambda {|path|
          if File.directory?(path)
            Dir.entries(path) {|entry| remover.call(entry) }
            Dir.delete(path)
          else
            File.delete(path)
          end
        }
        remover.call(path)
      end
    else
      path
    end
  end

end
