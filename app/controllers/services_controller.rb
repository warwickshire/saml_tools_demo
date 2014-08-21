class ServicesController < ApplicationController
  def new
  end
  
  def create
    saml = SamlTool::ErbBuilder.build(
      template: saml_request_template,
      settings: request_settings
    )
    
    encoded_saml = SamlTool::Encoder.encode(saml)

    redirect_uri = SamlTool::Redirect.uri(
      to: request_settings.idp_sso_target_url,
      data: {
        'SAMLRequest' => encoded_saml
      }
    )
    redirect_to redirect_uri  

  end
  
  def update
    @request_data = SamlTool::Decoder.decode(params['SAMLResponse'])
    @response_saml = SamlTool::ResponseReader.new(@request_data)
    @saml = SamlTool::Reader.new(@request_data, name_id: '//saml:NameID/text()')
    @response_valid = @response_saml.valid?
  end
  
  private
  def saml_request_template
    File.read File.expand_path('services/request.saml.erb', view_paths.first)
  end
  
  def request_settings
    @request_settings ||= SamlTool::Settings.new(
      assertion_consumer_service_url: 'http://localhost:3000/services/1',
      issuer:                         'http://localhost:3000',
      idp_sso_target_url:             'http://localhost:3000/identifies/new',
      idp_cert_fingerprint:           '9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D',
      name_identifier_format:         'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
      # Optional for most SAML IdPs
      authn_context:                  "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
    )
  end
 
end
