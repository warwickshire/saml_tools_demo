class IdentifiesController < ApplicationController
  def new
    session['SAMLRequest'] = params['SAMLRequest']
    @saml = SamlTool::Decoder.decode(params['SAMLRequest'])
    @data = SamlRequestReader.new(@saml)
  end
  
  def create
    request_data = SamlTool::Decoder.decode(session['SAMLRequest'])
    @saml_request = SamlRequestReader.new(request_data)
    saml = SamlTool::ErbBuilder.build(
      template: saml_response_template,
      settings: response_settings
    )
    unsigned_assertion = Xmldsig::SignedDocument.new(saml)
    signed_assertion = unsigned_assertion.sign(private_key)
    render xml: signed_assertion
  end
  
  private
  def saml_response_template
    File.read File.expand_path('identifies/response.saml.erb', view_paths.first)
  end
  
  def response_settings
    @response_settings ||= SamlTool::Settings.new(
      issuer: root_url,
      name_id: params['email'],
      not_on_or_after: 10.minutes.from_now.utc.iso8601,
      request: @saml_request,
      attributes: {
        email: params['email']
      }
    )
  end

  def private_key
    @private_key ||= OpenSSL::PKey::RSA.new(pem_file, 'hello')
  end

  def pem_file
    File.read pem_file_path
  end

  def pem_file_path
    File.expand_path 'example_files/userkey.pem', Rails.root
  end
end
