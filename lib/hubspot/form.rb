module Hubspot
  class Form
    def initialize(form_guid)
      @form_guid = form_guid
    end

    def url
      Hubspot::Utils.generate_url("/uploads/form/v2/:portal_id/:form_guid", {form_guid: @form_guid}, {base_url: "https://forms.hubspot.com", hapikey: false})
    end
    # 204 when the form submissions is sucessful
    # 404 when the Form GUID is not found for the provided Portal ID
    # 500 when an internal server error occurs
    def submit!(params={})
      resp = HTTParty.post(url, body: params)
      raise(Hubspot::ContactExistsError.new(resp, "Form GUID is not correct")) if resp.code == 404
      raise(Hubspot::RequestError.new(resp, "Form submission was not submitted successfully")) unless resp.success?
      resp.code #Hubspot::Contact.new(resp.parsed_response)
    end
  end
end
