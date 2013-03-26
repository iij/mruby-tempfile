# -*- coding: utf-8 -*-

class Tempfile < File
  def initialize(basename, tempdir = Dir::tmpdir)
    @deleted = false
    @basename = basename
    @mode = "w+"
    @perm = 0600
    @path = @path || make_tmpname(basename, tempdir)

    super(@path, @mode, @perm)
  end

  def self.open(basename, tempdir = Dir::tmpdir, &block)
    tempfile = self.new(basename, tempdir)

    return tempfile unless block

    begin
      yield tempfile
    ensure
      begin
        tempfile.close unless tempfile.closed?
      rescue => e
      end
    end

  end

  def make_tmpname(basename, tempdir, n=nil)
    rand_max = 0x100000000
    t = Time.now
    ymd = t.year.to_s + t.month.to_s +  t.day.to_s
    pid = Tempfile._getpid

    rand_val = rand(t.usec)

    while rand_val > rand_max
      rand_val = rand(Time.now.usec)
    end

    if Array === basename
      prefix = basename[0]
      suffix = basename[1]
    elsif String === basename
      prefix = basename
      suffix = nil
    else
      raise ArgumentError, "basename is invalied."
    end

    path = "#{tempdir}/#{prefix}#{ymd}-#{pid}-#{rand_val.to_s(36)}"
    path += "-#{suffix}" if suffix

    while File.exist?(path)
      n = n || 0
      path = "#{tempdir}/#{prefix}#{ymd}-#{pid}-#{rand_val.to_s(36)}-#{n}{suffix}"
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

end

