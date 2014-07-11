module GcmProxy
  class Worker
    
    def self.run
      @stop = false
      Signal.trap("INT")  { @stop = true }
      Signal.trap("TERM")  { @stop = true }

      puts "Started GCM Proxy worker..."

      loop do

        #
        # Get all notifications which need pushing to Google and loop through them all.
        #
        sleep = true
        Notification.requires_pushing.unlocked.find_each do |notification|
          #
          # Don't sleep if we did work on this loop
          #
          sleep = false
          
          #
          # Get a lock?
          #
          if Notification.where(:id => notification.id, :locked => false).update_all({:locked => true}) != 1
            puts "[N#{notification.id.to_s.rjust(7, '0')}] Couldn't get lock on notification"
            next
          end
          
          # 
          # Check that we should still send this notification
          #
          if notification.created_at < 5.minutes.ago
            puts "[N#{notification.id.to_s.rjust(7, '0')}] Expiring notification"
            notification.mark_as_failed!(2000)
            next
          end

          #
          # Send the notification
          #
          http = Net::HTTP.new("android.googleapis.com", 443)
          http.use_ssl = true
          request = Net::HTTP::Post.new("/gcm/send")
          request.body = notification.to_hash.to_json
          request["Content-Type"] = "application/json"
          request["Authorization"] = "key=#{notification.auth_key.application.api_key}"
          response = http.request(request)
          puts response.inspect
          if response.is_a?(Net::HTTPSuccess)
            response_hash = JSON.parse(response.body)
            if response_hash['success'].to_i == 1
              notification.mark_as_pushed!
            else
              notification.mark_as_failed!(response_hash["results"][0]["error"])
            end
          else
            notification.mark_as_failed!(response.body)
          end
        end
        break if @stop
        sleep 1 if sleep
        break if @stop
      end
    end
    
  end
end