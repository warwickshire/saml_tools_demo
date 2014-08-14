class IdentifiesController < ApplicationController
  def new
    session['SAMLRequest'] = params['SAMLRequest']
    @saml = SamlTool::Decoder.decode(params['SAMLRequest'])
    @data = SamlRequestReader.new(@saml)
  end
  
  def create
    request_data = SamlTool::Decoder.decode(session['SAMLRequest'])
    @saml_request = SamlRequestReader.new(request_data)
    render xml: saml_response = SamlTool::ErbBuilder.build(
      template: saml_response_template,
      settings: response_settings
    )
  end
  
  private
  def saml_response_template
    File.read File.expand_path('identifies/response.saml.erb', view_paths.first)
  end
  
  def response_settings
    @response_settings ||= SamlTool::Settings.new(
      issuer: root_url,
      name_id: 'someone@example.com',
      not_on_or_after: 10.minutes.from_now.utc.iso8601,
      request: @saml_request,
      attributes: {
        email: params['email']
      }
    )
  end
end
