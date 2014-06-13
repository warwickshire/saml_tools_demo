class ServicesController < ApplicationController
  def new
  end
  
  def create
    saml = SamlTool::ErbBuilder.new(
      template: saml_request_template,
      settings: request_settings
    )
    
    if params[:just_display_request] != '1'
      
      encoded_saml = SamlTool::Encoder.encode(saml.to_s)
      
      redirect_uri = SamlTool::Redirect.uri(
        to: request_settings.idp_sso_target_url,
        data: {
          'SAMLRequest' => encoded_saml
        }
      )
      redirect_to redirect_uri
      
    else
      @saml_request = saml
      render :new     
    end
  end
  
  def saml_request_template
    File.read File.expand_path('services/request.saml.erb', view_paths.first)
  end
  
  def request_settings
    @request_settings ||= SamlTool::Settings.new(
      assertion_consumer_service_url: 'http://localhost:3000/services',
      issuer:                         'http://localhost:3000',
      idp_sso_target_url:             'http://localhost:3000/identifies/new',
      idp_cert_fingerprint:           '9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D',
      name_identifier_format:         'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
      # Optional for most SAML IdPs
      authn_context:                  "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
    )
  end
 
end
