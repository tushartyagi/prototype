require_relative '../../../lib/open_source'

class Webhooks::ContributorsController < WebhooksController
  before_action :verify_github_webhook

  def create
    contribution = OpenSource::Contribution.new(request.request_parameters)

    unless contribution.complete?
      head :no_content and return
    end

    contributor = Contributor.with_contribution(contribution)

    if contributor.save
      head :no_content
    else
      message = "Failed to save event with X-GitHub-Delivery: %s" % github_delivery
      render json: {error: message}, status: 500
    end
  end

  private

  def verify_github_webhook
    payload = request.raw_post
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload)
    if !Rack::Utils.secure_compare(signature, github_signature)
      render json: {error: 'invalid signature - delivery: %s' % github_delivery}, status: 500
    end
  end

  def secret
    ENV['GITHUB_WEBHOOK_SECRET'] || 'hot fudge sundae' # default for test env
  end

  def github_signature
    request.env['HTTP_X_HUB_SIGNATURE']
  end

  def github_delivery
    request.headers['HTTP_X_GITHUB_DELIVERY']
  end
end
