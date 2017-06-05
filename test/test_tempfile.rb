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
