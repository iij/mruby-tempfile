assert('Tempfile remove tempfile (when GC run)') do
  t = Tempfile.new 'test'
  path = t.path
  assert_true File.exist?(path)
  t.close false
  assert_true File.exist?(path)
  t = nil
  GC.start
  assert_false File.exist?(path)
end

assert('Tempfile remove tempfile (call Tempfile#close with real = true)') do
  t = Tempfile.new 'test'
  path = t.path
  assert_true File.exist?(path)
  t.close true
  assert_false File.exist?(path)
end

assert('Dir.tmpdir reacts to ENV changes') do
  # Save environmental variables
  saved_env = ENV.to_hash
  names = ["TMPDIR", "TMP", "TEMP", "USERPROFILE"]
  begin
    names.each { |n| ENV.delete(n) }
    assert_equal "/tmp", Dir.tmpdir

    ENV["TMPDIR"] = "/some/where"
    assert_equal "/some/where", Dir.tmpdir
  ensure
    # Restore environmental variables
    names.each { |n| ENV[n] = saved_env[n] }
  end
  true
end

assert('Dir.mktmpdir') do
  d = Dir.mktmpdir
  assert_kind_of String, d
  Dir.rmdir d

  tmpdir = ""
  t = Dir.mktmpdir { |d|
    assert_kind_of String, d
    assert_equal "d", File.basename(d)[0]
    assert_true Dir.exist?(d)
    tmpdir = d
    :test
  }
  assert_equal :test, t
  assert_false Dir.exist?(tmpdir)

  Dir.mktmpdir("a") { |d|
    assert_equal "a", File.basename(d)[0]
  }

  Dir.mktmpdir(["a", "z"]) { |d|
    assert_equal "a", File.basename(d)[0]
    assert_equal "z", File.basename(d)[-1]
  }

  Dir.mktmpdir { |tmpdir|
    Dir.mktmpdir(nil, tmpdir) { |d|
      assert_equal tmpdir, File.dirname(d)
    }

    File.chmod 0770, tmpdir
    assert_nothing_raised("parent dir can be group writable") do
      Dir.mktmpdir(nil, tmpdir) {}
    end

    File.chmod 0777, tmpdir
    assert_raise(ArgumentError, "parent dir should not be world writable") do
      Dir.mktmpdir(nil, tmpdir) {}
    end

    File.chmod 01777, tmpdir
    assert_nothing_raised("parent dir can be world writable if it is sticky") do
      Dir.mktmpdir(nil, tmpdir) {}
    end
  }
end
