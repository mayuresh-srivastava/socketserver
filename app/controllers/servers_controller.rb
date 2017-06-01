class ServersController < ApplicationController
	$connection, $kill = {}, {}
	
	def rqst
		connId = params[:connId]
    $connection[connId] = params[:timeout]
    var = connId + "times"
    $connection[var] = Time.new.to_i
    current_time = Time.new.to_i
    start_time = $connection[var]
    timeout = $connection[connId].to_i
    while (current_time-start_time <= timeout)
      if $kill[connId] == true
        status = 1 
        break
      end
      current_time = Time.new.to_i
    end
    $connection.delete(connId)
    $connection.delete(var)
    
    if status == 1
      $kill[connId] = false
      render json: {"status":"killed"}, status: 200
    else
      render json: {"status":"ok"}, status: 200
    end
	end

	def status
		status = {}
		$connection.each do |key,value|
		if key.ends_with?"times"
		  val = $connection[key.chomp("times")].to_i
		  if Time.new.to_i-value >= val
		    $connection.delete(key.chomp("times"))
		    $connection.delete(key)
		  else
		    status[key.chomp("times")] = (val-(Time.new.to_i-value)).to_s
		  end
		end
		end
		render json: status.to_json
	end

	def kill
		$connection.each do |key,value|
    if key.ends_with?"times"
      val = $connection[key.chomp("times")].to_i
      if Time.new.to_i-value >= val
        $connection.delete(key.chomp("times"))
        $connection.delete(key)
      end
    end
    end

    var = params[:connId].to_s
    $kill[var] = true
    status = {}
    status[:status] = "Invalid connection id: " + params[:connId]
    if $connection[var]
      render json: {"status":"ok"}
    else
      render json: status.to_json
    end
  end

	def four_o_four
		response = {
		  error: { message: "Page not found." },
		}
		
		render json: response, status: 404
	end

end