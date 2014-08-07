

class SamlRequestReader < SamlTool::Reader
  def initialize(saml)
    super(
      saml,
      {
        assertion_consumer_service_url: 'samlp:AuthnRequest/@AssertionConsumerServiceURL',
        destination: 'samlp:AuthnRequest/@Destination',
        id: 'samlp:AuthnRequest/@ID',
        issue_instant: 'samlp:AuthnRequest/@IssueInstant',
        issuer: 'samlp:AuthnRequest/saml:Issuer/text()'
      }
    )
  end
end
