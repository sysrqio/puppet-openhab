# Find zwave file
Facter.add('openhab_habmin_jar') do
    setcode do
        Dir.glob("/usr/share/openhab/webapps/habmin/addons/org.openhab.io.habmin*.jar").first
    end
end
