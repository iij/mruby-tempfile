assert('Tempfile remove tempfile (when GC run)') do
  t = Tempfile.new 'test'
  path = t.path
  assert_true File.exist?(path)
  t.close
  assert_true File.exist?(path)
  t = nil
  GC.start
  assert_false File.exist?(path)
end

