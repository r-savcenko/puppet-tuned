# Fact: tuned_version
# Fact: tuned_profile
# Fact: tuned_profiles
#
# Purpose: Various tuned facts
#
Facter.add("tuned_version") do
  confine :kernel => :linux
  setcode do
    out = Facter::Core::Execution.exec('tuned --version 2>&1')
    if out and out =~ /^tuned ([\d\.]+)$/i
      $1
    elsif Facter::Core::Execution.exec('which tuned 2>/dev/null')
      'unknown'
    end
  end
end

Facter.add("tuned_profile") do
  confine :kernel => :linux
  setcode do
    result = nil

    out = Facter::Core::Execution.exec('tuned-adm active 2>/dev/null')
    if out and out =~ /^Current active profile: (.*)$/
      result = $1
    end

    if result.nil?
      alternatives = [
       '/etc/tuned/active_profile',
       '/etc/tune-profiles/active-profile'
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

Facter.add("tuned_profiles") do
  confine :kernel => :linux
  setcode do
    result = nil

    out = Facter::Core::Execution.exec('tuned-adm list 2>/dev/null')
    if out
      result = []
      out.each_line do |l|
        if l =~ /^- ([^ \n]+)/
          result << $1
        end
      end
    end

    result
  end
end
