# Fact: tuned_version
# Fact: tuned_profile
# Fact: tuned_profiles
#
# Purpose: Various tuned facts
#
Facter.add('tuned_version') do
  confine :kernel => :linux
  setcode do
    out = Facter::Core::Execution.exec('tuned --version 2>&1')
    if out && out =~ %r{^tuned ([\d\.]+)$}i
      Regexp.last_match(1)
    else
      out = Facter::Core::Execution.exec('which tuned 2>/dev/null')
      if ! out || out.empty?
        'unknown'
      end
    end
  end
end

Facter.add('tuned_profile') do
  confine :kernel => :linux
  setcode do
    result = nil

    out = Facter::Core::Execution.exec('tuned-adm active 2>/dev/null')
    if out && out =~ %r{^Current active profile: (.*)$}
      result = Regexp.last_match(1)
    end

    if result.nil?
      alternatives = [
        '/etc/tuned/active_profile',
        '/etc/tune-profiles/active-profile',
      ]

      alternatives.each do |fn|
        if FileTest.exists?(fn)
          result = File.foreach(fn).first.chomp
          break
        end
      end
    end

    result
  end
end

Facter.add('tuned_profiles') do
  confine :kernel => :linux
  setcode do
    result = nil

    out = Facter::Core::Execution.exec('tuned-adm list 2>/dev/null')
    if out
      result = []
      out.each_line do |l|
        if l =~ %r{^- ([^ \n]+)}
          result << Regexp.last_match(1)
        end
      end
    end

    result
  end
end
