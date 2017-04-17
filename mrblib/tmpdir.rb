class Dir
  def self.mktmpdir

  end

  def self.tmpdir
    tmpdir = ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || ENV['USERPROFILE'] || "/tmp"

    tmpdir
  end
end
