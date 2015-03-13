class Auditor
  def initialize(audit_file)
    @audit_file = audit_file
  end

  def audit(value)
    File.open(@audit_file, 'a') do |w|
      w.puts(value)
    end
  end
end
