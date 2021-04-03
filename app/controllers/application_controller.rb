class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch('MOS_USER', nil), password: ENV.fetch('MOS_PASSWORD', nil) 
end
