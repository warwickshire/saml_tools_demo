class IdentifiesController < ApplicationController
  def new
    @saml = SamlTool::Decoder.decode(params['SAMLRequest'])
    @data = SamlRequestReader.new(@saml)
  end
end
