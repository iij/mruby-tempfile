class Dir
  def self.mktmpdir

  end

  def self.tmpdir
    tmpdir = "/tmp" || ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || ENV['USERPROFILE']

    tmpdir
  end
end

