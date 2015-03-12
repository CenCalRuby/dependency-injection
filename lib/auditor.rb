class Auditor
  def audit(value)
    File.open('audit.txt', 'a') do |w|
      w.puts(value)
    end
  end
end
