def capture_stdout
  original_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  yield
  fake_stdout.string
ensure
  $stdout = original_stdout
end
