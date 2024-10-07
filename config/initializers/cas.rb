=begin 

JUST REMOVE "=begin" AND "=end" TO REMOVE COMMENTS!

require 'casclient'
require 'casclient/frameworks/rails/filter'

CAS_BASE_URL = 'https://cas.sfu.ca/cas'

CASClient::Frameworks::Rails::Filter.configure(
  cas_base_url: CAS_BASE_URL,
  login_url: "#{CAS_BASE_URL}/login",
  logout_url: "#{CAS_BASE_URL}/logout",
  service_validate_url: "#{CAS_BASE_URL}/serviceValidate",  # Validates CAS tickets
  service_url: 'http://localhost:3000/cas_sessions/create'   # callback URL
)

Rails.logger.info "CAS Client configured with base URL: #{CAS_BASE_URL}"  # Log CAS client configuration

=end