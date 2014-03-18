# -*- coding: utf-8 -*-

class Tempfile < File
  @@tempfiles = []

  def initialize(basename, tempdir = Dir::tmpdir)
    @deleted = false
    @basename = basename
    @mode = "w+"
    @perm = 0600
    @path = @path || make_tmpname(basename, tempdir)

    super(@path, @mode, @perm)

    @@tempfiles << self

    _set_path TempfilePath.new(@path)

    self
  end

  def self.delete_all
    while not @@tempfiles.empty?
      @@tempfiles.shift.delete
    end

  end

  def self.tempfiles
    @@tempfiles
  end

  def make_tmpname(basename, tempdir, n=nil)
    rand_max = 0x100000000
    t = Time.now
    ymd = sprintf("%04d%02d%02d", t.year, t.month, t.day)
    pid = Tempfile._getpid

    rand_str = rand(t.usec).to_s(36)

    while rand_str.size < 7
      rand_str += rand(Time.now.usec).to_s(36)
    end

    rand_str = rand_str[0, 7]

    if Array === basename
      prefix = basename[0]
      suffix = basename[1]
    elsif String === basename
      prefix = basename
      suffix = nil
    else
      raise ArgumentError, "basename is invalied."
    end

    path = "#{tempdir}/#{prefix}#{ymd}-#{pid}-#{rand_str}"
    path += "-#{suffix}" if suffix

    while File.exist?(path)
      n = n || 0
      path = "#{tempdir}/#{prefix}#{ymd}-#{pid}-#{rand_str}-#{n}{suffix}"
      n.succ!
    end

    path
  end

  def open
    close unless closed?
    tempfile  = initialize(@basename)

    tempfile
  end

  def close(real=false)
    super
    delete if real

    nil
  end

  def close!
    close(true)

    nil
  end

  def delete
    File.delete(@path)
    @deleted = true
    @@tempfiles.delete(self)

    self
  end

  alias :unlink :delete

  def deleted?
    @deleted
  end

  def size
    FileTest.size?(self)
  end

  alias :length :size

  def path
    deleted? ? nil : @path
  end

  def inspect
    ret = "<#{self.class}:#{@path}"
    ret += " (closed)" if closed?
    ret += ">"

    ret
  end

end
