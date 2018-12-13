class Dir
  def self.tmpdir
    tmpdir = ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || ENV['USERPROFILE'] || "/tmp"

    tmpdir
  end

  def self._tmpname(prefix_suffix = nil, tmpdir = nil)
    tmpdir ||= tmpdir()

    prefix, suffix = (prefix_suffix || 'd')
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
    path = _tmpname(prefix_suffix, tmpdir) { |p| mkdir(p, 0700) }
    return path unless block_given?

    begin
      yield path.dup
    ensure
      if Tempfile._world_writable_and_not_sticky(File.dirname(path))
        raise ArgumentError, "parent directory is world writable but not sticky"
      end
      Tempfile._rm_rf(path)
    end
  end
end
