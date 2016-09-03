#get uuid 
Facter.add('openhab_uuid') do
      setcode do
        Facter::Core::Execution.exec('/bin/cat /opt/openhab/webapps/static/uuid')
      end
    end
